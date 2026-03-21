(C) 2001-2015 Altera Corporation. All rights reserved.
Your use of Altera Corporation's design tools, logic functions and other
software and tools, and its AMPP partner logic functions, and any output
files any of the foregoing (including device programming or simulation
files), and any associated documentation or information are expressly subject
to the terms and conditions of the Altera Program License Subscription
Agreement, Altera MegaCore Function License Agreement, or other applicable
license agreement, including, without limitation, that your use is for the
sole purpose of programming logic devices manufactured by Altera and sold by
Altera or its authorized distributors.  Please refer to the applicable
agreement for further details.

The Altera PCI Express Interop Test will perform the following:
==========================================================
1. Print the Config Space, Lane rate, and Lane width.
2. Write 32-bit data '0x00000000' data to the specified BAR at offset 0x00000000 to initialize the memory and then read it back.
3. Lastly, it will write '0xABCD1234' at offset 0x00000000 of the specified BAR, read it back, and compare.
   - A successful comparison will display the message 'PASSED'

Requirements:
=============
- Windows 7 32-bit or 64-bit OS
- Any BAR (0-5) enabled at address 0x00000000

Step 2:
-------
   - Unzip the file Altera_PCIe_Interop_Test.zip
      1. rename the file Altera_PCIe_Interop_Test_zip.v to Altera_PCIe_Interop_Test.zip
      2. Unzip the file Altera_PCIe_Interop_Test.zip, the resulting directories are:
         Altera_PCIe_Interop_Test
                 |-- Interop_software  : Altera PCIe Interop SOftware to run on the PCIe host machine
                 `-- Windows_driver    : Altera PCIe WIndows Drivers for 32-bit and 64-bit Windows 7
                     |-- 32-bit
                     `-- 64-bit

Step 2:
-------
   - Install the Altera Windows Demo Driver for PCIe on the host machine
      1. Program the Altera FPGA with the PCIe SOF
      2. Open Device Manager in Windows and Scan for hardware changes
      2. Select the Altera FPGA listed as an unknown PCI device and point to the appropriate 32/64 bit driver in the Windows_driver folder
      3. Once the driver is succefully loaded, a new device named "Altera PCI API Device" will be listed in the device list
      4. Determine the Bus, Device, and Function number for the Altera PCI device
         - Expand the tab "Altera PCI API Device" under the devices
         - Right click on the listed device "Altera PCI API Driver" and select properties
         - Note the Bus, device, function number for the Altera PCI device
Step 3:
-------
   - Run the Interop Software application "Alt_Test" located in the folder "Interop_software"
   - Enter the Bus, device, and function numbers and select the BAR number (0-5) when prompted
   - The application will display the message 'PASSED' if the test is successful


