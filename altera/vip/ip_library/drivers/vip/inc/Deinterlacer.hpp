#ifndef __DEINTERLACER_HPP__
#define __DEINTERLACER_HPP__

#include "VipCore.hpp"

class Deinterlacer : public VipCore {
private:
    Deinterlacer(const Deinterlacer&);  // Disable copy constructor

public:
    // DIL specific registers
    enum DILRegisterType {
        DIL_ENABLE_CADENCE_DETECTION    = 3,
    };

    Deinterlacer(long base_address);

    inline void enable_cadence_detection() {
        do_write(DIL_ENABLE_CADENCE_DETECTION, true);
    }

    inline void disable_cadence_detection() {
        do_write(DIL_ENABLE_CADENCE_DETECTION, false);
    }
};

#endif   // __DEINTERLACER_HPP__
