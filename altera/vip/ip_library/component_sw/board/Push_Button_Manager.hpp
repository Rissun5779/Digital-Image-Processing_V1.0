#ifndef __PUSH_BUTTON_MANAGER_HPP__
#define __PUSH_BUTTON_MANAGER_HPP__

#include <io.h>
#include <system.h>
#include <cassert>

class Push_Button_Manager
{
public:
    static const unsigned int MAX_NUM_BUTTONS = 8;
    
    /**
     * constructor
     * @param  base_address   the base address of the slave interface for the push buttons component
     * @param  debounce       signed char value to set up the debounce algorithm (to avoid spurious swaps between 0 and 1), use 0 to disable debounce
     * @pre    debounce >= 0
     * @post   set up the push button manager
     */
    Push_Button_Manager(long base_address, unsigned char debounce = 8);

    /**
     * read_button_values()
     * @return  Read the mask of all enabled button switchs (address 0 of the dip manager)
     * @post    Return a raw value of the current button pressed state (bypassing the debounce)
     */
    inline unsigned int read_button_values() {
        return ~IORD(base_address, 0) & ((1 << MAX_NUM_BUTTONS) - 1);
    }    
    
    /**
     * is_button_pressed()
     * @param   button_number, the button id
     * @return  whether the selected button is currently pressed (after debounce smoothing)
     * @pre     button_number < MAX_NUM_BUTTONS
     */
    inline bool is_button_pressed(unsigned int button_number) {
        if (debounce != 0){
            update_status();
            return button_val[button_number];
        } else {
            return (read_button_values() & (1 << button_number)) != 0;
        }
    }
    
    /**
     * button_released()
     * @param   button_number, the button id
     * @return  whether the selected button was previously pressed (the release must have happened)
     * @pre     button_number < MAX_NUM_BUTTONS
     * @pre     this only works when debounce is enabled (ie, debounce > 0)
     * @post    this clears button_pressed[button_number] so that it returns false for the next call
     */
    inline bool button_released(unsigned int button_number) {
        assert(debounce != 0);
        update_status();
        bool was_pressed = button_pressed[button_number];
        button_pressed[button_number] = false;
        return was_pressed;
    }

private:
    void update_status();

    long base_address;
    unsigned char debounce;
    
    signed char button_status[MAX_NUM_BUTTONS];
    bool button_val[MAX_NUM_BUTTONS];
    bool button_pressed[MAX_NUM_BUTTONS];
};
    

#endif  // __LED_MANAGER_HPP__
