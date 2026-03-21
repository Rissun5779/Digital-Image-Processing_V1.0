# (C) 2001-2018 Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files from any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License Subscription 
# Agreement, Intel FPGA IP License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Intel and sold by 
# Intel or its authorized distributors.  Please refer to the applicable 
# agreement for further details.



proc target_dev_kit_hps_a10_soc_ddr4_data {name} {
   set data(${name}_pll_ref_clk_clk)            {1    "input"     0        {PIN_F25}}
   set data(oct_oct_rzqin)                      {1    "input"     0        {PIN_E26}}
   set data(global_reset_reset_n)               {1    "input"     0        {PIN_P3}}
   set data(${name}_status_local_cal_fail)      {1    "output"    0        {PIN_AR23}}
   set data(${name}_status_local_cal_success)   {1    "output"    0        {PIN_AR22}}
   set data(${name}_tg_0_traffic_gen_fail)      {1    "output"    0        {PIN_AL20}}
   set data(${name}_tg_0_traffic_gen_pass)      {1    "output"    0        {PIN_AM21}}
   set data(${name}_tg_0_traffic_gen_timeout)   {1    "output"    0        {PIN_E1}}
   set data(${name}_mem_mem_a)                  {17   "output"    0        {PIN_B26 PIN_C26 PIN_C22 PIN_C21 PIN_C25 PIN_B24 PIN_B22 PIN_C23 PIN_D23 PIN_E23 PIN_C24 PIN_D24 PIN_F26 PIN_G26 PIN_G25 PIN_F24 PIN_F23}}
   set data(${name}_mem_mem_act_n)              {1    "output"    0        {PIN_B21}}
   set data(${name}_mem_mem_alert_n)            {1    "input"     0        {PIN_AG24}}
   set data(${name}_mem_mem_ba)                 {2    "output"    0        {PIN_E25 PIN_H24}}
   set data(${name}_mem_mem_bg)                 {1    "output"    0        {PIN_J24}}
   set data(${name}_mem_mem_ck)                 {1    "output"    0        {PIN_B20}}
   set data(${name}_mem_mem_ck_n)               {1    "output"    0        {PIN_B19}}
   set data(${name}_mem_mem_cke)                {1    "output"    0        {PIN_A24}}
   set data(${name}_mem_mem_cs_n)               {1    "output"    0        {PIN_A22}}
   set data(${name}_mem_mem_dbi_n)              {5    "inout"     0        {PIN_AV26 PIN_AU25 PIN_AN26 PIN_AH25 PIN_P25}}
   set data(${name}_mem_mem_dq)                 {40   "inout"     0        {PIN_AW28 PIN_AV28 PIN_AV24 PIN_AW24 PIN_AV27 PIN_AU27 PIN_AU28 PIN_AV23 PIN_AU26 PIN_AR25 PIN_AT26 PIN_AR26 PIN_AU24 PIN_AP25 PIN_AT23 PIN_AP23 PIN_AL26 PIN_AN23 PIN_AN24 PIN_AK26 PIN_AK23 PIN_AL23 PIN_AP26 PIN_AM24 PIN_AF24 PIN_AF25 PIN_AG25 PIN_AH24 PIN_AJ24 PIN_AJ23 PIN_AH23 PIN_AJ26 PIN_M25 PIN_K26 PIN_N25 PIN_L26 PIN_L25 PIN_N24 PIN_M24 PIN_J25}}
   set data(${name}_mem_mem_dqs)                {5    "inout"     0        {PIN_AW26 PIN_AT25 PIN_AM25 PIN_AK25 PIN_K25}}
   set data(${name}_mem_mem_dqs_n)              {5    "inout"     0        {PIN_AW25 PIN_AT24 PIN_AL25 PIN_AJ25 PIN_L24}}
   set data(${name}_mem_mem_odt)                {1    "output"    0        {PIN_A26}}
   set data(${name}_mem_mem_par)                {1    "output"    0        {PIN_A18}}
   set data(${name}_mem_mem_reset_n)            {1    "output"    0        {PIN_A19}}
   
   return [array get data]
}

