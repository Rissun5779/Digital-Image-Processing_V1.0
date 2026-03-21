#include "Gamma_Corrector.hpp"

#include "math.h"

Gamma_Corrector::Gamma_Corrector(unsigned long base_address, unsigned int bps, unsigned int number_of_color_planes,
                                      unsigned int number_of_banks)
: VipCore(base_address), bps(bps), number_of_color_planes(number_of_color_planes), number_of_banks(number_of_banks) {
}

void Gamma_Corrector::init_linear(unsigned int write_bank, unsigned int min, unsigned int max, int color_plane)
{
    unsigned int size = 1 << bps;
    if ((max == 0) || (max >= size)) {
        max = size - 1;
    }
    if (min > max) min = max;

    select_write_bank(write_bank);

    for (unsigned int c = ((color_plane == -1) ? 0 : color_plane);
                      c < ((color_plane == -1) ? number_of_color_planes : (color_plane + 1)); ++c) {
        select_write_color_plane(c);
        for(unsigned int in_value = 0; in_value < size; ++in_value) {
            unsigned int out_value = in_value;
            if (out_value > max) out_value = max;
            else if (out_value < min) out_value = min;
            write_lut_mapping(in_value, out_value);
        }
    }
}


void Gamma_Corrector::init_affine(unsigned int write_bank, float gain, float bias, int color_plane)
{
    unsigned int size = 1 << bps;

    select_write_bank(write_bank);

    for (unsigned int c = ((color_plane == -1) ? 0 : color_plane);
                      c < ((color_plane == -1) ? number_of_color_planes : (color_plane + 1)); ++c) {
        select_write_color_plane(c);
        for(unsigned int in_value = 0; in_value < size; ++in_value) {
            int out_value = float(in_value)*gain + bias;
            if (out_value < 0) out_value = 0;
            else if (out_value >= size) out_value = size - 1;
            write_lut_mapping(in_value, out_value);
        }
    }
}


void Gamma_Corrector::init_itu709_8_decode(unsigned int write_bank, float power, float offset) {
    unsigned int size = 1 << bps;
    unsigned int max_value = size - 1;

    float scale = float(size)/(float(size)-offset);

    select_write_bank(write_bank);

    for (unsigned int c = 0; c < number_of_color_planes; ++c) {
        select_write_color_plane(c);
        for(unsigned int in_value = 0; in_value < size; ++in_value) {
            float l = (float(in_value) - offset)/float(max_value);

            int value;
            if (l < 0.0f) {
                value = int( (float(in_value)*6.0f) / offset );
            } else if (l < 0.018f) {
                value = int( (float(max_value) * l * scale * 4.5f) + 3.0f );
            } else {
                value = int( float(max_value) * (1.099f * pow(l*scale, power) - 0.089f) );
            }
            unsigned int out_value = (value > int(max_value)) ? max_value : ( (value < 0) ? 0 : value );
            write_lut_mapping(in_value, out_value);
        }
    }
}

