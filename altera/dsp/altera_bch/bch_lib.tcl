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


# -----------------------------------------------------------------
# Multiplication of two polynomials a and b, with degree m
# -----------------------------------------------------------------
proc GFmult {a b m irrpol op} {
    set expand 0
    for {set ii 0} {$ii<$m+1} {incr ii} {
        if {($b & (1<<$ii))!=0} {set expand [expr {$expand ^($a<<$ii)}]}
    }

    # Argument op determines whether the resultant polynomial should be reduced by the primitive polynomial
    if {$op == 1} {
        for {set ii 0} {$ii<$m+1} {incr ii} {
            if { [expr {($expand>> (2*$m-$ii)) & 1}]!=0} {set expand [expr {$expand ^($irrpol<<($m-$ii))}]}
        }
    } elseif {$op != 0} {
            send_message error "The argument op of GFmult must be either 0 or 1"
    }

    return $expand
}




# -----------------------------------------------------------------
# Generate the roots in GF(2**m) with irreducible polynomial irrpol
# -----------------------------------------------------------------
proc GF_field_generation {irrpol m} {

   set GF_field [list 0 1]
   for {set ind 2} {$ind < 2**$m} {incr ind} {
      set pre_poly [lindex $GF_field $ind-1]
      set temp_poly [GFmult $pre_poly 2 $m $irrpol 1]
      lappend GF_field $temp_poly
      # send_message info "ii=[expr $ind] poly=[lindex $GF_field $ind]"
   }

   return $GF_field
}


# --------------------------------------------------------------
# compute the possible t list and a list of corresponding generator poly degrees
# --------------------------------------------------------------
proc get_genpoly_degree_list {degree_listVar  t_listVar m} {
    upvar $degree_listVar            degree_list
    upvar $t_listVar                 t_list

    set t_list  [list ]
    array  set degree_list {}
    set prev_degree 0
    set prev_t 0
    
    set max_n [expr 2**$m-1]
    set degree 0
    for {set ii 0} {$ii < $max_n} {incr ii} {set isconj($ii) 0} 
    
    for {set ii 0} {$ii < [expr 2**($m-1)-2]} {incr ii} {
    
        set rr [expr 1+$ii]
        set kk 0

        while {$isconj([expr ($rr*(2**$kk))%$max_n])==0} {           
            set isconj([expr ($rr*(2**$kk))%$max_n]) 1
            incr kk           
            if {$rr== [expr ($rr*(2**$kk))%$max_n]} {              
                incr degree $kk;
            }
        }
        if {$ii%2} {
        #send_message warning "check is [expr 1+$ii] so t is [ expr ($ii+1)/2],  degree is $degree"
            
                if {$prev_degree != $degree && $prev_degree!=0} {
                    lappend t_list $prev_t
                    set degree_list($prev_t) $prev_degree 
                    #send_message warning "add    BCH([expr 2**$m-1],[expr 2**$m-1-$prev_degree],$prev_t)"
                }
                if {[expr $ii+1]==[expr 2**($m-1)-2]} {
                    lappend t_list [expr ($ii+1)/2]
                    set degree_list([expr ($ii+1)/2]) $degree 
                    #send_message warning "add    BCH([expr 2**$m-1],[expr 2**$m-1-$degree],[expr ($ii+1)/2])"
                }
                set prev_degree  $degree
                set prev_t  [expr ($ii+1)/2]
        }
    }
}


# -----------------------------------------------------------------
# Generate the BCH generator polynomial by adding in roots
# -----------------------------------------------------------------
proc generate_BCH_poly {GF_field t m} {
   send_message INFO "Generating BCH generator polynomial"   

   # Initialize the generator polynomial to (x+a)
   set generator_poly [list 2 1]
   # Initialize the "already added" status array, with first element set to 1 as a has been added by default
   set add_stat [lrepeat [expr 2**$m-2] 0]
   lset add_stat 0 1
   # for each root that is to be added:
   for {set ind 1} {$ind < 2*$t+1} {incr ind} {

      # for each conjugate root of the root in question:
      for {set j 0} {$j<$m} {incr j} {
         # p is the power of this conjugate root
         set p [expr ($ind*(2**$j)) % (2**$m-1)]
         #-------------send_message info "ind=$ind j=$j and p=$p"
         if {[lindex $add_stat $p-1] == 0} {
            set temp_generator $generator_poly

            # Compute coefficients
            for {set i 1} {$i < [llength $generator_poly]} {incr i} {
               set b_i [lindex $generator_poly $i]
               set b_i_1 [lindex $generator_poly $i-1]
               #-------------send_message info b_i=$b_i
               #-------------send_message info b_i_1=$b_i_1
               # First, b(i)*a^p
               if {$b_i != 0} {
                  set temp_mul [expr ($b_i+$p-1)%([llength $GF_field]-1)+1] 
               } else {
                  set temp_mul 0
               }  
               # Then, temp_mul+b(i-1)
               set temp_add [expr [lindex $GF_field $temp_mul]^[lindex $GF_field $b_i_1]]
               set temp_val [lsearch $GF_field $temp_add]
               lset temp_generator $i $temp_val
               #-------------send_message info temp_mul=$temp_mul
               #-------------send_message info temp_add=$temp_add
               #-------------send_message info temp_val=$temp_val
            }
      
            # Set the coefficient of X^0 to b(0)*a^i
            set temp_mul [expr ([lindex $generator_poly 0]+$p-1)%([llength $GF_field]-1)+1]
            lset temp_generator 0 $temp_mul
            # Append the coefficient b(n) to the highest order
            set temp_hi [expr [lindex $generator_poly [llength $generator_poly]-1]]
            #-------------send_message info temp_hi=$temp_hi
            lappend temp_generator $temp_hi

            set generator_poly $temp_generator


         # record that this root is added to the polynomial
         lset add_stat $p-1 1
         #-------------send_message info "added root with power=$p, conjugate to root with power=$ind"
         #-------------send_message info generator_poly=$generator_poly
         #-------------send_message info "current add_stat=$add_stat"
         #-------------send_message info -------------------------------
         }
   
      }

   }

   set generator_poly [lreverse $generator_poly]
   return $generator_poly
}