proc target_dev_kit_a10_soc_ddr4_data {name} {

   set data(${name}_pll_ref_clk_clk)            {1    "input"     0        {PIN_AG5}}
   set data(oct_oct_rzqin)                      {1    "input"     0        {PIN_AH7}}
   set data(global_reset_reset_n)               {1    "input"     0        {PIN_P3}}
   set data(${name}_status_local_cal_fail)      {1    "output"    0        {PIN_AR23}}
   set data(${name}_status_local_cal_success)   {1    "output"    0        {PIN_AR22}}
   set data(${name}_tg_0_traffic_gen_fail)      {1    "output"    0        {PIN_AL20}}
   set data(${name}_tg_0_traffic_gen_pass)      {1    "output"    0        {PIN_AM21}}
   set data(${name}_tg_0_traffic_gen_timeout)   {1    "output"    0        {PIN_E1}}
   set data(${name}_mem_mem_a)                  {17   "output"    0        {PIN_AN3 PIN_AM4 PIN_AL3 PIN_AL4 PIN_AL5 PIN_AK5 PIN_AK6 PIN_AJ6 PIN_AK3 PIN_AJ4 PIN_AJ5 PIN_AH6 PIN_AG7 PIN_AJ3 PIN_AH3 PIN_AF7 PIN_AE7}}
   set data(${name}_mem_mem_act_n)              {1    "output"    0        {PIN_AL2}}
   set data(${name}_mem_mem_alert_n)            {1    "input"     0        {PIN_AF9}}
   set data(${name}_mem_mem_ba)                 {2    "output"    0        {PIN_AF5 PIN_AH4}}
   set data(${name}_mem_mem_bg)                 {1    "output"    0        {PIN_AG4}}
   set data(${name}_mem_mem_ck)                 {1    "output"    0        {PIN_AK1}}
   set data(${name}_mem_mem_ck_n)               {1    "output"    0        {PIN_AK2}}
   set data(${name}_mem_mem_cke)                {1    "output"    0        {PIN_AM1}}
   set data(${name}_mem_mem_cs_n)               {1    "output"    0        {PIN_AM2}}
   set data(${name}_mem_mem_dbi_n)              {9    "inout"     0        {PIN_AH8 PIN_AM6 PIN_AM5 PIN_AT4 PIN_AA10 PIN_AB5 PIN_AB2 PIN_AC1 PIN_AE11}}
   set data(${name}_mem_mem_dq)                 {72   "inout"     0        {PIN_AG12 PIN_AJ9 PIN_AH9 PIN_AF12 PIN_AH11 PIN_AG11 PIN_AJ8 PIN_AJ11 PIN_AK8 PIN_AL8 PIN_AK10 PIN_AL9 PIN_AN6 PIN_AK7 PIN_AM9 PIN_AL7 PIN_AR3 PIN_AU2 PIN_AP4 PIN_AP3 PIN_AN4 PIN_AU1 PIN_AP5 PIN_AT3 PIN_AU4 PIN_AW5 PIN_AU5 PIN_AV4 PIN_AW4 PIN_AR6 PIN_AR7 PIN_AT5 PIN_Y8  PIN_AB11 PIN_AB10 PIN_AB9 PIN_W8  PIN_Y10 PIN_AA9 PIN_AB7 PIN_Y6  PIN_Y7  PIN_AA5 PIN_Y5  PIN_AD4 PIN_AC6 PIN_AD5 PIN_AB6 PIN_AB4 PIN_W1  PIN_Y1  PIN_AA4 PIN_Y3  PIN_AB1 PIN_Y2  PIN_AC4 PIN_AE3 PIN_AE2 PIN_AE1 PIN_AF3 PIN_AG2 PIN_AF2 PIN_AD3 PIN_AD1 PIN_AD9 PIN_AE10 PIN_AC8 PIN_AC9 PIN_AD8 PIN_AC11 PIN_AD10 PIN_AF10}}
   set data(${name}_mem_mem_dqs)                {9    "inout"     0        {PIN_AG9 PIN_AN7 PIN_AR5 PIN_AW6 PIN_AA7 PIN_AE5 PIN_AA2 PIN_AH1 PIN_AF8}}
   set data(${name}_mem_mem_dqs_n)              {9    "inout"     0        {PIN_AG10 PIN_AM7 PIN_AP6 PIN_AV6 PIN_AA8 PIN_AE6 PIN_AA3 PIN_AG1 PIN_AE8}}
   set data(${name}_mem_mem_odt)                {1    "output"    0        {PIN_AR1}}
   set data(${name}_mem_mem_par)                {1    "output"    0        {PIN_AH2}}
   set data(${name}_mem_mem_reset_n)            {1    "output"    0        {PIN_AN2}}
   
   return [array get data]
}

