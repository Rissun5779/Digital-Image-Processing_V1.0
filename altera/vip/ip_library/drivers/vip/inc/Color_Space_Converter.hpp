#ifndef __COLOR_SPACE_CONVERTER_HPP__
#define __COLOR_SPACE_CONVERTER_HPP__

#include "VipCore.hpp"

#include "VipMath.hpp"

// Some convenient defines to use when trying to set up a color space conversion
// WARNING: the summand values given here are given assuming input_bps == 8.
// If you use these defines with input_bps != 8, you probably want to set summand_rescale to input_bps - 8
// in the API given below

#define CSC_PASSTHROUGH_COEFFS       1.0f, 0.0f, 0.0f,\
                                     0.0f, 1.0f, 0.0f,\
                                     0.0f, 0.0f, 1.0f,\
                                     0.0f, 0.0f, 0.0f

#define CSC_RGB_TO_YCBCRHD_COEFFS    0.439f,   -0.338f,  -0.101f,\
                                    -0.040f,   -0.399f,   0.439f,\
                                     0.062f,    0.614f,   0.183f,\
                                   512.000f,  512.000f,  64.000f

#define CSC_YCBCRHD_TO_RGB_COEFFS    2.115f,    0.000f,   1.164f,\
                                    -0.213f,   -0.534f,   1.164f,\
                                     0.000f,    1.793f,   1.164f,\
                                 -1157.376f,  307.968f,-992.512f

#define CSC_RGB_TO_YCBCRSD_COEFFS   -0.083f,   -0.428f,   0.511f,\
                                     0.114f,    0.587f,   0.299f,\
                                     0.511f,   -0.339f,  -0.172f,\
                                   128.000f,    0.000f, 128.000f


#define CSC_YCBCRSD_TO_RGB_COEFFS    0.000f,    1.000f,   1.732f,\
                                    -0.698f,    1.000f,  -0.336f,\
                                     1.371f,    1.000f,   0.000f,\
                                  -221.696f,  132.352f,-175.488f
                                  
class Color_Space_Converter : public VipCore {
private:
    Color_Space_Converter(const Color_Space_Converter&);  // Disable copy constructor

public:
    // CSC specific registers
    enum CSCRegisterType {
        CSC_COEFF_COMMIT_MODE = 3,
        CSC_COEFFICIENT_A0    = 4,
        CSC_COEFFICIENT_B0    = 5,
        CSC_COEFFICIENT_C0    = 6,
        CSC_COEFFICIENT_A1    = 7,
        CSC_COEFFICIENT_B1    = 8,
        CSC_COEFFICIENT_C1    = 9,
        CSC_COEFFICIENT_A2    = 10,
        CSC_COEFFICIENT_B2    = 11,
        CSC_COEFFICIENT_C2    = 12,
        CSC_SUMMAND_S0        = 13,
        CSC_SUMMAND_S1        = 14,
        CSC_SUMMAND_S2        = 15,
    };

    /**
     * @brief  constructor
     * @param  base_address                   The slave interface base address (hash-defined in system.h)
     * @param  coeff_signed                   Whether the coefficients are signed (adds one extra integer bit)
     * @param  coeff_int_bits                 Number of integer bits for the coefficients
     * @param  summand_signed                 Whether the summands are signed (adds one extra integer bit)
     * @param  summand_int_bits               Number of integer bits for the coefficients
     * @param  coeff_summand_fraction_bits    Number of fraction bits for the coefficients and summands
     */
    Color_Space_Converter(unsigned long base_address, bool coeff_signed, unsigned int coeff_int_bits, bool summand_signed, unsigned int summand_int_bits, unsigned int coeff_summand_fraction_bits);

    /**
     * @brief  Write new CSC coefficients and commit the change
     * @param  {a0,b0,c0,a1,b1,c1,a2,b2,c2,s0,s1,s2}    new set of coefficients
     * @param  summand_rescale (optional), set this to "input_bps - 8" if using a set of summands that assumes input_bps == 8
     * @post   Quantize the floating-point inputs and program the new coefficients. Write to the commit register once done
     */
    void apply(const float *coeffs, int summand_rescale = 0);

