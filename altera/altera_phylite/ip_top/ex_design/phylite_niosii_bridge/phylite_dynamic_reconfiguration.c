
// JTAG UART Debug Output
#define DEBUG_LVL 0

/*******************************************************************************/
// Includes
/*******************************************************************************/

//Use stdio over JTAG for debug output
#if DEBUG_LVL > 0
#include <stdio.h>
#endif

#include "phylite_dynamic_reconfiguration.h"

/*******************************************************************************/
// Defines
/*******************************************************************************/

// QSYS System dependent!
//	change the below defines for a new QSYS system
//bridge to I/O column
#define RECONFIG_BRIDGE_ADDR 0x4000000
#define RECONFIG_BRIDGE_SHIFT 2

#define 	AVL_CTRL_REG_NUM_GROUPS           0x00 			//     R      |    N/A     | {24'h000000,num_grps[7:0]}
#define 	AVL_CTRL_REG_GROUP_INFO           0x01        	//     R      |    N/A     | {16'h0000,num_lanes[7:0],num_pins[7:0]}
#define 	AVL_CTRL_REG_IDELAY               0x02        	//    R/W     |    N/A     | {23'h000000,dq_delay[8:0]}
#define 	AVL_CTRL_REG_ODELAY               0x03        	//    R/W     |     R      | {19'h00000,output_phase[12:0]}
#define 	AVL_CTRL_REG_DQS_DELAY            0x04        	//    R/W     |    N/A     | {22'h000000,dqs_delay[9:0]}
#define 	AVL_CTRL_REG_DQS_EN_DELAY         0x05        	//    R/W     |     R      | {26'h0000000,dqs_en_delay[5:0]}
#define 	AVL_CTRL_REG_DQS_EN_PHASE_SHIFT   0x06        	//    R/W     |     R      | {19'h00000,phase[12:0]}
#define 	AVL_CTRL_REG_RD_VALID_DELAY       0x07        	//    R/W     |     R      | {25'h0000000,rd_vld_delay[6:0]}

#define 	NUM_LANES_MASK	0x0000ff00
#define		NUM_PINS_MASK	0x000000ff

#define PARAMETER_TABLE_BASE_ADDR 0xe000

//Global Parameter Table Information
#define GPT_ENTRY_START PARAMETER_TABLE_BASE_ADDR+0x18
#define GPT_NUM_INST_ENTRIES 11
#define GPT_PHYLITE_ENTRY_INST_IDX 31
#define GPT_PHYLITE_ENTRY_INST_MASK 1
#define GPT_PHYLITE_ENTRY_ID_IDX 24
#define GPT_PHYLITE_ENTRY_ID_MASK 0xF
#define GPT_PHYLITE_ENTRY_PTR_IDX 0
#define GPT_PHYLITE_ENTRY_PTR_MASK 0xFFFF

//PHYLite Instance Parameter Table Information
#define PT_NUM_GROUPS_OFFSET 4
#define PT_GROUP_INFO_OFFSET 8
#define PT_GROUP_INFO_ENTRY_BYTE_SIZE 1
#define PT_GROUP_INFO_ENTRY_NUM_PINS_IDX 0
#define PT_GROUP_INFO_ENTRY_NUM_PINS_MASK 0x3F
#define PT_GROUP_INFO_ENTRY_NUM_LANES_IDX 6
#define PT_GROUP_INFO_ENTRY_NUM_LANES_MASK 0x3
#define PT_GROUP_PTR_ENTRY_BYTE_SIZE 4
#define PT_GROUP_PTR_ENTRY_PIN_PTR_IDX 0
#define PT_GROUP_PTR_ENTRY_PIN_PTR_MASK 0xFFFF
#define PT_GROUP_PTR_ENTRY_LANE_PTR_IDX 16
#define PT_GROUP_PTR_ENTRY_LANE_PTR_MASK 0xFFFF
#define PT_LANE_ADDR_ENTRY_BYTE_SIZE 1
#define PT_PIN_ADDR_ENTRY_BYTE_SIZE 2
#define PT_PIN_ADDR_ENTRY_LANE_PIN_IDX 0
#define PT_PIN_ADDR_ENTRY_LANE_PIN_MASK 0xF
#define PT_PIN_ADDR_ENTRY_PIN_TYPE_IDX 4
#define PT_PIN_ADDR_ENTRY_PIN_TYPE_MASK 0xF
#define PT_PIN_ADDR_ENTRY_LANE_ADDR_IDX 8
#define PT_PIN_ADDR_ENTRY_LANE_ADDR_MASK 0xFF