proc target_dev_kit_a10_gx_fpga_ddr3_data {name} {
   set data(${name}_pll_ref_clk_clk)            {1    "input"     0        {PIN_F34}}
   set data(oct_oct_rzqin)                      {1    "input"     0        {PIN_J34}}
   set data(global_reset_reset_n)               {1    "input"     0        {PIN_U11}}
   set data(${name}_status_local_cal_fail)      {1    "output"    1        {PIN_M23}}
   set data(${name}_status_local_cal_success)   {1    "output"    1        {PIN_D18}}
   set data(${name}_tg_0_traffic_gen_fail)      {1    "output"    1        {PIN_L27}}
   set data(${name}_tg_0_traffic_gen_pass)      {1    "output"    1        {PIN_L28}}
   set data(${name}_tg_0_traffic_gen_timeout)   {1    "output"    1        {PIN_L23}}
   set data(${name}_mem_mem_a)                  {15   "output"    0        {PIN_M32 PIN_L32 PIN_N34 PIN_M35 PIN_L34 PIN_K34 PIN_M33 PIN_L33 PIN_J33 PIN_J32 PIN_H31 PIN_J31 PIN_H34 PIN_H33 PIN_G32}}
   set data(${name}_mem_mem_ba)                 {3    "output"    0        {PIN_F33 PIN_G35 PIN_H35}}
   set data(${name}_mem_mem_cas_n)              {1    "output"    0        {PIN_G33}}
   set data(${name}_mem_mem_ck)                 {1    "output"    0        {PIN_R30}}
   set data(${name}_mem_mem_ck_n)               {1    "output"    0        {PIN_R31}}
   set data(${name}_mem_mem_cke)                {1    "output"    0        {PIN_U33}}
   set data(${name}_mem_mem_cs_n)               {1    "output"    0        {PIN_R34}}
   set data(${name}_mem_mem_dm)                 {9    "output"    0        {PIN_E26 PIN_G27 PIN_A29 PIN_F30 PIN_AB32 PIN_AG31 PIN_Y35 PIN_AC34 PIN_A32}}
   set data(${name}_mem_mem_dq)                 {72   "inout"     0        {PIN_B28 PIN_A28 PIN_A27 PIN_B27 PIN_D27 PIN_E27 PIN_D26 PIN_D28 PIN_G25 PIN_H25 PIN_G26 PIN_H26 PIN_G28 PIN_F27 PIN_K27 PIN_F28 PIN_D31 PIN_E31 PIN_B31 PIN_C31 PIN_A30 PIN_E30 PIN_B30 PIN_D29 PIN_K30 PIN_H30 PIN_G30 PIN_K31 PIN_H29 PIN_K29 PIN_J29 PIN_F29 PIN_AC31 PIN_AB31 PIN_W31 PIN_Y31 PIN_AD31 PIN_AD32 PIN_AD33 PIN_AA30 PIN_AE31 PIN_AE32 PIN_AE30 PIN_AF30 PIN_AG33 PIN_AG32 PIN_AH33 PIN_AH31 PIN_U31 PIN_W33 PIN_W32 PIN_V31 PIN_Y34 PIN_W35 PIN_W34 PIN_V34 PIN_AH35 PIN_AJ34 PIN_AJ33 PIN_AH34 PIN_AD35 PIN_AE34 PIN_AC33 PIN_AD34 PIN_A33 PIN_B32 PIN_D32 PIN_C33 PIN_B33 PIN_D34 PIN_C35 PIN_E34}}
   set data(${name}_mem_mem_dqs)                {9    "inout"     0        {PIN_B26 PIN_H28 PIN_C30 PIN_L30 PIN_Y32 PIN_AJ32 PIN_AA34 PIN_AF33 PIN_D33}}
   set data(${name}_mem_mem_dqs_n)              {9    "inout"     0        {PIN_C26 PIN_J27 PIN_C29 PIN_L29 PIN_AA32 PIN_AJ31 PIN_AA33 PIN_AF34 PIN_C34}}
   set data(${name}_mem_mem_odt)                {1    "output"    0        {PIN_N33}}
   set data(${name}_mem_mem_ras_n)              {1    "output"    0        {PIN_F32}}
   set data(${name}_mem_mem_reset_n)            {1    "output"    0        {PIN_T35}}
   set data(${name}_mem_mem_we_n)               {1    "output"    0        {PIN_T34}}
   
   return [array get data]
}

