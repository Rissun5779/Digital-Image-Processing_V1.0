#ifndef __INTERLACER_HPP__
#define __INTERLACER_HPP__

#include "VipCore.hpp"

class Interlacer : public VipCore {
private:
    Interlacer(const Interlacer&);  // Disable copy constructor
    int current_settings;

public:

    enum IntRegisterType {
        INTERLACER_SETTINGS   = 3
    };

    /*
     * @brief   constructor
     * @param   base_address    Base address of the slave interface (usually found in system.h)
     */
    Interlacer(long base_address);

    /*
     * @brief   enable passthough of progressive frames (no interlacing)
     */
    inline void enable_progressive_passthrough() {
        current_settings |= 0x1;
        do_write(INTERLACER_SETTINGS, current_settings);
    }

    /*
     * @brief   disable passthough of progressive frames
     */
    inline void disable_progressive_passthrough() {
        current_settings &= 0xFFFE;
        do_write(INTERLACER_SETTINGS, current_settings);
    }

    /*
     * @brief   enable passthough of already interlaced fields
     */
    inline void enable_interlace_passthrough() {
        current_settings |= 0x2;
        do_write(INTERLACER_SETTINGS, current_settings);
    }

    /*
     * @brief   disable passthough of already interlaced fields
     */
    inline void disable_interlace_passthrough() {
        current_settings &= 0xFFFD;
        do_write(INTERLACER_SETTINGS, current_settings);
    }

    /*
     * @brief   enable override of the default interlacing sequence by input control packet interlaced nibbles
     */
    inline void enable_ctrl_override() {
        current_settings |= 0x4;
        do_write(INTERLACER_SETTINGS, current_settings);
    }

    /*
     * @brief   disable override of the default interlacing sequence by input control packet interlaced nibbles
     */
    inline void disable_ctrl_override() {
        current_settings &= 0xFFFB;
        do_write(INTERLACER_SETTINGS, current_settings);
    }

    /*
     * @brief   set interlacing to start with an F1 field
     */
    inline void set_f1_first() {
        current_settings |= 0x8;
        do_write(INTERLACER_SETTINGS, current_settings);
    }

    /*
     * @brief   set interlacing to start with an F0 field
     */
    inline void set_f0_first() {
        current_settings &= 0xFFF7;
        do_write(INTERLACER_SETTINGS, current_settings);
    }

    /*
     * @brief   enable reset of the interlacing sequence after a transistion through the stop state to begin again with either F0 or F1, as defined by bit 3 of the settings register
     */
    inline void enable_reset_interlacing_after_stop() {
        current_settings |= 0x10;
        do_write(INTERLACER_SETTINGS, current_settings);
    }

    /*
     * @brief   disable reset of the interlacing sequence after a transistion through the stop state (sequence will continue where it left of prior to the stop)
     */
    inline void disable_reset_interlacing_after_stop() {
        current_settings &= 0xFFEF;
        do_write(INTERLACER_SETTINGS, current_settings);
    }
      
};

#endif   // __INTERLACER_HPP__