//Calibration Bus Information
#define CAL_BUS_BASE_ADDR 0x800000

#define PIN_ODELAY_ADDR     CAL_BUS_BASE_ADDR|0xD0
#define PIN_ODELAY_ADDR_CSR CAL_BUS_BASE_ADDR|0xE8
#define PIN_ODELAY_PIN_IDX 8
#define PIN_ODELAY_LANE_IDX 12
#define PIN_ODELAY_DATA_MASK 0x1FFF

#define PIN_IDELAY_ADDR     CAL_BUS_BASE_ADDR|0x1800
#define PIN_IDELAY_PIN_IDX 4
#define PIN_IDELAY_LGC_SEL_IDX 7
#define PIN_IDELAY_LANE_IDX 13
#define PIN_IDELAY_AVL_ENABLE_MASK 0x1000
#define PIN_IDELAY_DATA_MASK 0x1FF

// Memory Read/Write
#define ADDR_CAST(addr) ((void *)((unsigned int*)(addr)))
#define IOWR32(addr, data) __builtin_stwio(ADDR_CAST(addr), data)
#define IORD32(addr) __builtin_ldwio(ADDR_CAST(addr))


/*******************************************************************************/
// Global Variables
/*******************************************************************************/

/*******************************************************************************/
// Functions
/*******************************************************************************/

//read from Avalon Pipeline Bridge to I/O Column Avalon Bus
unsigned int hw_read_cal_bus_uint32(unsigned int id, unsigned int group, unsigned int pin, unsigned int csr, unsigned reg_cmd)
{
	unsigned int addr = (id << 20) | (group << 15) | (pin << 9) | (csr << 8) | reg_cmd;
	return IORD32(RECONFIG_BRIDGE_ADDR | (addr << RECONFIG_BRIDGE_SHIFT));
}

//write to Avalon Pipeline Bridge to I/O Column Avalon Bus
void hw_write_cal_bus_uint32(unsigned int id, unsigned int group, unsigned int pin, unsigned int csr, unsigned reg_cmd, unsigned int data)
{
	unsigned int addr = (id << 20) | (group << 15) | (pin << 9) | (csr << 8) | reg_cmd;
	IOWR32(RECONFIG_BRIDGE_ADDR | (addr << RECONFIG_BRIDGE_SHIFT), data);
}

void reset_avalon_controller(unsigned int address)
{
	  IOWR32(address,0);
	  IOWR32(address,1);
}

//read from Avalon Pipeline Bridge to I/O Column Avalon Bus
unsigned int sw_read_cal_bus_uint32(unsigned int addr)
{
	return IORD32(RECONFIG_BRIDGE_ADDR | (addr << RECONFIG_BRIDGE_SHIFT));
}

//write to Avalon Pipeline Bridge to I/O Column Avalon Bus
void sw_write_cal_bus_uint32(unsigned int addr, unsigned int data)
{
	IOWR32(RECONFIG_BRIDGE_ADDR | (addr << RECONFIG_BRIDGE_SHIFT), data);
}


/*******************************************************************************/
// PHYLite Parameter Table Functions
//      NOTE: These functions
/*******************************************************************************/

