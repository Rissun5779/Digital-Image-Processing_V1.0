#ifndef __STREAM_CLEANER_HPP__
#define __STREAM_CLEANER_HPP__

#include "VipCore.hpp"


class Stream_Cleaner : public VipCore {
private:
    Stream_Cleaner(const VipCore&);  // Disable copy constructor

public:

    enum STCRegisterType {
        STC_NON_MODULO           = 3,
        STC_WIDTH_TOO_SMALL      = 4,
        STC_WIDTH_TOO_BIG        = 5,
        STC_HEIGHT_TOO_SMALL     = 6,
        STC_HEIGHT_TOO_BIG       = 7,
        STC_NO_VALID_CONTROL     = 8,
        STC_INTERLACED_TOO_BIG   = 9,
        STC_MISMATCH_PAD         = 10,
        STC_MISMATCH_CROP        = 11,
        STC_COUNT_RESET          = 12
    };


    /*
     * @brief   constructor
     * @param   base_address    Base address of the slave interface (usually found in system.h)
     */
    Stream_Cleaner(unsigned long base_address);

    /*
     * @brief  read the debug count of the number of frames with non-modulo width encountered
     */
    inline int get_non_modulo_error_count() {
       return do_read(STC_NON_MODULO);
    }

    /*
     * @brief  read the debug count of the number of frames encountered with widths below the minimum 
     */
    inline int get_width_too_small_count() {
       return do_read(STC_WIDTH_TOO_SMALL);
    }

    /*
     * @brief  read the debug count of the number of frames encountered with widths above the maximum 
     */
    inline int get_width_too_big_count() {
       return do_read(STC_WIDTH_TOO_BIG);
    }

    /*
     * @brief  read the debug count of the number of frames encountered with heights below the minimum 
     */
    inline int get_height_too_small_count() {
       return do_read(STC_HEIGHT_TOO_SMALL);
    }

    /*
     * @brief  read the debug count of the number of frames encountered with heights above the maximum 
     */
    inline int get_height_too_big_count() {
       return do_read(STC_HEIGHT_TOO_BIG);
    }

    /*
     * @brief  read the debug count of the number of frames encountered with no valid control packet 
     */
    inline int get_no_control_count() {
       return do_read(STC_NO_VALID_CONTROL);
    }

    /*
     * @brief  read the debug count of the number of oversize interlaced fields encountered
     */
    inline int get_interlaced_too_big_count() {
       return do_read(STC_INTERLACED_TOO_BIG);
    }

    /*
     * @brief  read the debug count of the number of frames encountered that are smaller than their control packets indicate
     */
    inline int get_mismatch_pad_count() {
       return do_read(STC_MISMATCH_PAD);
    }

    /*
     * @brief  read the debug count of the number of frames encountered that are larger than their control packets indicate
     */
    inline int get_mismatch_crop_count() {
       return do_read(STC_MISMATCH_CROP);
    }

    /*
     * @brief  reset the values of all debug counter to 0
     */
    inline void reset_debug_counts() {
       do_write(STC_COUNT_RESET, 0);
    }

};

#endif   // __STREAM_CLEANER_HPP__
