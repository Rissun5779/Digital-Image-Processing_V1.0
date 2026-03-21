#ifndef __LED_MANAGER_HPP__
#define __LED_MANAGER_HPP__

#include <io.h>
#include <system.h>

class Led_Manager
{
public:
    static const unsigned int MAX_NUM_LEDS = 8;
    static const unsigned int LED_MASK = (1 << MAX_NUM_LEDS) - 1;

    /**
     * Dip manager constructor
     * @param  base_address   the base address of the slave interface for the leds component
     */
    Led_Manager(long base_address)
    : base_address(base_address) {
        turn_all_off();
    }

    /**
     * turn_led_off
     * @param  led_id      the led ID
     * @post   turn the specified led off (write a 1 to the given bit at the base address of the led manager)
     */
    inline void turn_led_off(unsigned int led){
        switch_led(led, false);
    }

    /**
     * turn_led_on
     * @param  led_id      the led ID
     * @post   turn the specified led on (write a 1 to the given bit at the base address of the led manager)
     */
    inline void turn_led_on(unsigned int led) {
        switch_led(led, true);
    }

    /**
     * turn_led_on
     * @param  led_id      the led ID
     * @param  turn_on     true to turn the led on, false to turn it off
     * @post   turn the specified led to the required state (write a 1/0 to the led bit at the base address of the led manager to turn if off/on)
     */
    void switch_led(unsigned int led, bool on){
        unsigned int led_mask = (1 << led);
        led_program(on ? (led_value & ~led_mask) : (led_value | led_mask));
    }

    /**
     * set_leds
     * @param  led_mask    a mask that specifies the state of each led (0 for off, 1 for on)
     * @post   Write ~led_mask at the base address of the led manager which puts the leds in the requested state
     */
    inline void set_leds(unsigned int led_mask){
        led_program(~led_mask);
    }

    /**
     * turn_all_off
     * @post   Turn all leds off
     */
    inline void turn_all_off() {
        led_program(LED_MASK);
    }

    /**
     * turn_all_on
     * @post   Turn all leds on
     */
    inline void turn_all_on() {
        led_program(0); 
    }

    /**
     * intro_sequence
     * @post   Runs a small intro sequence
     */
    void intro_sequence(unsigned int delay = 200000);

private:
    inline void led_program(int value){
        led_value = value & LED_MASK;
        IOWR(base_address, 0, led_value);
    }

    long base_address;

    unsigned int led_value; // Keep local copy of the state so we can manipulate LEDs individually
};


#endif  // __LED_MANAGER_HPP__