proc target_dev_kit_a10_gx_fpga_ddr4_data {name} {
   set data(${name}_pll_ref_clk_clk)            {1    "input"     0        {PIN_F34}}
   set data(oct_oct_rzqin)                      {1    "input"     0        {PIN_J34}}
   set data(global_reset_reset_n)               {1    "input"     0        {PIN_U11}}
   set data(${name}_status_local_cal_fail)      {1    "output"    1        {PIN_M23}}
   set data(${name}_status_local_cal_success)   {1    "output"    1        {PIN_D18}}
   set data(${name}_tg_0_traffic_gen_fail)      {1    "output"    1        {PIN_L27}}
   set data(${name}_tg_0_traffic_gen_pass)      {1    "output"    1        {PIN_L28}}
   set data(${name}_tg_0_traffic_gen_timeout)   {1    "output"    1        {PIN_L23}}
   set data(${name}_mem_mem_a)                  {17   "output"    0        {PIN_M32 PIN_L32 PIN_N34 PIN_M35 PIN_L34 PIN_K34 PIN_M33 PIN_L33 PIN_J33 PIN_J32 PIN_H31 PIN_J31 PIN_H34 PIN_H33 PIN_G32 PIN_E32 PIN_F32}}
   set data(${name}_mem_mem_act_n)              {1    "output"    0        {PIN_P34}}
   set data(${name}_mem_mem_alert_n)            {1    "input"     0        {PIN_E35}}
   set data(${name}_mem_mem_ba)                 {2    "output"    0        {PIN_F33 PIN_G35}}
   set data(${name}_mem_mem_bg)                 {1    "output"    0        {PIN_H35}}
   set data(${name}_mem_mem_ck)                 {1    "output"    0        {PIN_R30}}
   set data(${name}_mem_mem_ck_n)               {1    "output"    0        {PIN_R31}}
   set data(${name}_mem_mem_cke)                {1    "output"    0        {PIN_U33}}
   set data(${name}_mem_mem_cs_n)               {1    "output"    0        {PIN_R34}}
   set data(${name}_mem_mem_dbi_n)              {9    "inout"     0        {PIN_E26 PIN_G27 PIN_A29 PIN_F30 PIN_AB32 PIN_AG31 PIN_Y35 PIN_AC34 PIN_A32}}
   set data(${name}_mem_mem_dq)                 {72   "inout"     0        {PIN_B28 PIN_A28 PIN_A27 PIN_B27 PIN_D27 PIN_E27 PIN_D26 PIN_D28 PIN_G25 PIN_H25 PIN_G26 PIN_H26 PIN_G28 PIN_F27 PIN_K27 PIN_F28 PIN_D31 PIN_E31 PIN_B31 PIN_C31 PIN_A30 PIN_E30 PIN_B30 PIN_D29 PIN_K30 PIN_H30 PIN_G30 PIN_K31 PIN_H29 PIN_K29 PIN_J29 PIN_F29 PIN_AC31 PIN_AB31 PIN_W31 PIN_Y31 PIN_AD31 PIN_AD32 PIN_AD33 PIN_AA30 PIN_AE31 PIN_AE32 PIN_AE30 PIN_AF30 PIN_AG33 PIN_AG32 PIN_AH33 PIN_AH31 PIN_U31 PIN_W33 PIN_W32 PIN_V31 PIN_Y34 PIN_W35 PIN_W34 PIN_V34 PIN_AH35 PIN_AJ34 PIN_AJ33 PIN_AH34 PIN_AD35 PIN_AE34 PIN_AC33 PIN_AD34 PIN_A33 PIN_B32 PIN_D32 PIN_C33 PIN_B33 PIN_D34 PIN_C35 PIN_E34}}
   set data(${name}_mem_mem_dqs)                {9    "inout"     0        {PIN_B26 PIN_H28 PIN_C30 PIN_L30 PIN_Y32 PIN_AJ32 PIN_AA34 PIN_AF33 PIN_D33}}
   set data(${name}_mem_mem_dqs_n)              {9    "inout"     0        {PIN_C26 PIN_J27 PIN_C29 PIN_L29 PIN_AA32 PIN_AJ31 PIN_AA33 PIN_AF34 PIN_C34}}
   set data(${name}_mem_mem_odt)                {1    "output"    0        {PIN_N33}}
   set data(${name}_mem_mem_par)                {1    "output"    0        {PIN_T32}}
   set data(${name}_mem_mem_reset_n)            {1    "output"    0        {PIN_T35}}
   
   return [array get data]
}