//PHYLite Parameter Table Function Cache
static struct phylite_pt_info {
	int curr_inst_id;
	int curr_group;
	int curr_pin;
	unsigned int output_phy_pt_addr; //address of the table
	unsigned int num_groups;
	unsigned int num_group_lanes;
	unsigned int num_group_pins;
	unsigned int group_lane_ptr_addr;
	unsigned int group_pin_ptr_addr;
	unsigned int curr_lane_addr[4];
	unsigned int curr_pin_lane_addr;
	unsigned int curr_pin_lane_idx;
} s_phylite_pt_info;

//reset entire cache
void reset_phylite_pt_info()
{
	s_phylite_pt_info.curr_inst_id = -1;
	s_phylite_pt_info.curr_group   = -1;
	s_phylite_pt_info.curr_pin     = -1;
	s_phylite_pt_info.output_phy_pt_addr  = 0;
	s_phylite_pt_info.num_groups          = 0;
	s_phylite_pt_info.num_group_lanes     = 0;
	s_phylite_pt_info.num_group_pins      = 0;
	s_phylite_pt_info.group_lane_ptr_addr = 0;
	s_phylite_pt_info.group_pin_ptr_addr  = 0;
	s_phylite_pt_info.curr_lane_addr[0]   = 0;
	s_phylite_pt_info.curr_lane_addr[1]   = 0;
	s_phylite_pt_info.curr_lane_addr[2]   = 0;
	s_phylite_pt_info.curr_lane_addr[3]   = 0;
	s_phylite_pt_info.curr_pin_lane_addr  = 0;
	s_phylite_pt_info.curr_pin_lane_idx   = 0;
}

//reset group cache
void reset_phylite_pt_grp_info()
{
	s_phylite_pt_info.curr_group   = -1;
	s_phylite_pt_info.curr_pin     = -1;
	s_phylite_pt_info.num_groups          = 0;
	s_phylite_pt_info.num_group_lanes     = 0;
	s_phylite_pt_info.num_group_pins      = 0;
	s_phylite_pt_info.group_lane_ptr_addr = 0;
	s_phylite_pt_info.group_pin_ptr_addr  = 0;
	s_phylite_pt_info.curr_lane_addr[0]   = 0;
	s_phylite_pt_info.curr_lane_addr[1]   = 0;
	s_phylite_pt_info.curr_lane_addr[2]   = 0;
	s_phylite_pt_info.curr_lane_addr[3]   = 0;
	s_phylite_pt_info.curr_pin_lane_addr  = 0;
	s_phylite_pt_info.curr_pin_lane_idx   = 0;
}

//reset pin cache
void reset_phylite_pt_pin_info()
{
	s_phylite_pt_info.curr_pin     = -1;
	s_phylite_pt_info.curr_pin_lane_addr  = 0;
	s_phylite_pt_info.curr_pin_lane_idx   = 0;
}

// find the address of the phylite instance with the given ID in the global parameter table
// and set the address offset in the cache struct
// returns 1 if ID found, 0 if ID not found
unsigned int get_phylite_instance_pt_addr_offset(unsigned int id)
{
	unsigned int i;
	unsigned int entry;
	unsigned int is_phylite;
	unsigned int entry_id;
	unsigned int entry_found;

	if (id == s_phylite_pt_info.curr_inst_id)
	{
#if DEBUG_LVL >= 2
	printf("ID in cache\n");
#endif
		return 1;
	}
	else
	{
		//invalidate cache
		reset_phylite_pt_info();
	}

	for(i = 0; i < GPT_NUM_INST_ENTRIES; i++)
	{
		entry = sw_read_cal_bus_uint32((GPT_ENTRY_START) | (i << 2) );
		is_phylite = (entry >> GPT_PHYLITE_ENTRY_INST_IDX) & GPT_PHYLITE_ENTRY_INST_MASK;
		entry_id   = (entry >> GPT_PHYLITE_ENTRY_ID_IDX)   & GPT_PHYLITE_ENTRY_ID_MASK;

		if (is_phylite && (entry_id == id))
		{
			break;
		}
	}

	entry_found = (i != GPT_NUM_INST_ENTRIES);

	if (entry_found)
	{
		s_phylite_pt_info.curr_inst_id = id;
		s_phylite_pt_info.output_phy_pt_addr = PARAMETER_TABLE_BASE_ADDR + ((entry >> GPT_PHYLITE_ENTRY_PTR_IDX) & GPT_PHYLITE_ENTRY_PTR_MASK);
	}

#if DEBUG_LVL >= 2
	printf("PHYLite Instance %d has PT addr %x\n", id, s_phylite_pt_info.output_phy_pt_addr);
#endif

	return entry_found;
}

