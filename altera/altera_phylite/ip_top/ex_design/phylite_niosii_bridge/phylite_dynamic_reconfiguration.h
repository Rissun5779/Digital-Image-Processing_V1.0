
#ifndef PHYLITE_DYNAMIC_RECONFIGURATION_H_
#define PHYLITE_DYNAMIC_RECONFIGURATION_H_

// SW Translation Functions
int sw_get_num_groups				(unsigned int id);
int sw_get_output_delay(unsigned int id, unsigned int group, unsigned int pin, unsigned int csr);
int sw_get_group_info(unsigned int id, unsigned int group);
int sw_get_input_delay(unsigned int id, unsigned int group, unsigned int pin);

void sw_set_output_delay(unsigned int id, unsigned int group, unsigned int pin, unsigned int delay);
void sw_set_input_delay(unsigned int id, unsigned int group, unsigned int pin, unsigned int delay);

void reset_avalon_controller(unsigned int address);
// Avalon Controller Functions
int hw_get_num_groups				(unsigned int id);
int hw_get_group_info				(unsigned int id, unsigned int group);
int hw_get_num_lanes				(unsigned int id, unsigned int group);
int hw_get_num_pins				(unsigned int id, unsigned int group);
int hw_get_input_delay				(unsigned int id, unsigned int group, unsigned int pin, unsigned int csr);
int hw_get_output_delay			(unsigned int id, unsigned int group, unsigned int pin, unsigned int csr);
int hw_get_strobe_input_delay		(unsigned int id, unsigned int group, unsigned int pin, unsigned int csr);
int hw_get_strobe_enable_delay		(unsigned int id, unsigned int group, unsigned int pin, unsigned int csr);
int hw_get_strobe_enable_phase		(unsigned int id, unsigned int group, unsigned int pin, unsigned int csr);
int hw_get_read_valid_enable_delay	(unsigned int id, unsigned int group, unsigned int pin, unsigned int csr);
//int get_vref_code				(unsigned int id, unsigned int group, unsigned int pin, unsigned int csr);

void hw_set_input_delay			(unsigned int id, unsigned int group, unsigned int pin, unsigned int delay);
void hw_set_output_delay			(unsigned int id, unsigned int group, unsigned int pin, unsigned int delay);
void hw_set_strobe_input_delay		(unsigned int id, unsigned int group, unsigned int pin, unsigned int delay);
void hw_set_strobe_enable_delay	(unsigned int id, unsigned int group, unsigned int pin, unsigned int delay);
void hw_set_strobe_enable_phase	(unsigned int id, unsigned int group, unsigned int pin, unsigned int delay);
void hw_set_read_valid_enable_delay(unsigned int id, unsigned int group, unsigned int pin, unsigned int delay);
//void set_vref_code				(unsigned int id, unsigned int group, unsigned int pin, unsigned int code);

#endif
