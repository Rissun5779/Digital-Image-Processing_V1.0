#include "Chroma_Resampler.hpp"

Chroma_Resampler::Chroma_Resampler(unsigned long base_address, VariableSide variable_side)
: VipCore(base_address), variable_side(variable_side) {
}