//returns 1 if instance ID is valid
int sw_get_num_groups(unsigned int id)
{
	unsigned int success;

	//ensure group parameter table address is in cache
	success = get_phylite_instance_pt_addr_offset(id);

	if (success)
	{
		s_phylite_pt_info.num_groups = sw_read_cal_bus_uint32(s_phylite_pt_info.output_phy_pt_addr + PT_NUM_GROUPS_OFFSET);

#if DEBUG_LVL >= 2
		printf("PHYLite Instance %d has %d groups\n", id, s_phylite_pt_info.num_groups);
#endif
	}

	return success;
}

//returns 1 if instance ID and group number are valid
int sw_get_group_info(unsigned int id, unsigned int group)
{
	unsigned int success = 1;
	unsigned int group_info;
	unsigned int group_ptrs;

	//check if info is already cached
	if (id == s_phylite_pt_info.curr_inst_id && group == s_phylite_pt_info.curr_group)
	{
		return 1;
	}

	//flush group cache
	reset_phylite_pt_grp_info();

	//get number of groups
	success &= sw_get_num_groups(id);
	success &= (group < s_phylite_pt_info.num_groups);

	if (success)
	{
		s_phylite_pt_info.curr_group = group;

		//get number of lanes and pins in group
		group_info = sw_read_cal_bus_uint32( (s_phylite_pt_info.output_phy_pt_addr + PT_GROUP_INFO_OFFSET + group) & 0xFFFFFFFC); //can only read at word granularity
		group_info = (group_info >> ((group & 0x3) << 8)) & 0xF;
		s_phylite_pt_info.num_group_lanes = ((group_info >> PT_GROUP_INFO_ENTRY_NUM_LANES_IDX) & PT_GROUP_INFO_ENTRY_NUM_LANES_MASK) + 1;
		s_phylite_pt_info.num_group_pins  = (group_info >> PT_GROUP_INFO_ENTRY_NUM_PINS_IDX) & PT_GROUP_INFO_ENTRY_NUM_PINS_MASK;

		//get group lane and pin address pointers
		group_ptrs = sw_read_cal_bus_uint32(s_phylite_pt_info.output_phy_pt_addr + PT_GROUP_INFO_OFFSET + ((s_phylite_pt_info.num_groups & 0xFFFFFFFC) + 4) + (group << 2));
		s_phylite_pt_info.group_lane_ptr_addr = PARAMETER_TABLE_BASE_ADDR + ((group_ptrs >> PT_GROUP_PTR_ENTRY_LANE_PTR_IDX) & PT_GROUP_PTR_ENTRY_LANE_PTR_MASK);
		s_phylite_pt_info.group_pin_ptr_addr  = PARAMETER_TABLE_BASE_ADDR + ((group_ptrs >> PT_GROUP_PTR_ENTRY_PIN_PTR_IDX)  & PT_GROUP_PTR_ENTRY_PIN_PTR_MASK);
#if DEBUG_LVL >= 2
		printf("PHYLite Instance %d group %d has %d lanes and %d pins\n", id, group, s_phylite_pt_info.num_group_lanes, s_phylite_pt_info.num_group_pins);
		printf("\tlane_ptr = %x\n\tpin_ptr = %x\n", s_phylite_pt_info.group_lane_ptr_addr, s_phylite_pt_info.group_pin_ptr_addr);
#endif
	}

	return success;
}

