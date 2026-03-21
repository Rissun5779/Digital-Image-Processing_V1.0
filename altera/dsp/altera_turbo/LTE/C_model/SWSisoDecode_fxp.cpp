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
// File : SWSisoDecode_fxp.cpp generated at Mon Dec 21 10:30:19 2015
//
// NB: THIS FILE IS AUTO-GENERATED, PLEASE DON'T MODIFY IT.
//=============================================================================
//
#include<vector>
#include<fstream>
#include"cobf_turbo.h"
#if ! defined( SC_INCLUDE_FX)
#define SC_INCLUDE_FX
#endif
#include"uncobf_turbo.h"
#include"systemc.h"
#include"cobf_turbo.h"
l129 l110 l132;l87 l82 lw;l87 l82 lj;l214 lv{l193:lv(lf<lw> *l65,lf<
lw> *l66,lf<lj> *l60,lf<lj> *l59,la*l12,la*l9,la*l13,la*l11,lf<lw>&
l46,lf<lw>&l47,la lu,la lp,la lt,la l29,la ls,la l3,lf<lj>&l44,la l23
,la*ly,la l31);~lv();le l128();l100:lj l43(lj,lj);le l134();le l136();
le l141();le l116(la lq);le l123();le l95(la lm,la ld);le l107(la lm,
la ld,la lr);le l114(la lq);le l143(la lm,la ld);le l130(la lq);le
l150(la lm,la ld,la lr);le l137(la ld);le l142(la ld,la lr);le l151(
la lq);le l118(la lm,la ld,la lr);le l133(la lm,la ld);le l131(la lq);
l88:lv(){}lj l189(la lm,la l38,la lp);le l162(la lq);l100:l55*l207;
l55*l211;l88:la*l12, *l9, *l13, *l11;la lp,l48;la l29;la ls,l3;la l23
;la l70,l156,l153;la l61,l86,l85;la l20,l52,l51;la l53;la ll;la l121;
lw l35,l78;la l180;l30 l90;l30 l183;lf<la>l79,l71,l77,l75;lf<lw> *
l172, *l76;lf<lj> *l117, *l91;lf<lj>l15;lf<lw>l27;lf<lw>l37;lf<lf<lj>
>l21;lf<lf<lj> >l22;lf<lf<lj> >l50;lf<lf<lj> >l26;lf<lj>l73,l68;lf<lf
<lj> >l74,l72;lf<lj>l41,l40;la lq;l212 l198;};le l104(li*l65,li*l66,
li*l60,li*l59,li*l46,li*l47,la*l135,la lu,la lp,la ll,la l127,la l33,
la l36,la l111,la ls,la l3,li*l44,la l18,la l23,la*ly,la l31);la l96(
la*l10,la l98,la l58,la l149);l242"\x43"{
#include"uncobf_turbo.h"
#include<stdlib.h>
#include"cobf_turbo.h"
le l238(la l234[],la l38,la l120){la l56;lg(l56=0;l56<l120;l56++){
l234[l120-l56-1]=(l38&1);l38=l38>>1;}l16;}la l113(la l38,la l120){la
l56;la l158=0;lg(l56=0;l56<l120;l56++){l158=l158^(l38&1);l38=l38>>1;}
l16(l158);}l89 la l223(la*l165,la l10,la l152,la l39[],la lu,la lp){
la lc,lb;la l54=0;lc=(l10<<(lu-1))^l152;lg(lb=0;lb<lp;lb++){l54=(l54
<<1)+l113(lc&l39[lb],lu);}l165[0]=lc>>1;l16(l54);}l89 la l220(la*l165
,la l10,la l152,la l39[],la lu,la lp){la lc,lb,l54,l191;l54=l10;l191=
l10^l113(l39[0]&l152,lu);lc=(l191<<(lu-1))^l152;lg(lb=1;lb<lp;lb++){
l54=(l54<<1)+l113(lc&l39[lb],lu);}l165[0]=lc>>1;l16(l54);}l89 le l206
(la l99[],la l161[],la l10,la l39[],la lu,la lp){la l103;la lc,l94;
l94=(1<<(lu-1));lg(lc=0;lc<l94;lc++){l99[lc]=l223(&l103,l10,lc,l39,lu
,lp);l161[lc]=l103;}l16;}l89 le l205(la l99[],la l161[],la l10,la l39
[],la lu,la lp){la l103;la lc,l94;l94=1<<(lu-1);lg(lc=0;lc<l94;lc++){
l99[lc]=l220(&l103,l10,lc,l39,lu,lp);l161[lc]=l103;}l16;}l89 le l261(
la l233[],la l39[],la ll,la l53){la lc;lg(lc=0;lc<ll;lc++){l233[lc]=
l113(l39[0]&lc,l53);}l16;}l89 le l260(la l99[],la l10[],la l12[],la l9
[],la l13[],la l11[],la l227[],la lu,la lt,la lp){la lb,lh,l179,l181;
la*l119;la lc=0;l119=(la* )l0(lp,lz(la));lg(lb=0;lb<lt+lu-1;lb++){lk(
lb<lt)l179=l10[lb];lx l179=l227[lc];lk(l179){l181=l13[lc];lc=l11[lc];
}lx{l181=l12[lc];lc=l9[lc];}l238(l119,l181,lp);lg(lh=0;lh<lp;lh++)l99
[lp*lb+lh]=l119[lh];}l1(l119);l16;}}le l104(li*l65,li*l66,li*l60,li*
l59,li*l46,li*l47,la*l135,la lu,la lp,la ll,la l127,la l33,la l36,la
l111,la ls,la l3,li*l44,la l18,la l23,la*ly,la l31){lf<lw>l27;lf<lw>
l109;lf<lw>l37,l126;lf<lj>l144,l138;lf<lj>l15;la*l12, *l13, *l9, *l11
, *l32;ly[2]=ly[0]+5;ly[3]=ly[1];l192 l240(ly[0],ly[0]-ly[1],l184,
l204);l55 l248(l240);l27.l5(l36);lg(la lb=0;lb<l36;lb++){l27[lb]=l47[
lb];}l109.l5(l36);l192 l160(ly[2],ly[2]-ly[3],l184,l204);l55 l229(
l160);l37.l5(l33);lg(la lb=0;lb<l33;lb++){l37[lb]=l46[lb];}l32=(la* )l0
(lp,lz(la));lg(la lb=0;lb<lp;lb++){lg(la lh=0;lh<lu;lh++){lk(l135[lb*
lu+lh]!=0){l32[lb]=l32[lb]+(1<<(lu-lh-1));}}}l126.l5(l33);l138.l5(l33
);l144.l5(l18);l12=(la* )l0(ll,lz(la));l13=(la* )l0(ll,lz(la));l9=(la
 * )l0(ll,lz(la));l11=(la* )l0(ll,lz(la));lk(l127){l206(l12,l9,0,l32,
lu,lp);l206(l13,l11,1,l32,lu,lp);}lx{l205(l12,l9,0,l32,lu,lp);l205(
l13,l11,1,l32,lu,lp);}l15.l5(l18);lg(la lh=0;lh<l18;lh++){l15[lh]=l44
[lh];}lv l219(&l126,&l109,&l144,&l138,l12,l9,l13,l11,l37,l27,lu,lp,
l33,l111,ls,l3,l15,l23,ly,l31);l219.l128();lg(la lh=0;lh<l33;lh++){
l65[lh]=l126[lh].l176();}lg(la lh=0;lh<l33;lh++){l59[lh]=l138[lh].
l176();}lg(la lh=0;lh<l36;lh++){l66[lh]=l109[lh].l176();}lg(la lh=0;
lh<l18;lh++){l60[lh]=l144[lh].l176();}l126.l6();l144.l6();l109.l6();
l138.l6();l37.l6();l27.l6();l15.l6();l1(l12);l1(l13);l1(l9);l1(l11);
l1(l32);l16;}
