#ifndef __TEST_PATTERN_GENERATOR_HPP__
#define __TEST_PATTERN_GENERATOR_HPP__

#include "VipCore.hpp"

class Test_Pattern_Generator : public VipCore {
private:
    Test_Pattern_Generator(const Test_Pattern_Generator&);  // Disable copy constructor

public:

    enum TPGRegisterType {
        TPG_WIDTH                = 4,
        TPG_HEIGHT               = 5,
        TPG_INTERLACED           = 6,
        TPG_SELECT               = 7,
        TPG_R_Y                  = 8,
        TPG_G_CB                 = 9,
        TPG_B_CR                 = 10
    };

    /*
     * @brief   constructor
     * @param   base_address    Base address of the slave interface (usually found in system.h)
     */
    Test_Pattern_Generator(long base_address);

    /*
     * @brief   change the output width
     * @param   width     New output width
     */
    inline void set_width(int width) {
        do_write(TPG_WIDTH, width);
    }

    /*
     * @brief   change the output height
     * @param   height     New output height
     */
    inline void set_height(int height) {
        do_write(TPG_HEIGHT, height);
    }

    /*
     * @brief   change the output interlacing
     * @param   is_interlaced     Set true to generate interlaced output, false for progressive
     * @param   is_f1_first       Not used if is_interlaced is false, otherwise set true to start the interlaced sequence with an F1 field, false for F0
     */
    inline void set_interlaced(bool is_interlaced, bool is_f1_first) {
        int write_val = 0;
        if (is_interlaced) {
            if (is_f1_first) {
               write_val = 3;
            } else {
               write_val = 1;
            }
        }
        do_write(TPG_INTERLACED, write_val);
    }

    /*
     * @brief   select the output test pattern (only relevant if multiple patterns have been enabled in the HW)
     * @param   pattern_num     New selected output pattern
     */
    inline void select_pattern(int pattern_num) {
        do_write(TPG_SELECT, pattern_num);
    }

    /*
     * @brief   set the output color for the uniform test pattern(s) (only relevant if at least one uniform pattern is enabled in the HW)
     * @param   r_y     New value for the red (if RGB) or luma (if YCbCr) color plane
     * @param   g_cb    New value for the green (if RGB) or Cb (if YCbCr)  color plane
     * @param   b_cr    New value for the blue (if RGB) or Cr (if YCbCr)  color plane
     */
    inline void set_uniform_color(int r_y, int g_cb, int b_cr) {
        do_write(TPG_R_Y, r_y);
        do_write(TPG_G_CB, g_cb);
        do_write(TPG_B_CR, b_cr);
    }

    /*
     * @brief   enable the black border around the bars test patterns (only relevant if at least one bars pattern is enabled in the HW)
     */
    inline void enable_bars_border() {
        set_control_bit(1);
    }

    /*
     * @brief   disable the black border around the bars test patterns (only relevant if at least one bars pattern is enabled in the HW)
     */
    inline void disable_bars_border() {
        unset_control_bit(1);
    }

};

#endif   // __TEST_PATTERN_GENERATOR_HPP__