//returns 1 if instance ID and group number are valid
unsigned int get_lane_addresses(unsigned int id, unsigned int group)
{
	unsigned int success = 1;
	unsigned int i;
	unsigned int addr;

	success = sw_get_group_info(id, group);

	if (success && s_phylite_pt_info.curr_lane_addr[0] != 0)
	{
		return 1;
	}

	if (success)
	{
		//check for valid lane addresses already in cache
		if (s_phylite_pt_info.curr_lane_addr[0] == 0)
		{
			//not in cache, need to read from param table
			for (i = 0; i < s_phylite_pt_info.num_group_lanes; i++)
			{
				addr = s_phylite_pt_info.group_lane_ptr_addr + i;
				s_phylite_pt_info.curr_lane_addr[i] = (sw_read_cal_bus_uint32(addr & 0xFFFFFFFC) >> ((addr & 0x3) << 3)) & 0xFF;
#if DEBUG_LVL >= 2
				printf("\tlane_addr[%d] = %x\n", i, s_phylite_pt_info.curr_lane_addr[i]);
#endif
			}
		}
	}

	return success;
}

//includes strobes
//returns 1 if instance ID, group number, and pin index are valid
//TODO: support differential/complementary strobe and data configurations - assumes single ended for both right now
unsigned int get_pin_address(unsigned int id, unsigned int group, unsigned int pin)
{
	unsigned int success = 1;
	unsigned int addr;
	unsigned int pin_addr_entry;
	//unsigned int pin_type;

	success = sw_get_group_info(id, group);

	if (pin == s_phylite_pt_info.curr_pin)
	{
		return 1;
	}

	//flush pin cache
	reset_phylite_pt_pin_info();

	//check that pin is in valid range for group
	success &= (pin <= s_phylite_pt_info.num_group_pins); //count including single ended strobe

	//translate pin address
	if (success)
	{
		s_phylite_pt_info.curr_pin = pin;
		addr = s_phylite_pt_info.group_pin_ptr_addr + (pin << 1);
		pin_addr_entry = (sw_read_cal_bus_uint32(addr & 0xFFFFFFFC) >> ((addr & 0x3) << 3)) & 0xFFFF;
		s_phylite_pt_info.curr_pin_lane_idx  = (pin_addr_entry >> PT_PIN_ADDR_ENTRY_LANE_PIN_IDX)   & PT_PIN_ADDR_ENTRY_LANE_PIN_MASK;
		//pin_type                             = (pin_addr_entry >>  PT_PIN_ADDR_ENTRY_PIN_TYPE_IDX)  & PT_PIN_ADDR_ENTRY_PIN_TYPE_MASK;
		s_phylite_pt_info.curr_pin_lane_addr = (pin_addr_entry >>  PT_PIN_ADDR_ENTRY_LANE_ADDR_IDX) & PT_PIN_ADDR_ENTRY_LANE_ADDR_MASK;
	}

	return success;
}

//logical pin indexing starts at strobes
//return delay of pin, -1 if pin not found
int sw_get_output_delay(unsigned int id, unsigned int group, unsigned int pin, unsigned int csr)
{
	int delay = -1;
	unsigned int addr = csr ? PIN_ODELAY_ADDR_CSR : PIN_ODELAY_ADDR;

	if (get_pin_address(id, group, pin))
	{
		addr |= (s_phylite_pt_info.curr_pin_lane_idx << PIN_ODELAY_PIN_IDX) | (s_phylite_pt_info.curr_pin_lane_addr << PIN_ODELAY_LANE_IDX);
		delay = sw_read_cal_bus_uint32(addr) & PIN_ODELAY_DATA_MASK;
#if DEBUG_LVL >= 2
		printf("Interface %d, Group %d, Pin %d, CSR %d has odelay %d\n", id, group, pin, csr, delay);
#endif
	}

	return delay;
}

