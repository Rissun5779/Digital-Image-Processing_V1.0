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
// File : pSW_sisoDecoder_fxp.cpp generated at Thu Feb 05 09:13:32 2015
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
la*l10,la l98,la l58,la l149);lv::lv(lf<lw> *l224,lf<lw> *l216,lf<lj>
 *l243,lf<lj> *l237,la*l12,la*l9,la*l13,la*l11,lf<lw>&l46,lf<lw>&l47,
la lu,la lp,la lt,la l29,la ls,la l3,lf<lj>&l44,la l23,la*ly,la l31){
l8->l12=l12;l8->l9=l9;l8->l13=l13;l8->l11=l11;l8->lp=lp;l8->l48=lt;l8
->l29=l29;l8->ls=ls;l8->l3=l3;l8->l23=l23;l53=lu-1;ll=1<<l53;l121=1<<
lp;l79.l5(ll);l71.l5(ll);l77.l5(ll);l75.l5(ll);l41.l5(ll);l40.l5(ll);
lg(la lc=0;lc<ll;lc++){l71[l9[lc]]=lc;l75[l11[lc]]=lc;l79[l9[lc]]=l12
[lc];l77[l11[lc]]=l13[lc];}l52=l48/ls;l51=l52%l3;lk(l51==0){l20=l52/
l3;l51=l3;}lx{l20=l52/l3+1;}l8->l76=l224;l8->l117=l243;l8->l172=l216;
l8->l91=l237;l8->l15=l44;l8->l37=l46;l8->l27=l47;l8->l70=ly[0]-ly[1];
l8->l156=ly[1];l8->l61=ly[2]-ly[3];l8->l86=ly[3];l8->l153=l70+l156;l8
->l85=l61+l86;l180=l61-l70;l35=-(1<<(l70-1));l78[l85-1]=0;lg(la lb=0;
lb<l153-1;lb++){l78[lb]=1;}l192 l160(l61+l86,l61,l184,l204);l55 l229(
l160);l21.l5(ls);l22.l5(ls);l50.l5(ls);l26.l5(ls);l74.l5(ls);l72.l5(
ls);l73.l5(ls);l68.l5(ls);lg(la lb=0;lb<ls;lb++){l21[lb].l5(l121,0);
l22[lb].l5((l3+1) *ll,0);l50[lb].l5(ll,0);l26[lb].l5(ll,0);l74[lb].l5
(lp,l35);l72[lb].l5(lp,l35);}}lv::~lv(){lg(la lb=0;lb<ls;lb++){l21[lb
].l6();l22[lb].l6();l50[lb].l6();l26[lb].l6();l74[lb].l6();l72[lb].l6
();}l79.l6();l71.l6();l77.l6();l75.l6();l41.l6();l40.l6();l21.l6();
l22.l6();l50.l6();l26.l6();l74.l6();l72.l6();l73.l6();l68.l6();}lj lv
::l43(lj l17,lj l19){lk(l29==3||l29==2){lj l62=l19>l17?(l19-l17):(l17
-l19);lk(l29==3){lk(l62==0){l17+=0.75;l19+=0.75;}lx lk(l62<=0.75){l17
+=0.5;l19+=0.5;}lx lk(l62<=2.0){l17+=0.25;l19+=0.25;}}lx{lk(l62<1.5){
l17+=0.5;l19+=0.5;}}}lj l200;lj l62;lk(l17.l90()||l19.l90()){l90=l210
;}l62=l19-l17;l200=l62[l85-1]==1?l17:l19;l16(l200);}le lv::l150(la lm
,la ld,la lr){lj l17,l19;l30 l249=l166;lg(la lc=0;lc<ll;lc++){l17=l22
[ld][(lr+1) *ll+l9[lc]]+l21[ld][l12[lc]];l19=l22[ld][(lr+1) *ll+l11[
lc]]+l21[ld][l13[lc]];l22[ld][lr*ll+lc]=l43(l17,l19);}}le lv::l137(la
ld){la lc;lg(lc=0;lc<ll;lc++){l26[ld][lc]=l50[ld][lc];}}le lv::l142(
la ld,la lr){}le lv::l95(la lm,la ld){lj l139=0;lk(lm<l48)l139=l37[lm
];l21[ld][0]=0;l21[ld][1]=l27[lp*lm+1];l21[ld][2]=l27[lp*lm]+l139;l21
[ld][3]=l27[lp*lm]+l27[lp*lm+1]+l139;}le lv::l143(la lm,la ld){lj l17
,l19;lg(la lc=0;lc<ll;lc++){l17=l26[ld][l71[lc]]+l21[ld][l79[lc]];l19
=l26[ld][l75[lc]]+l21[ld][l77[lc]];l50[ld][lc]=l43(l17,l19);}}le lv::
l118(la lm,la ld,la lr){la lc;la l208,l209;lj l139=0;lj l17,l19;lg(lc
=0;lc<ll;lc++){l208=l12[lc];l209=l13[lc];l40[lc]=l26[ld][lc]+l21[ld][
l208]+l22[ld][(lr+1) *ll+l9[lc]];l41[lc]=l26[ld][lc]+l21[ld][l209]+
l22[ld][(lr+1) *ll+l11[lc]];}la l177=ll/2;l217(l177>1){lg(la lb=0;lb<
l177;lb++){l40[lb]=l43(l40[2*lb],l40[2*lb+1]);l41[lb]=l43(l41[2*lb],
l41[2*lb+1]);}l177/=2;}l68[ld]=l43(l40[0],l40[1]);l73[ld]=l43(l41[0],
l41[1]);}le lv::l133(la lm,la ld){lj l64;lk(lm<l48){( *l91)[lm]=l73[
ld]-l68[ld];l64=( *l91)[lm]-l37[lm];lk(l29==5){l64=(l64>>1)+(l64>>2);
}lk(l64>l78){( *l76)[lm]=l78;}lx lk(l64<l35){( *l76)[lm]=l35;}lx{( *
l76)[lm]=l64;}}}le lv::l107(la lm,la ld,la lr){l95(lm,ld);l150(lm,ld,
lr);l142(ld,lr);}le lv::l123(){lg(la lc=0;lc<ll;lc++){l22[0][l53*ll+
lc]=lc==0?(lj)0:l35;}lg(la lm=l48+l53-1;lm>=l48;lm--){la lr=lm-l48;
l107(lm,0,lr);}la l63=ls*ll;la l7=l63+(ls*l20-1) *ll;lg(la lc=0;lc<ll
;lc++){l15[l7+lc]=l22[0][lc];}}le lv::l151(la lq){la ld,l7,lc;la l63=
ls*ll;lg(ld=0;ld<ls;ld++){lk(lq==l20-1&&ld<ls-1){l7=(ld+1) *ll;lg(lc=
0;lc<ll;lc++){l15[l7+lc]=l26[ld][lc];}}lk(ld>0||lq>0){l7=l63+(ld*l20+
lq-1) *ll;lg(lc=0;lc<ll;lc++){l15[l7+lc]=l22[ld][lc];}}}}le lv::l130(
la lq){la lr,lm,ld;la l42=l3;lk(lq==l20-1){l42=l51;}lg(ld=0;ld<ls;ld
++){lg(lr=l42-1;lr>=0;lr--){lm=ld*l52+lq*l3+lr;l107(lm,ld,lr);}}}le lv
::l114(la lq){la lr,lm,ld;la l42=l3;lk(lq==l20-1){l42=l51;}lg(ld=0;ld
<ls;ld++){lg(lr=0;lr<l42;lr++){lm=ld*l52+lq*l3+lr;l95(lm,ld);l143(lm,
ld);l118(lm,ld,lr);l137(ld);l133(lm,ld);}}}le lv::l134(){lg(la ld=0;
ld<ls;ld++){la l7=ld*ll;lg(la lc=0;lc<ll;lc++){lk(l7==0){l15[l7+lc]=
lc==0?(lj)0:l35;}lx{l15[l7+lc]=0;}}}}le lv::l141(){lg(la ld=0;ld<ls;
ld++){la l7=ld*ll;lg(la lc=0;lc<ll;lc++){l26[ld][lc]=l15[l7+lc];}}}le
lv::l136(){la l63=ls*ll;la l7;lg(la ld=0;ld<ls;ld++){lg(la lq=0;lq<
l20;lq++){l7=l63+(lq+ld*l20) *ll;lg(la lc=0;lc<ll;lc++){lk(ld==ls-1&&
lq==l20-1){l15[l7+lc]=(lc==0?(lj)0:l35);}lx{l15[l7+lc]=0;}}}}}le lv::
l116(la lq){la l63=ls*ll;la l7;la lm,l42;lg(la ld=0;ld<ls;ld++){l7=
l63+(lq+ld*l20) *ll;lk(lq==l20-1){l42=l51;}lx{l42=l3;}lg(la lc=0;lc<
ll;lc++){l22[ld][l42*ll+lc]=l15[l7+lc];}}}le lv::l162(la lq){}le lv::
l131(la lq){lk(lq==0){l141();}l116(lq);l130(lq);l114(lq);l151(lq);}le
lv::l128(){lk(l23<=1){l134();l136();l123();}lg(la lb=0;lb<l20;lb++){
l131(lb);}lg(la l170=0;l170<(1+l20) *ls;l170++){la l7=l170*ll;lg(la lc
=0;lc<ll;lc++){( *l117)[l7+lc]=l15[l7+lc];}}}
