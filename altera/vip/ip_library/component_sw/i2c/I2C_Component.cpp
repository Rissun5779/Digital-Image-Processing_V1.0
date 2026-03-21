#include "I2C_Component.hpp"

I2C_Component::I2C_Component(unsigned long base_address, unsigned char i2c_main_slave_addr,
                             long clock_rate_KHz, int irq_number)
: base_address(base_address), i2c_main_slave_addr(i2c_main_slave_addr), irq_number(irq_number) {

    // I2C initialization
    init_i2c(clock_rate_KHz);

    // Interrupt setup
    if (irq_number != -1) {
#ifdef ALT_ENHANCED_INTERRUPT_API_PRESENT
        // Enhanced mode, use prototype:
        //  extern int alt_ic_isr_register(alt_u32 ic_id, alt_u32 irq, alt_isr_func isr, void *isr_context, void *flags);
        alt_ic_isr_register(0, irq_number, genericISR, this, NULL);
#else
        // Legacy mode, use prototype:
        // extern int alt_irq_register (alt_u32 id, void* context, alt_isr_func handler)
        alt_irq_register(irq_number, this, genericISR_legacy);
#endif
    }
}

I2C_Component::~I2C_Component()
{
    // Deregister the ISR
    if (irq_number != 0) {
#ifdef ALT_ENHANCED_INTERRUPT_API_PRESENT
        alt_ic_isr_register(0, irq_number, NULL, this, NULL);
#else
        alt_irq_register(irq_number, this, NULL);
#endif
    }
}

#ifdef ALT_ENHANCED_INTERRUPT_API_PRESENT
void I2C_Component::genericISR(void* context)
#else
void I2C_Component::genericISR_legacy(void* context, alt_u32 id)
#endif
{
    I2C_Component* comp = (I2C_Component*)context;
    comp->isr();
}

void I2C_Component::isr()
{
    bool clear_interrupt = true;
    if (user_isr) {
         clear_interrupt = user_isr(this);
    }
    // Clear interrupt after the subclass interrupt routine to prevent triggering in loop
    i2c_wait_tip();
    if (clear_interrupt) {
        iowr_i2c_cr(I2C_CR_IACK);
    }
}


bool I2C_Component::i2c_write(unsigned char reg, unsigned char data, unsigned char slave_addr) {
    if (!i2c_wait_tip()) return false;

    // Write the i2c slave address to TXR register
    iowr_i2c_txr(slave_addr);
    // Set STA and WR bit
    iowr_i2c_cr(I2C_CR_STA | I2C_CR_WR | I2C_CR_ACK);
    // Wait for tip and receiver ack
    if (!i2c_wait_tip()) return false;
    if (!i2c_wait_rxnack()) return false;

    // Write register address to TXR register
    iowr_i2c_txr(reg);
    iowr_i2c_cr(I2C_CR_WR | I2C_CR_ACK);
    // Wait for tip and receiver ack
    if (!i2c_wait_tip()) return false;
    if (!i2c_wait_rxnack()) return false;

    // write data
    iowr_i2c_txr(data);
    iowr_i2c_cr(I2C_CR_STO | I2C_CR_WR | I2C_CR_IACK);
    // Wait for tip and receiver ack
    if (!i2c_wait_tip()) return false;
    if (!i2c_wait_rxnack()) return false;

    return true;
}


bool I2C_Component::i2c_read(unsigned char reg, unsigned char & data, unsigned char slave_addr) {
    if (!i2c_wait_tip()) return false;

    // write address
    iowr_i2c_txr(slave_addr);
    iowr_i2c_cr(I2C_CR_STA | I2C_CR_WR);
    if (!i2c_wait_tip()) return false;
    if (!i2c_wait_rxnack()) return false;

    // write register address
    iowr_i2c_txr(reg);
    iowr_i2c_cr(I2C_CR_WR);
    if (!i2c_wait_tip()) return false;
    if (!i2c_wait_rxnack()) return false;

    // write address for reading
    iowr_i2c_txr(slave_addr | 1);
    iowr_i2c_cr(I2C_CR_STA | I2C_CR_WR);
    if (!i2c_wait_tip()) return false;
    if (!i2c_wait_rxnack()) return false;

    // read data
    iowr_i2c_cr(I2C_CR_RD | I2C_CR_ACK | I2C_CR_STO);
    if (!i2c_wait_tip()) return false;
    if (!i2c_wait_rxnack()) return false;

    data = iord_i2c_rxr();

    return true;
}

bool I2C_Component::i2c_wait_tip() {
    for(unsigned int wait = 0; wait < WAIT_DELAY; ++wait) {
        if (!(iord_i2c_sr() & I2C_SR_TIP)) return true;
    }
    //printf("TIP wait failure\n");
    return false;
}

bool I2C_Component::i2c_wait_rxnack(void){
    for(unsigned int wait = 0; wait < WAIT_DELAY; ++wait) {
        if (!(iord_i2c_sr() & I2C_SR_RXNACK)) return true;
    }
    //printf("RXNACK wait failure\n");
    return false;
}

void I2C_Component::init_i2c(long clock_rate) {
    i2c_wait_tip();
    // Stop the i2c
    iowr_i2c_ctr(0x00);

    // Setup prescaler for 100KHz
    int prescale = (clock_rate / (5*100000)) - 1;
    iowr_i2c_prerlo(prescale & 0xff);
    iowr_i2c_prerhi((prescale & 0xff00)>>8);

    // Enable core (without interrupts)
    iowr_i2c_ctr(0x80);
    i2c_wait_tip();
}
