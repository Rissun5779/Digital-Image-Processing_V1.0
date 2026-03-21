#ifndef __I2C_COMPONENT_HPP__
#define __I2C_COMPONENT_HPP__

#include <system.h>
#include <io.h>
#include <sys/alt_irq.h>
#include <cassert>

// Software model to control the OpenCores I2C Master

// Overall status and control
class I2C_Component
{
public:
    static const unsigned int I2C_CR_STA   = 0x80;
    static const unsigned int I2C_CR_STO   = 0x40;
    static const unsigned int I2C_CR_RD    = 0x20;
    static const unsigned int I2C_CR_WR    = 0x10;
    static const unsigned int I2C_CR_ACK   = 0x08;
    static const unsigned int I2C_CR_IACK  = 0x01;
    
    static const unsigned int I2C_SR_RXNACK  = 0x80;
    static const unsigned int I2C_SR_TIP     = 0x02;
    static const unsigned int I2C_SR_IF      = 0x01;

    static const unsigned int WAIT_DELAY     = 1000;

    /**
     * @brief  Register a callback function to do custom processing during interrupt servicing
     * @param  user_isr               the callback function.
     *                                It's API is as follows bool user_isr(I2C_Component* this)
     *                                Returning false will leave the interrupt(s) raised.
     *                                Use NULL to disable the callback.
     * @pre   irq_number != -1        A valid IRQ number must have been specified at construction (otherwise registering
     *                                a callback would not make much sense)
     */
    inline void register_user_isr(bool (*user_isr)(I2C_Component*))
    {
        assert(irq_number != -1);
        this->user_isr = user_isr;
    }

    /**
     * @brief   Enable interrupt from the opencores's i2c master
     */
    inline void enable_i2c_interrupt() {
        iowr_i2c_ctr(0xC0);
    }

    /**
     * @brief   Disable interrupt from the opencores's i2c master
     */
    inline void disable_i2c_interrupt() {
        iowr_i2c_ctr(0x80);
    }
    
    /**
     * @brief   I2C write function
     * @param   reg,  targetted register
     * @param   data, value to write
     * @post    Sends write instruction to the default slave (as defined at construction by i2c_slave_addr)
     */
    inline bool i2c_write(unsigned char reg, unsigned char data) {
        return i2c_write(reg, data, i2c_main_slave_addr);
    }

    /**
     * @brief   I2C write function
     * @param   reg,  targetted register
     * @param   data, value to write
     * @param   slave_addr, I2C slave address
     * @post    Sends write instruction to the designed slave
     */
    bool i2c_write(unsigned char reg, unsigned char data, unsigned char slave_addr);

    /**
     * @brief   I2C read function
     * @param   reg,  targetted register
     * @param   data, read-back value (returned by reference)
     * @post    Sends read instruction to the default slave (as defined at construction by i2c_slave_addr)
     */
    bool i2c_read(unsigned char reg, unsigned char & data) {
        return i2c_read(reg, data, i2c_main_slave_addr);
    }

    /**
     * @brief   I2C read function
     * @param   reg,  targetted register
     * @param   data, read-back value (returned by reference)
     * @param   slave_addr, I2C slave address
     * @post    Sends read instruction to the designed slave
     */
    bool i2c_read(unsigned char reg, unsigned char & data, unsigned char slave_addr);
    
    /**
     * @brief   I2C TIP wait
     */
    bool i2c_wait_tip();
    
    /**
     * @brief   I2C RXNACK wait
     */
    bool i2c_wait_rxnack(void);


protected:
    /**
     * I2C_Component
     * @brief     Constructor, create and init the I2C component
     * @param     base_address
     * @param     i2c_slave_addr
     * @param     clock_rate_KHz,   clock rate (in KHz)
     * @param     optional IRQ number to enable interrupts
     */
    I2C_Component(unsigned long base_address, unsigned char i2c_slave_addr,
                  long clock_rate_KHz, int irq_number = -1);

    /**
     * ~I2C_Component
     * @brief     Destructor, clean up the I2C component
     */
    ~I2C_Component();

#ifdef ALT_ENHANCED_INTERRUPT_API_PRESENT
    // Interrupt service routine registered by the core at construction if the user specified an irq number (new api)
    static void genericISR(void* context);
#else
    // Interrupt service routine registered by the core at construction if the user specified an irq number (legacy api)
    static void genericISR_legacy(void* context, alt_u32 id);
#endif

    inline void iowr_i2c_prerlo(unsigned char data) {
        IOWR(base_address, 0, data);
    }
    inline void iowr_i2c_prerhi(unsigned char data) {
        IOWR(base_address, 1, data);
    }
    inline void iowr_i2c_ctr(unsigned char data) {
        IOWR(base_address, 2, data);
    }
    inline void iowr_i2c_txr(unsigned char data) {
        IOWR(base_address, 3, data);
    }
    inline void iowr_i2c_cr(unsigned char data) {
        IOWR(base_address, 4, data);
    }

    inline unsigned char iord_i2c_prerlo() {
        return IORD(base_address, 0);
    }
    inline unsigned char iord_i2c_prerhi() {
        return IORD(base_address, 1);
    }
    inline unsigned char iord_i2c_ctr() {
        return IORD(base_address, 2);
    }
    inline unsigned char iord_i2c_rxr() {
        return IORD(base_address, 3);
    }
    inline unsigned char iord_i2c_sr() {
        return IORD(base_address, 4);
    }

private:
    /**
     * init_i2c
     * @brief     Init the I2C component (automatically called at construction)
     * @param     clock_rate
     */
    void init_i2c(long clock_rate);

    /**
     * @brief   Generic interrupt service routine. If the user specified a callback function, it will be called and
     *          its return value will determine whether the interrupt should be cleared. The interrupt is always cleared
     *          when no callback function was defined
     */
    void isr();

    unsigned long base_address;
    unsigned char i2c_main_slave_addr; // Main address of the I2C slave (bit 0 is the write bit)
    int irq_number;
    bool (*user_isr)(I2C_Component*);
};

#endif   // __I2C_COMPONENT_HPP__