//logical pin indexing starts at strobes
//return delay of pin, 0 if pin not found
void sw_set_output_delay(unsigned int id, unsigned int group, unsigned int pin, unsigned int delay)
{
	unsigned int addr = PIN_ODELAY_ADDR;

	if (get_pin_address(id, group, pin))
	{
		addr |= (s_phylite_pt_info.curr_pin_lane_idx << PIN_ODELAY_PIN_IDX) | (s_phylite_pt_info.curr_pin_lane_addr << PIN_ODELAY_LANE_IDX);
		sw_write_cal_bus_uint32(addr, delay & PIN_ODELAY_DATA_MASK);
#if DEBUG_LVL >= 2
		printf("Interface %d, Group %d, Pin %d, set odelay %d\n", id, group, pin, delay);
#endif
	}
}

//logical pin indexing starts at strobes
//return delay of pin, -1 if pin not found
int sw_get_input_delay(unsigned int id, unsigned int group, unsigned int pin)
{
	int delay = -1;
	unsigned int addr = PIN_IDELAY_ADDR;
	unsigned int lgc_sel;

	if (get_pin_address(id, group, pin))
	{
		lgc_sel = (s_phylite_pt_info.curr_pin_lane_idx <= 5) ? 1 : 2;
		addr |= (s_phylite_pt_info.curr_pin_lane_idx << PIN_IDELAY_PIN_IDX) | (lgc_sel << PIN_IDELAY_LGC_SEL_IDX) | (s_phylite_pt_info.curr_pin_lane_addr << PIN_IDELAY_LANE_IDX);
		delay = sw_read_cal_bus_uint32(addr) & PIN_IDELAY_DATA_MASK;
#if DEBUG_LVL >= 2
		printf("Interface %d, Group %d, Pin %d has idelay %d\n", id, group, pin, delay);
#endif
	}

	return delay;
}

//logical pin indexing starts at strobes
//return delay of pin, 0 if pin not found
void sw_set_input_delay(unsigned int id, unsigned int group, unsigned int pin, unsigned int delay)
{
	unsigned int addr = PIN_IDELAY_ADDR;
	unsigned int lgc_sel;

	if (get_pin_address(id, group, pin))
	{
		lgc_sel = (s_phylite_pt_info.curr_pin_lane_idx <= 5) ? 1 : 2;
		addr |= (s_phylite_pt_info.curr_pin_lane_idx << PIN_IDELAY_PIN_IDX) | (lgc_sel << PIN_IDELAY_LGC_SEL_IDX) | (s_phylite_pt_info.curr_pin_lane_addr << PIN_IDELAY_LANE_IDX);
		sw_write_cal_bus_uint32(addr, PIN_IDELAY_AVL_ENABLE_MASK | (delay & PIN_IDELAY_DATA_MASK));
#if DEBUG_LVL >= 2
		printf("Interface %d, Group %d, Pin %d, set idelay %d\n", id, group, pin, delay);
#endif
	}
}

/*******************************************************************************/
// Avalon Controller Functions
/*******************************************************************************/
//START_FUNCTION_HEADER//////////////////////////////////////////////////////
//
int hw_get_num_groups(unsigned int id)
//
// Description: Get number of groups of a given Interface ID
//
// Returns: 	Number of groups, -1 otherwise.
//
//END_FUNCTION_HEADER////////////////////////////////////////////////////////
{
	int grp_num = -1;
	grp_num = hw_read_cal_bus_uint32(id, 0, 0, 0, AVL_CTRL_REG_NUM_GROUPS);

	return grp_num;
}

//START_FUNCTION_HEADER//////////////////////////////////////////////////////
//
int hw_get_group_info(unsigned int id, unsigned int group)
//
// Description: Get group info of a given Inferface ID
//
// Returns: 	number of lanes and number of pins {32'h000000,num_lanes[7:0],num_pins[7:0]}, -1 otherwise.
//
//END_FUNCTION_HEADER////////////////////////////////////////////////////////
{
	int grp_info = -1;
	grp_info = hw_read_cal_bus_uint32(id, group, 0, 0, AVL_CTRL_REG_GROUP_INFO);

	return grp_info;
}