# -----------------------------------------------------------------
# Generate the parity_array, in_array, and out_array, for the parallel IIR
# -----------------------------------------------------------------
proc generate_para_IIR {DATA_WIDTH poly_array} {
   send_message INFO "Generating support files for BCH encoder"

   set parity_bits [expr [llength $poly_array]-1]
   #-------------------send_message info poly_array=$poly_array
   # Initialize the three matrices
   set parity_array [lrepeat $DATA_WIDTH [lrepeat $parity_bits 0]]
   set in_array [lrepeat $DATA_WIDTH [lrepeat $DATA_WIDTH 0]]
   set out_array [lrepeat $DATA_WIDTH [lrepeat $DATA_WIDTH 0]]
   for {set k 0} {$k<$DATA_WIDTH} {incr k} {
      for {set i 0} {$i<$parity_bits} {incr i} {
         if {[lindex $poly_array $i+1]} {
            if {$i-$k>=0} {
               # parity_array(k,i-k+1) = mod(parity_array(k,i-k+1)+1,2)
               #-------------------send_message info "k=$k i=$i ele=[expr ([lindex $parity_array $k [expr $i-$k]]+1)%2]"
               lset parity_array $k [expr $i-$k] [expr ([lindex $parity_array $k [expr $i-$k]]+1)%2]
               #-------------------send_message info parity_array=$parity_array
            } else {
               # parity_array(k,:) = mod(parity_array(k,:)+parity_array(k-i,:),2)
               for {set jj 0} {$jj<$parity_bits} {incr jj} {
                  set temp [expr ([lindex $parity_array $k $jj]+[lindex $parity_array [expr $k-$i-1] $jj])%2]
                  lset parity_array $k $jj $temp
               }
               # in_array(k,:) = mod(in_array(k,:)+in_array(k-i,:),2)
               for {set jj 0} {$jj<$DATA_WIDTH} {incr jj} {
                  set temp [expr ([lindex $in_array $k $jj]+[lindex $in_array [expr $k-$i-1] $jj])%2]
                  lset in_array $k $jj $temp
               }
               # in_array(k,k-i) = mod(in_array(k,k-i)+1,2)
               set temp [expr ([lindex $in_array $k [expr $k-$i-1]]+1)%2]
               lset in_array $k [expr $k-$i-1] $temp
               # out_array(k,k-i) = mod(out_array(k,k-i)+1,2)
               set temp [expr ([lindex $out_array $k [expr $k-$i-1]]+1)%2]
               lset out_array $k [expr $k-$i-1] $temp

            }
         }
         #-------------------send_message info "k=$k i=$i" 
         #-------------------send_message info $parity_array
         
      }

   }

   for {set k 0} {$k<$DATA_WIDTH} {incr k} {
      lset parity_array $k [lreverse [lindex $parity_array $k]]
      lset in_array $k [lreverse [lindex $in_array $k]]
      lset out_array $k [lreverse [lindex $out_array $k]]
   }


   

   # Return the output matrices as a list of arrays
   set para_IIR [list $parity_array $in_array $out_array]
   return $para_IIR
}


# -----------------------------------------------------------------
# BCH encoding procedure. msg_word should be [MSB -- LSB]; output is [MSB -- LSB]
# -----------------------------------------------------------------
proc bch_encoder_proc {msg_word PARITY_BITS N_BITS K_BITS poly_array} {

   set y_out [list ]
   set reg [list ]
   for {set i 0} {$i<[expr $PARITY_BITS]} {incr i} {
     lappend reg 0
   }

   for {set ind 0} {$ind<$N_BITS} {incr ind} {
     # y_out
     if {$ind<$K_BITS} {
       set u [lindex $msg_word $ind]
       lappend y_out $u
     } else {
       set u 0
       lappend y_out [lindex $reg 0]
     }
     set w [expr [lindex $reg 0] ^ $u]
     #send_message INFO "u=$u  w=$w  y_out=$y_out"

     # reg update
     for {set i 1} {$i<$PARITY_BITS} {incr i} {
       set reg_ind [expr $i-1]
       if {[lindex $poly_array $i] & $ind<$K_BITS} {
         lset reg $reg_ind [expr [lindex $reg $reg_ind+1]^$w]
       } else {
         lset reg $reg_ind [expr [lindex $reg $reg_ind+1]]
       }
     }
     lset reg [expr $PARITY_BITS-1] $w
     #send_message INFO "ind=$ind  reg=$reg"
     
     #send_message INFO "-------------------------"
   }

   return $y_out
}





