#include "Push_Button_Manager.hpp"

Push_Button_Manager::Push_Button_Manager(long base_address, unsigned char debounce)
: base_address(base_address), debounce(debounce) {
    for (unsigned int i = 0; i < MAX_NUM_BUTTONS; ++i)
    {
        button_status[i] = 0;
        button_val[i] = false;
        button_pressed[i] = false;
    }
}

void Push_Button_Manager::update_status()
{
    assert(debounce != 0);
    unsigned int values = read_button_values();
    for (unsigned int i = 0; i < MAX_NUM_BUTTONS; ++i)
    {
        bool status = (values & (1 << i)) != 0;
        if ((button_status[i] != 0) && !status) {
            --button_status[i];
            if ((button_status[i] == 0) && button_val[i]){
                button_val[i] = false;
                button_pressed[i] = true;
            }
        } else if ((button_status[i] != debounce) && status) {
            ++button_status[i];
            if (button_status[i] == debounce) button_val[i] = true;
        }
    }
}

