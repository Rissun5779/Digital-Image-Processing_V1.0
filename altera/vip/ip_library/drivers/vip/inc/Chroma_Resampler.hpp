#ifndef __CHROMA_RESAMPLER_HPP__
#define __CHROMA_RESAMPLER_HPP__

#include "VipCore.hpp"

class Chroma_Resampler : public VipCore {
private:
    Chroma_Resampler(const Chroma_Resampler&);  // Disable copy constructor

public:
    // CRS specific registers
    enum CRSRegisterType {
        CRS_VAR_SUBSAMPLING           =  3,
    };

    // 00 - 4:4:4
    // 01 - 4:2:2
    // 10 - 4:2:0
    enum Subsampling {
        SUBS_420 = 0,
        SUBS_422 = 1,
        SUBS_444 = 2,
    };

    enum VariableSide {
        VAR_INPUT,
        VAR_OUTPUT,
    };

    /**
     * @brief  constructor
     * @param  base_address   the slave interface base address (hash-defined in system.h)
     */
    Chroma_Resampler(unsigned long base_address, VariableSide variable_side);

    /**
     * @brief  Change variable side subsampling
     * @param  var_subsampling   the new subsampling on the variable side
     */
    inline void set_variable_side_subsampling(Subsampling var_subsampling) {
        do_write(CRS_VAR_SUBSAMPLING, var_subsampling);
    }

private:
    VariableSide variable_side;
};

#endif    //  __CHROMA_RESAMPLER_HPP__
