#ifndef __GAMMA_CORRECTOR_HPP__
#define __GAMMA_CORRECTOR_HPP__

#include "VipCore.hpp"


class Gamma_Corrector : public VipCore {
private:
    Gamma_Corrector(const Gamma_Corrector&);  // Disable copy constructor

public:
    // GAM specific registers
    enum GAMRegisterType {
        GAM_READ_BANK            = 3,
        GAM_WRITE_BANK           = 4,
        GAM_WRITE_COLOR_PLANE    = 5,
        GAM_TABLE_BASE           = 6,
    };

    // Gamma_Corrector constructor
    // @pre  parameters match with the HW parameterization
    Gamma_Corrector(unsigned long base_address, unsigned int bps, unsigned int number_of_color_planes,
                       unsigned int number_of_banks);

    // select_read_bank
    // @pre  read_bank is either 0 or 1 and the core was configured with two banks
    // @post selects the read bank the core is using to map values
    inline void select_read_bank(unsigned int read_bank) {
        do_write(GAM_READ_BANK, read_bank);
    }

    // select_write_bank
    // @pre  write_bank is either 0 or 1 and the core was configured with two banks
    // @post selects the write bank
    inline void select_write_bank(unsigned int write_bank) {
        do_write(GAM_WRITE_BANK, write_bank);
    }

    // select_write_color_plane
    // @pre  color_plane is in the range 0..number_of_color_planes-1
    // @post selects the write color plane
    inline void select_write_color_plane(unsigned int write_color_plane) {
        do_write(GAM_WRITE_COLOR_PLANE, write_color_plane);
    }

    // write_lut_mapping
    // @pre  input_value and output_value are in the range [0..2^bps-1]
    // @pre  select_write_bank and select_write_color_plane were called at least once to select an
    //       initial LUT
    // @post update the lookup value for input_value in lut[write_bank][write_color_plane] to output_value
    inline void write_lut_mapping(unsigned int input_value, unsigned int output_value) {
        do_write(GAM_TABLE_BASE + input_value, output_value);
    }

    // init_linear, map [0..2^bps-1] to [0..2^bps-1] for selected color plane(s)
    //              and saturate in the [min..max] range
    // @param  write_bank, the bank to update
    // @param  min, the minimum saturation value
    // @param  max, the maximum saturation value (use 0 to default to 2^bps -1)
    // @param  color_plane, the color plane to init (-1 for all color planes)
    // @pre    write_bank is either 0 or 1
    // @pre    min,max are in the range [0..2^bps-1], max == 0 will be interpreted as max==2^bps - 1
    // @pre    min < max
    // @pre    color_plane is in the range [0..number_color_planes-1] or is -1
    void init_linear(unsigned int write_bank, unsigned int min = 0,
                     unsigned int max = 0, int color_plane = -1);

    // init_invert, map [0..2^bps-1] to [2^bps-1..0] for selected color plane(s)
    // @param  write_bank, the bank to update
    // @param  color_plane, the color plane to init (-1 for all color planes)
    // @pre    write_bank is either 0 or 1
    // @pre    color_plane is in the range [0..number_color_planes-1] or is -1
    inline void init_invert(unsigned int write_bank, int color_plane = -1) {
        init_affine(write_bank, -1.0f, float((1 << bps) - 1), color_plane);
    }

    // init_affine, map x to f(x)=gain * x + bias  for selected color plane(s)
    // @param  write_bank, the bank to update
    // @param  color_plane, the color plane to init (-1 for all color planes)
    // @param  gain, the multiplication factor (controls the contrast)
    // @param  bias, the addition factor (controls the brightness)
    // @pre    write_bank is either 0 or 1
    // @pre    color_plane is in the range [0..number_color_planes-1] or is -1
    // @post   apply the selected affine transform to the color plane, note that the output is
    //         saturated in the range [0..2^bps-1]
    void init_affine(unsigned int write_bank, float gain = 1.0, float bias = 0.0, int color_plane = -1);

    // init_itu709_8_decode, set up the write bank a specified by ITU709-8
    // @param  write_bank, the bank to update
    // @pre  write_bank is either 0 or 1
    void init_itu709_8_decode(unsigned int write_bank, float power=0.45f, float offset=13.2f);


private:
    unsigned int bps;
    unsigned int number_of_color_planes;
    unsigned int number_of_banks;
};


#endif /* __GAMMA_CORRECTOR_HPP__ */
