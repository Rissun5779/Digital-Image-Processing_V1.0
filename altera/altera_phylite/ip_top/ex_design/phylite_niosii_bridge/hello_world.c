#include <stdio.h>
#include "phylite_dynamic_reconfiguration.h"

#define ADDR_CAST(addr) ((void *)((unsigned int*)(addr)))
#define PIO_DONE_REGISTER_ADDR 0x0
#define IOWR32(addr, data) __builtin_stwio(ADDR_CAST(addr), data)
#define IORD32(addr) __builtin_ldwio(ADDR_CAST(addr))
//read from Avalon PIO Done register
unsigned int pio_read_done_register_uint32()
{
	return IORD32(PIO_DONE_REGISTER_ADDR);
}

void pio_write_done_register_uint32(unsigned int data)
{
	IOWR32(PIO_DONE_REGISTER_ADDR, data);
}

int main()
{
  printf("Hello from Nios II!\n");

  unsigned int id = 0;
  unsigned int group = 0;
  unsigned int pin = 0;
  unsigned int csr = 0;
  int delay = -1;

  delay = hw_get_num_groups(id);
  printf("Number of Groups: %d\n",delay);

  delay = hw_get_group_info(id, group);
  printf("Groups Info: %x\n",delay);

  delay = hw_get_num_lanes(id, group);
  printf("Number of lanes: %x\n",delay);

  delay = hw_get_num_pins(id, group);
  printf("Number of pins: %x\n",delay);

  hw_set_input_delay		( id,  group,  pin,  50);
  hw_set_output_delay		( id,  group,  pin,  51);
  hw_set_strobe_input_delay	( id,  group,  pin,  52);
  hw_set_strobe_enable_delay	( id,  group,  pin,  53);
  hw_set_strobe_enable_phase	( id,  group,  pin,  54);
  hw_set_read_valid_enable_delay( id,  group,  pin,  55);

  delay = hw_get_input_delay	( id,  group,  pin,  csr);
  printf("Input Delay: %d\n",delay);
  delay = hw_get_output_delay	( id,  group,  pin,  csr);
  printf("Output Delay: %d\n",delay);
  delay = hw_get_strobe_input_delay( id,  group,  pin,  csr);
  printf("Strobe Delay: %d\n",delay);
  delay = hw_get_strobe_enable_delay		( id,  group,  pin,  csr);
  printf("Strobe Enable delay: %d\n",delay);
  delay = hw_get_strobe_enable_phase	( id,  group,  pin,  csr);
  printf("Strobe Enable Phase: %d\n",delay);
  delay = hw_get_read_valid_enable_delay( id,  group,  pin,  csr);
  printf("Read Valid: %d\n",delay);
  pio_write_done_register_uint32(1);
  unsigned int done = pio_read_done_register_uint32();
  if (done) {
	  printf("DONE\n");
  } else {
	  printf("Failed to write to PIO_DONE_REGISTER\n");
  }

  return 0;
}
