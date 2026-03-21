#ifndef __DIP_MANAGER_HPP__
#define __DIP_MANAGER_HPP__

#include <io.h>
#include <system.h>

class Dip_Manager
{
public:
    static const unsigned int MAX_NUM_DIPS = 8;

    /**
     * Dip manager constructor
     * @param  base_address   the base address of the slave interface for the dip switchs component
     */
    Dip_Manager(long base_address)
    : base_address(base_address) {
    }

    /**
     * read_dip_values()
     * @return  Read the mask of all enabled dip switchs (address 0 of the dip manager)
     */
    inline unsigned int read_dip_values() {
        return IORD(base_address, 0);
    }    
    
    /**
     * read_dip()
     * @param   dip_number, the DIP id
     * @return  whether the selected dip switch is on
     * @pre     dip_number is in [0..MAX_NUM_DIPS-1]
     */
    inline bool read_dip(unsigned int dip_number) {
        return (read_dip_values() & (1 << dip_number)) != 0;
    }

private:
    long base_address;
};
    

#endif    // __DIP_MANAGER_HPP__
