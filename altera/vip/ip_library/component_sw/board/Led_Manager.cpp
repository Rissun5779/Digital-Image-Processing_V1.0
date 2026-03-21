#include "Led_Manager.hpp"

void Led_Manager::intro_sequence(unsigned int delay) {
    turn_all_on();
    for (unsigned int i = 0; i < delay ; ++i) {};
    turn_all_off();
    for (unsigned int i = 0; i < delay ; ++i) {};
    turn_all_on();
    for(unsigned int led = 0; led < MAX_NUM_LEDS ; ++led)
    {
        for (unsigned int i = 0; i < delay ; ++i) {};
        turn_led_off(7-led);
    }
    for(unsigned int led = 0; led < MAX_NUM_LEDS ; ++led)
    {
        for (unsigned int i = 0; i < delay ; ++i) {};
        turn_led_on(led);
    }
    for (unsigned int i = 0; i < delay ; ++i) {};
    turn_all_off();
}
