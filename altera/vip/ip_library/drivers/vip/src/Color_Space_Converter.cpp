#include "Color_Space_Converter.hpp"

#include "VipMath.hpp"

Color_Space_Converter::Color_Space_Converter(unsigned long base_address, bool coeff_signed, unsigned int coeff_int_bits, bool summand_signed, unsigned int summand_int_bits, unsigned int coeff_summand_fraction_bits)
: VipCore(base_address), coeff_signed(coeff_signed), coeff_int_bits(coeff_int_bits), summand_signed(summand_signed), summand_int_bits(summand_int_bits), coeff_summand_fraction_bits(coeff_summand_fraction_bits) {
}

void Color_Space_Converter::apply(const float *coeffs, int summand_rescale)
{
    long quantized_coeffs[12];
    long *q_coeffs = quantized_coeffs;
    for (unsigned int offset = CSC_COEFFICIENT_A0; offset <= CSC_COEFFICIENT_C2; ++offset) {
        *q_coeffs++ = VipMath::quantize_coefficient(coeff_signed, coeff_int_bits, coeff_summand_fraction_bits, *coeffs++);
    }
    for (unsigned int offset = CSC_SUMMAND_S0; offset <= CSC_SUMMAND_S2; ++offset) {
        float summand = *coeffs++;
        summand = (summand_rescale < 0) ? summand / float(1 << (-summand_rescale)) : summand * float(1 << summand_rescale);
        *q_coeffs++ = VipMath::quantize_coefficient(summand_signed, summand_int_bits, coeff_summand_fraction_bits, summand);
    }
    apply(quantized_coeffs);
}

void Color_Space_Converter::apply(const long *coeffs)
{
    for (unsigned int offset = CSC_COEFFICIENT_A0; offset <= CSC_SUMMAND_S2; ++offset) {
        do_write(offset, *coeffs++);
    }
    commit_coefficients();
}