//START_FUNCTION_HEADER//////////////////////////////////////////////////////
//
int hw_get_num_lanes(unsigned int id, unsigned int group)
//
// Description: Get num of lanes of a given Group
//
// Returns: 	number of lanes, -1 otherwise.
//
//END_FUNCTION_HEADER////////////////////////////////////////////////////////
{
	int num_lanes = -1;
	num_lanes = hw_read_cal_bus_uint32(id, group, 0, 0, AVL_CTRL_REG_GROUP_INFO);
	num_lanes = (num_lanes & NUM_LANES_MASK) >> 8;

	return num_lanes;
}

//START_FUNCTION_HEADER//////////////////////////////////////////////////////
//
int hw_get_num_pins(unsigned int id, unsigned int group)
//
// Description: Get num of pins of a given Group
//
// Returns: 	number of pins, -1 otherwise.
//
//END_FUNCTION_HEADER////////////////////////////////////////////////////////
{
	int num_lanes = -1;
	num_lanes = hw_read_cal_bus_uint32(id, group, 0, 0, AVL_CTRL_REG_GROUP_INFO);
	num_lanes = (num_lanes & NUM_PINS_MASK);

	return num_lanes;
}

//START_FUNCTION_HEADER//////////////////////////////////////////////////////
//
int hw_get_output_delay(unsigned int id, unsigned int group, unsigned int pin, unsigned int csr)
//
// Description: Get output delay of a given pin
//
// Returns: 	Delay if succeeded, -1 otherwise.
//
//END_FUNCTION_HEADER////////////////////////////////////////////////////////
{
	int delay = -1;
	delay = hw_read_cal_bus_uint32(id, group, pin, csr, AVL_CTRL_REG_ODELAY);

	return delay;
}

//START_FUNCTION_HEADER//////////////////////////////////////////////////////
//
void hw_set_output_delay(unsigned int id, unsigned int group, unsigned int pin, unsigned int delay)
//
// Description: Set output delay of a given pin
//
// Returns: 	1 if succeeded, -1 otherwise.
//
//END_FUNCTION_HEADER////////////////////////////////////////////////////////
{
	unsigned int csr = 0;
	hw_write_cal_bus_uint32(id, group, pin, csr, AVL_CTRL_REG_ODELAY, delay);
}

//START_FUNCTION_HEADER//////////////////////////////////////////////////////
//
int hw_get_input_delay(unsigned int id, unsigned int group, unsigned int pin, unsigned csr)
//
// Description: Get input delay of a given pin
//
// Returns: 	Delay if succeeded, -1 otherwise.
//
//END_FUNCTION_HEADER////////////////////////////////////////////////////////
{
	int delay = -1;
	delay = hw_read_cal_bus_uint32(id, group, pin, csr, AVL_CTRL_REG_IDELAY);

	return delay;
}

//START_FUNCTION_HEADER//////////////////////////////////////////////////////
//
void hw_set_input_delay(unsigned int id, unsigned int group, unsigned int pin, unsigned int delay)
//
// Description: Set input delay of a given pin
//
// Returns: 	1 if succeeded, -1 otherwise.
//
//END_FUNCTION_HEADER////////////////////////////////////////////////////////
{
	unsigned int csr = 0;
	hw_write_cal_bus_uint32(id, group, pin, csr, AVL_CTRL_REG_IDELAY, delay);
}

//START_FUNCTION_HEADER//////////////////////////////////////////////////////
//
int hw_get_strobe_input_delay(unsigned int id, unsigned int group, unsigned int pin, unsigned csr)
//
// Description: Get strobe input delay of a given pin
//
// Returns: 	Delay if succeeded, -1 otherwise.
//
//END_FUNCTION_HEADER////////////////////////////////////////////////////////
{
	int delay = -1;
	delay = hw_read_cal_bus_uint32(id, group, pin, csr, AVL_CTRL_REG_DQS_DELAY);

	return delay;
}