proc target_dev_kit_a10_gx_fpga_rldram3_data {name} {
   set data(${name}_pll_ref_clk_clk)            {1    "input"     0        {PIN_F34}}
   set data(oct_oct_rzqin)                      {1    "input"     0        {PIN_J34}}
   set data(global_reset_reset_n)               {1    "input"     0        {PIN_U11}}
   set data(${name}_status_local_cal_fail)      {1    "output"    1        {PIN_M23}}
   set data(${name}_status_local_cal_success)   {1    "output"    1        {PIN_D18}}
   set data(${name}_tg_0_traffic_gen_fail)      {1    "output"    1        {PIN_L27}}
   set data(${name}_tg_0_traffic_gen_pass)      {1    "output"    1        {PIN_L28}}
   set data(${name}_tg_0_traffic_gen_timeout)   {1    "output"    1        {PIN_L23}}
   set data(${name}_mem_mem_a)                  {21   "output"    0        {PIN_M32 PIN_L32 PIN_N34 PIN_M35 PIN_L34 PIN_K34 PIN_M33 PIN_L33 PIN_J33 PIN_J32 PIN_H31 PIN_J31 PIN_H34 PIN_H33 PIN_G32 PIN_E32 PIN_F32 PIN_G33 PIN_N33 PIN_P33 PIN_U33}}
   set data(${name}_mem_mem_ba)                 {4    "output"    0        {PIN_F33 PIN_G35 PIN_H35 PIN_T34}}
   set data(${name}_mem_mem_ck)                 {1    "output"    0        {PIN_R30}}
   set data(${name}_mem_mem_ck_n)               {1    "output"    0        {PIN_R31}}
   set data(${name}_mem_mem_cs_n)               {1    "output"    0        {PIN_R34}}
   set data(${name}_mem_mem_dk)                 {2    "output"    0        {PIN_AJ32 PIN_C30}}
   set data(${name}_mem_mem_dk_n)               {2    "output"    0        {PIN_AJ31 PIN_C29}}
   set data(${name}_mem_mem_dm)                 {2    "output"    0        {PIN_V33 PIN_G27}}
   set data(${name}_mem_mem_dq)                 {36   "inout"     0        {PIN_V31 PIN_W34 PIN_W33 PIN_W32 PIN_V34 PIN_Y34 PIN_Y35 PIN_U31 PIN_W35 PIN_F27 PIN_G25 PIN_G26 PIN_H25 PIN_H26 PIN_K27 PIN_F28 PIN_J28 PIN_G28 PIN_AD33 PIN_AA30 PIN_AB31 PIN_AD31 PIN_AD32 PIN_W31 PIN_AC31 PIN_Y31 PIN_AB32 PIN_K30 PIN_H29 PIN_G30 PIN_H30 PIN_K29 PIN_J29 PIN_K31 PIN_F29 PIN_G31}}
   set data(${name}_mem_mem_qk)                 {4    "input"     0        {PIN_AA34 PIN_H28 PIN_Y32 PIN_L30}}
   set data(${name}_mem_mem_qk_n)               {4    "input"     0        {PIN_AA33 PIN_J27 PIN_AA32 PIN_L29}}
   set data(${name}_mem_mem_ref_n)              {1    "output"    0        {PIN_T32}}
   set data(${name}_mem_mem_reset_n)            {1    "output"    0        {PIN_T35}}
   set data(${name}_mem_mem_we_n)               {1    "output"    0        {PIN_T33}}
   
   return [array get data]
}
