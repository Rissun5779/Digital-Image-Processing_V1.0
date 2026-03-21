#include "Interlacer.hpp"

Interlacer::Interlacer(long base_address)
: VipCore(base_address), current_settings(0) {
   //initialise the settings to 0 (no progressive pass, no interlaced pass, no ctrl override, F0 first)
   do_write(INTERLACER_SETTINGS, current_settings);
}