//START_FUNCTION_HEADER//////////////////////////////////////////////////////
//
void hw_set_strobe_input_delay(unsigned int id, unsigned int group, unsigned int pin, unsigned int delay)
//
// Description: Set strobe input delay of a given pin
//
// Returns: 	1 if succeeded, -1 otherwise.
//
//END_FUNCTION_HEADER////////////////////////////////////////////////////////
{
	unsigned int csr = 0;
	hw_write_cal_bus_uint32(id, group, pin, csr, AVL_CTRL_REG_DQS_DELAY, delay);
}

//START_FUNCTION_HEADER//////////////////////////////////////////////////////
//
int hw_get_strobe_enable_delay(unsigned int id, unsigned int group, unsigned int pin, unsigned csr)
//
// Description: Get strobe enable input delay of a given pin
//
// Returns: 	Delay if succeeded, -1 otherwise.
//
//END_FUNCTION_HEADER////////////////////////////////////////////////////////
{
	int delay = -1;
	delay = hw_read_cal_bus_uint32(id, group, pin, csr, AVL_CTRL_REG_DQS_EN_DELAY);

	return delay;
}

//START_FUNCTION_HEADER//////////////////////////////////////////////////////
//
void hw_set_strobe_enable_delay(unsigned int id, unsigned int group, unsigned int pin, unsigned int delay)
//
// Description: Set strobe enable input delay of a given pin
//
// Returns: 	1 if succeeded, -1 otherwise.
//
//END_FUNCTION_HEADER////////////////////////////////////////////////////////
{
	unsigned int csr = 0;
	hw_write_cal_bus_uint32(id, group, pin, csr, AVL_CTRL_REG_DQS_EN_DELAY, delay);
}

//START_FUNCTION_HEADER//////////////////////////////////////////////////////
//
int hw_get_strobe_enable_phase(unsigned int id, unsigned int group, unsigned int pin, unsigned csr)
//
// Description: Get strobe enable input phase of a given pin
//
// Returns: 	Delay if succeeded, -1 otherwise.
//
//END_FUNCTION_HEADER////////////////////////////////////////////////////////
{
	int delay = -1;
	delay = hw_read_cal_bus_uint32(id, group, pin, csr, AVL_CTRL_REG_DQS_EN_PHASE_SHIFT);

	return delay;
}

//START_FUNCTION_HEADER//////////////////////////////////////////////////////
//
void hw_set_strobe_enable_phase(unsigned int id, unsigned int group, unsigned int pin, unsigned int delay)
//
// Description: Set strobe enable input phase of a given pin
//
// Returns: 	1 if succeeded, -1 otherwise.
//
//END_FUNCTION_HEADER////////////////////////////////////////////////////////
{
	unsigned int csr = 0;
	hw_write_cal_bus_uint32(id, group, pin, csr, AVL_CTRL_REG_DQS_EN_PHASE_SHIFT, delay);
}

//START_FUNCTION_HEADER//////////////////////////////////////////////////////
//
int hw_get_read_valid_enable_delay(unsigned int id, unsigned int group, unsigned int pin, unsigned csr)
//
// Description: Get read valid enable of a given pin
//
// Returns: 	Delay if succeeded, -1 otherwise.
//
//END_FUNCTION_HEADER////////////////////////////////////////////////////////
{
	int delay = -1;
	delay = hw_read_cal_bus_uint32(id, group, pin, csr, AVL_CTRL_REG_RD_VALID_DELAY);

	return delay;
}

//START_FUNCTION_HEADER//////////////////////////////////////////////////////
//
void hw_set_read_valid_enable_delay(unsigned int id, unsigned int group, unsigned int pin, unsigned int delay)
//
// Description: Set read valid enable of a given pin
//
// Returns: 	1 if succeeded, -1 otherwise.
//
//END_FUNCTION_HEADER////////////////////////////////////////////////////////
{
	unsigned int csr = 0;
	hw_write_cal_bus_uint32(id, group, pin, csr, AVL_CTRL_REG_RD_VALID_DELAY, delay);
}
