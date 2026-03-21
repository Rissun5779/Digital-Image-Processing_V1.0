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
// File : LTETurboDecoder_fxp.cpp generated at Mon Dec 21 10:30:20 2015
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
la*l10,la l98,la l58,la l149);
#include"uncobf_turbo.h"
#include"math.h"
#include<iostream>
#include"cobf_turbo.h"
l129 l110 l132;l242"\x43"{la l222(la l81,la l236){lk(l236%l81==0){l16
l81;}lx{l16 1;}}le l256(la lt,la*l45){la l81,ln,l187,l182,l122,lb,lh,
l174,l28,l213;la l57[8]={31,37,43,47,53,59,61,67};l187=8;l182=4;lk((
lt==1784)||(lt==3568)||(lt==7136)||(lt==8920)){l122=(la)(lt/l187);}lx
{l259("\x45\x72\x72\x6f\x72\x3a\x20\x43\x43\x53\x44\x53\x20\x49\x6e"
"\x74\x65\x72\x6c\x65\x61\x76\x65\x72\x20\x73\x69\x7a\x65\x20\x6d\x75"
"\x73\x74\x20\x62\x65\x20\x37\x31\x38\x34\x2c\x20\x33\x35\x36\x38\x2c"
"\x20\x37\x31\x33\x36\x2c\x20\x6f\x72\x20\x38\x39\x32\x30");l16;}lg(
ln=0;ln<lt;ln++){l81=ln%2;lb=(la)(ln/(2*l122));lh=((la)(ln/2))-lb*
l122;l174=(19*lb+1)%(l182);l28=l174%8;l213=(l57[l28] *lh+21*l81)%l122
;l45[ln]=2* (l174+l213*l182+1)-l81-1;}}le l250(la lt,la*l10,la*l45){
la lo,l24;la ln,lb,lh,l145;la l4,l164;la l57[52]={7,11,13,17,19,23,29
,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97,101,103,107,109,113,127
,131,137,139,149,151,157,163,167,173,179,181,191,193,197,199,211,223,
227,229,233,239,241,251,257};la l231[52]={3,2,2,3,2,5,2,3,2,6,3,5,2,2
,2,2,7,5,3,2,3,5,2,5,2,6,3,3,2,3,2,2,6,5,2,5,2,2,2,19,5,2,3,2,3,2,6,3
,7,7,6,3};la l195[5]={4,3,2,1,0};la l215[10]={9,8,7,6,5,4,3,2,1,0};la
l196[20]={19,9,14,4,0,2,5,7,12,18,16,13,17,15,3,1,6,11,8,10};la l194[
20]={19,9,14,4,0,2,5,7,12,18,10,8,13,17,3,1,16,6,15,11};la*l34, *l25,
 *l106, *lr, *l28, *l49;lk((40<=lt)&&(lt<=159)){lo=5;}lx lk((160<=lt)&&
(lt<=200)){lo=10;}lx lk((481<=lt)&&(lt<=530)){lo=10;}lx{lo=20;}lk((
481<=lt)&&(lt<=530)){l4=53;l24=l4;l164=2;}lx{lg(ln=0;ln<52;ln++){lk(
lt<=lo* (l57[ln]+1)){l92;}}l4=l57[ln];l164=l231[ln];lk(lt<=lo* (l4-1)){
l24=l4-1;}lx lk(lo*l4<lt){l24=l4+1;}lx{l24=l4;}}l34=(la* )l0(lo*l24,
lz(la));l106=(la* )l0(lo*l24,lz(la));l25=(la* )l0(lo*l24,lz(la));ln=0
;lg(lb=0;lb<lo;lb++){lg(lh=0;lh<l24;lh++){lk(ln<lt){l34[lb+lh*lo]=l10
[ln];}lx{l34[lb+lh*lo]=-1;}ln++;}}lr=(la* )l0(l4-1,lz(la));lr[0]=1;lg
(lh=1;lh<l4-1;lh++){lr[lh]=(l164*lr[lh-1])%l4;}l28=(la* )l0(lo,lz(la));
l28[0]=1;ln=0;lg(lb=1;lb<lo;lb++){l145=ln;lg(ln=l145;ln<52;ln++){lk((
l222(l57[ln],l4-1)==1)&&(l57[ln]>l28[lb-1])){l28[lb]=l57[ln];l92;}}}
l49=(la* )l0(lo,lz(la));lk(lo==5){lg(lb=0;lb<lo;lb++){l49[l195[lb]]=
l28[lb];}}lx lk(lo==10){lg(lb=0;lb<lo;lb++){l49[l215[lb]]=l28[lb];}}
lx lk(((2281<=lt)&&(lt<=2480))||((3161<=lt)&&(lt<=3210))){lg(lb=0;lb<
lo;lb++){l49[l196[lb]]=l28[lb];}}lx{lg(lb=0;lb<lo;lb++){l49[l194[lb]]
=l28[lb];}}lg(lb=0;lb<lo;lb++){lk(l24==l4){lg(lh=0;lh<=l4-2;lh++){ln=
lr[(lh*l49[lb])%(l4-1)];l25[lb+lh*lo]=l34[lb+ln*lo];}l25[lb+(l4-1) *
lo]=l34[lb];}lx lk(l24==l4+1){lg(lh=0;lh<=l4-2;lh++){ln=lr[(lh*l49[lb
])%(l4-1)];l25[lb+lh*lo]=l34[lb+ln*lo];}l25[lb+(l4-1) *lo]=l34[lb];
l25[lb+l4*lo]=l34[lb+l4*lo];lk((lt==lo*l24)&&(lb==lo-1)){l145=l25[lo-
1];l25[lo-1]=l25[(lo-1)+lo*l4];l25[(lo-1)+lo*l4]=l145;}}lx{lg(lh=0;lh
<=l4-2;lh++){ln=lr[(lh*l49[lb])%(l4-1)]-1;l25[lb+lh*lo]=l34[lb+ln*lo]
;}}}lg(lb=0;lb<lo;lb++){lk(lo==5){ln=l195[lb];}lx lk(lo==10){ln=l215[
lb];}lx lk(((2281<=lt)&&(lt<=2480))||((3161<=lt)&&(lt<=3210))){ln=
l196[lb];}lx{ln=l194[lb];}lg(lh=0;lh<l24;lh++){l106[lb+lh*lo]=l25[ln+
lh*lo];}}ln=0;lg(lh=0;lh<l24;lh++){lg(lb=0;lb<lo;lb++){lk(l106[lb+lh*
lo]>=0){l45[ln]=l106[lb+lh*lo];ln++;}}}l1(l34);l1(l106);l1(l25);l1(lr
);l1(l28);l1(l49);}la l226(la*l239,la l159,la l178,la l235){la l102,
l157;l217(l159<=l178){l102=(l159+l178)/2;l157=l239[l102]-l235;lk(l157
==0)l16 l102;lx lk(l157<0)l159=l102+1;lx l178=l102-1;}l16-1;}l30 l221
(la lt,la*l10,la*l45){la l171,l251,l190,l188;la ln,lb,lh;la l173[]={
40,48,56,64,72,80,88,96,104,112,120,128,136,144,152,160,168,176,184,
192,200,208,216,224,232,240,248,256,264,272,280,288,296,304,312,320,
328,336,344,352,360,368,376,384,392,400,408,416,424,432,440,448,456,
464,472,480,488,496,504,512,528,544,560,576,592,608,624,640,656,672,
688,704,720,736,752,768,784,800,816,832,848,864,880,896,912,928,944,
960,976,992,1008,1024,1056,1088,1120,1152,1184,1216,1248,1280,1312,
1344,1376,1408,1440,1472,1504,1536,1568,1600,1632,1664,1696,1728,1760
,1792,1824,1856,1888,1920,1952,1984,2016,2048,2112,2176,2240,2304,
2368,2432,2496,2560,2624,2688,2752,2816,2880,2944,3008,3072,3136,3200
,3264,3328,3392,3456,3520,3584,3648,3712,3776,3840,3904,3968,4032,
4096,4160,4224,4288,4352,4416,4480,4544,4608,4672,4736,4800,4864,4928
,4992,5056,5120,5184,5248,5312,5376,5440,5504,5568,5632,5696,5760,
5824,5888,5952,6016,6080,6144};la l232[]={3,7,19,7,7,11,5,11,7,41,103
,15,9,17,9,21,101,21,57,23,13,27,11,27,85,29,33,15,17,33,103,19,19,37
,19,21,21,115,193,21,133,81,45,23,243,151,155,25,51,47,91,29,29,247,
29,89,91,157,55,31,17,35,227,65,19,37,41,39,185,43,21,155,79,139,23,
217,25,17,127,25,239,17,137,215,29,15,147,29,59,65,55,31,17,171,67,35
,19,39,19,199,21,211,21,43,149,45,49,71,13,17,25,183,55,127,27,29,29,
57,45,31,59,185,113,31,17,171,209,253,367,265,181,39,27,127,143,43,29
,45,157,47,13,111,443,51,51,451,257,57,313,271,179,331,363,375,127,31
,33,43,33,477,35,233,357,337,37,71,71,37,39,127,39,39,31,113,41,251,
43,21,43,45,45,161,89,323,47,23,47,263};la l228[]={10,12,42,16,18,20,
22,24,26,84,90,32,34,108,38,120,84,44,46,48,50,52,36,56,58,60,62,32,
198,68,210,36,74,76,78,120,82,84,86,44,90,46,94,48,98,40,102,52,106,
72,110,168,114,58,118,180,122,62,84,64,66,68,420,96,74,76,234,80,82,
252,86,44,120,92,94,48,98,80,102,52,106,48,110,112,114,58,118,60,122,
124,84,64,66,204,140,72,74,76,78,240,82,252,86,88,60,92,846,48,28,80,
102,104,954,96,110,112,114,116,354,120,610,124,420,64,66,136,420,216,
444,456,468,80,164,504,172,88,300,92,188,96,28,240,204,104,212,192,
220,336,228,232,236,120,244,248,168,64,130,264,134,408,138,280,142,
480,146,444,120,152,462,234,158,80,96,902,166,336,170,86,174,176,178,
120,182,184,186,94,190,480};la l230=188;l30 l197=l166;ln=l226(l173,0,
l230-1,lt);lk(lt==l173[ln]){l197=l210;l171=l173[ln];l190=l232[ln];
l188=l228[ln];lg(lb=0;lb<lt;lb++){l45[lb]=(l190+l188*l10[lb])%l171;
l45[lb]=(l45[lb] *l10[lb])%l171;}}l16 l197;}}le l262(la*l147,li*l14,
la l2,la l199,la ls,la l245,la*ly,la l203,la l58,la l202){la l97;la lu
=4;la lp=2;la l36=lp* (l2+lu-1);la l32[8]={1,0,1,1,1,1,0,1};la l3=32;
la l31=4;la l146=lp* (l2+lu-1);la l18=l2*8;li*l115;li*l154;li*l168;li
 *l163;li*l112;li*l148;li*l155;li*l140;li*l93;li*l83;li*l67;li*l80;li
 *l84;li*l105;la*l69;la*l125;l115=(li* )l0(l2,lz(li));l154=(li* )l0(
l2,lz(li));l168=(li* )l0(l146,lz(li));l163=(li* )l0(l146,lz(li));l112
=(li* )l0(l18,lz(li));l148=(li* )l0(l18,lz(li));l155=(li* )l0(l2,lz(
li));l140=(li* )l0(l2,lz(li));l93=(li* )l0(l2,lz(li));l83=(li* )l0(l2
,lz(li));l67=(li* )l0(l146,lz(li));l80=(li* )l0(l146,lz(li));l84=(li*
)l0(l18,lz(li));l105=(li* )l0(l18,lz(li));l69=(la* )l0(l2,lz(la));
l125=(la* )l0(l2,lz(la));la lb,lh;la l108=1;lg(lb=0;lb<l2;lb++){l93[
lb]=0.0;l83[lb]=0.0;l125[lb]=lb;}lg(lb=0;lb<l18;lb++){l84[lb]=0.0;
l105[lb]=0.0;}la l225=ly[0];la l124=ly[1];li l175=l169(2.0,(l225-l124
-1));li l186=l175-l169(2.0,-l124);la l244=3* (l2+4);lg(lb=0;lb<l244;
lb++){lk(l14[lb]>l186){l14[lb]=l186;}lx{lk(l14[lb]<-l175){l14[lb]=-
l175;}}l14[lb]=l14[lb] *l169(2.0,l124);lk(l14[lb]<0){l14[lb]=li(l253(
l14[lb]));}lx{l14[lb]=li(l263(l14[lb]));}l14[lb]=l14[lb]/l169(2.0,
l124);}lg(lb=0;lb<l2;lb++){l67[2*lb]=l14[3*lb];l67[2*lb+1]=l14[3*lb+1
];l80[2*lb]=0.0;l80[2*lb+1]=l14[3*lb+2];}lg(lb=0;lb<6;lb++){l67[2*l2+
lb]=l14[3*l2+lb];}lg(lb=0;lb<6;lb++){l80[2*l2+lb]=l14[3*l2+6+lb];}
l221(l2,l125,l69);lg(l97=0;l97<l245;l97++){l104(l115,l168,l112,l155,
l93,l67,l32,lu,lp,8,0,l2,l36,l199,ls,l3,l84,l18,2*l97,ly,l31);lg(lb=0
;lb<l2;lb++){la ln=l69[lb];l83[lb]=l115[ln];}lg(lb=0;lb<l18;lb++){l84
[lb]=l112[lb];}lg(lb=0;lb<l2;lb++){l147[lb]=l155[lb]>=0?1:0;}lk(l203
==1){l108=l96(l147,l2,l58,l202);lk(l108==0){l92;}}l104(l154,l163,l148
,l140,l83,l80,l32,lu,lp,8,0,l2,l36,l199,ls,l3,l105,l18,2*l97+1,ly,l31
);lg(lb=0;lb<l2;lb++){la ln=l69[lb];l93[ln]=l154[lb];}lg(lb=0;lb<l18;
lb++){l105[lb]=l148[lb];}lg(lb=0;lb<l2;lb++){la ln=l69[lb];l147[ln]=
l140[lb]>=0?1:0;}lk(l203==1){l108=l96(l147,l2,l58,l202);lk(l108==0){
l92;}}}l1(l115);l1(l154);l1(l168);l1(l163);l1(l112);l1(l148);l1(l155);
l1(l140);l1(l93);l1(l83);l1(l67);l1(l80);l1(l84);l1(l105);l1(l69);l1(
l125);}
