//=============================================================================
// Legal Notice: Copyright (C) 2007-2008 Altera Corporation
// Any megafunction design, and related net list (encrypted or decrypted),
// support information, device programming or simulation file, and any other
// associated documentation or information provided by Altera or a partner
// under Altera's Megafunction Partnership Program may be used only to
// program PLD devices (but not masked PLD devices) from Altera.  Any other
// use of such megafunction design, net list, support information, device
// programming or simulation file, or any other related documentation or
// information is prohibited for any other purpose, including, but not
// limited to modification, reverse engineering, de-compiling, or use with
// any other silicon devices, unless such use is explicitly licensed under
// a separate agreement with Altera or a megafunction partner.  Title to
// the intellectual property, including patents, copyrights, trademarks,
// trade secrets, or maskworks, embodied in any such megafunction design,
// net list, support information, device programming or simulation file, or
// any other related documentation or information provided by Altera or a
// megafunction partner, remains with Altera, the megafunction partner, or
// their respective licensors.  No other licenses, including any licenses
// needed under any third party's intellectual property, are provided herein.
//=============================================================================
// File : crc.cpp generated at Mon Dec 21 10:30:20 2015
//
// NB: THIS FILE IS AUTO-GENERATED, PLEASE DON'T MODIFY IT.
//=============================================================================
//
#include<boost/crc.hpp>
#include<boost/cstdint.hpp>
#include<cstddef>
#include<stdlib.h>
#include"cobf_turbo.h"
l129 l110 l132;la l96(la*l10,la l98,la l58,la l149){l30*l101;la lb;
l257 l167;l101=(l30* )l0(l98,lz(l30));l247(l58){l218 0:l167=0x864CFB;
l92;l218 1:l167=0x800063;l92;l252:l16-1;}l241::l255<24>l185(l167,0,0,
l166,l149!=0);lg(lb=0;lb<l98;lb++){l101[lb]=((la)(l10[lb])!=0)?l210:
l166;l185.l246(l101[lb]);}l241::l254 l201=l185.l201();la l45=l201;lk(
l101!=l258){l1(l101);}l16 l45;}