    /**
     * @brief  Write new CSC coefficients and commit the change
     * @param  {a0,b0,c0,a1,b1,c1,a2,b2,c2,s0,s1,s2}    new set of quantized coefficients
     * @post   Program the new coefficients. Write to the commit register once done
     */
    void apply(const long *coeffs);

    /**
     * @brief  Write new CSC coefficient
     * @param  offset  the coefficient to write in the range [CSC_COEFFICIENT_A0..CSC_COEFFICIENT_C2]
     * @param  value   the coefficient value
     * @post   Quantize the floating-point input and program the new coefficient. The coefficient remain unused until it is committed
     */
    inline void set_coefficient(int offset, float value) {
        set_quantized_coefficient(offset, VipMath::quantize_coefficient(coeff_signed, coeff_int_bits, coeff_summand_fraction_bits, value));
    }

    /**
     * @brief  Write new CSC summand
     * @param  offset  the summand to write in the range [CSC_SUMMAND_S0..CSC_SUMMAND_S2]
     * @param  value   the summand value
     * @post   Quantize the floating-point input and program the new summand. The summand remain unused until it is committed
     * @pre    If using a coefficient table from a book or Internet, make sure the summand was scaled correctly to take into account input_bps
     *         or use set_summand(offset, value, input_bps - 8)
     */
    inline void set_summand(int offset, float value) {
        set_quantized_summand(offset, VipMath::quantize_coefficient(summand_signed, summand_int_bits, coeff_summand_fraction_bits, value));
    }

    /**
     * @brief  Write new CSC summand
     * @param  offset  the summand to write in the range [CSC_SUMMAND_S0..CSC_SUMMAND_S2]
     * @param  value   the summand value
     * @param  summand_rescale (optional), set this to "input_bps - 8" if using a summand value that assumes input_bps == 8
     * @post   Quantize the floating-point input and program the new summand. The summand remain unused until it is committed
     * @pre    Make sure the summand was scaled correctly to take into account input_bps
     */
    inline void set_summand(int offset, float value, int summand_rescale) {
        if (summand_rescale < 0) set_summand(offset, value / float(1 << (-summand_rescale)));
        else set_summand(offset, value * float(1 << summand_rescale));
    }

    /**
     * @brief  Write new CSC coefficient
     * @param  offset  the coefficient to write in the range [CSC_COEFFICIENT_A0..CSC_COEFFICIENT_C2]
     * @param  value   the quantized coefficient value
     * @post   Quantize the floating-point input and program the new coefficient. The coefficient remain unused until it is committed
     */
    inline void set_quantized_coefficient(int offset, long value) {
        assert(offset >= CSC_COEFFICIENT_A0);
        assert(offset <= CSC_COEFFICIENT_C2);
        do_write(offset, value);
    }

    /**
     * @brief  Write new CSC summand
     * @param  offset  the summand to write in the range [CSC_SUMMAND_S0..CSC_SUMMAND_S2]
     * @param  value   the quantized summand value
     * @post   Quantize the floating-point input and program the new coefficient. The coefficient remain unused until it is committed
     */
    inline void set_quantized_summand(int offset, long value) {
        assert(offset >= CSC_SUMMAND_S0);
        assert(offset <= CSC_SUMMAND_S2);
        do_write(offset, value);
    }

    /**
     * @brief  Commit the current set of coefficients
     * @post   New coefficient values programmed into the core will be used from next frame
     */
    inline void commit_coefficients() {
        do_write(CSC_COEFF_COMMIT_MODE, 1);
    }

private:
    bool coeff_signed;
    unsigned int coeff_int_bits;
    bool summand_signed;
    unsigned int summand_int_bits;
    unsigned int coeff_summand_fraction_bits;
};

#endif   // __COLOR_SPACE_CONVERTER_HPP__

