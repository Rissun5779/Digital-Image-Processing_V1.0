#include "HLS/math.h"


// void print_num (int x) {
//     for (int i=0; i<32; i++) {
//         std::cout << ((x & 2147483648) >> 31);
//         x = x<<1;
//     }
//     std::cout << "\n";
// }

// The method to generate uniformly distributed random numbers
unsigned int randi (unsigned int *s1, unsigned int *s2, unsigned int *s3) {
     unsigned int b;
     /* Generates numbers of 32-bit long. */
     b = (((*s1 << 13) ^ *s1) >> 19);
     *s1 = (((*s1 & 4294967294) << 12) ^ b);
     b = (((*s2 << 2)  ^ *s2) >> 25);
     *s2 = (((*s2 & 4294967288) << 4)  ^ b);
     b = (((*s3 << 3)  ^ *s3) >> 11);
     *s3 = (((*s3 & 4294967280) << 17) ^ b);
     return (*s1 ^ *s2 ^ *s3);
}


// The leading one detector
unsigned int lod (unsigned int u0_int) {

    unsigned int temp_mask = 1;
    unsigned int lo_pos = 0;

    #pragma unroll
    for (int i=0; i<32; i++) {
        if (u0_int >= (temp_mask << i)) {
            lo_pos ++;
        }
    }

    return lo_pos;
}


// Combines two fixed point random numbers into a floating point number
float fx_to_fp (unsigned int e_int, unsigned int m_int) {

    float fp_rand;

    // std::cout << "e_int: ";
    // print_num (e_int);
    // std::cout << "m_int: ";
    // print_num (m_int);


    unsigned int eu = lod (e_int) + 94; // find the leading one's position, use as the exponent
    unsigned int temp = (eu << 23) ^ (m_int >> 9); // combine the sign bit '0', the exponent, and the fraction

    // std::cout << "eu   : ";
    // print_num (eu << 23);
    // std::cout << "mu   : ";
    // print_num (m_int >> 9);
    // std::cout << "fp   : ";
    // print_num (temp);

    
    fp_rand = *(float*)(&temp);

    return fp_rand;
}


// Box-muller algorithm
float box_muller (float u0, float u1) {

    float e = -2*logf(u0);
    float f = sqrtf(e);
    float g0 = sinf(2*u1*(float)3.141592653589793238462643383279502884197169399375105);  // NOTE: M_PI is in math.h but the current version of HLS does not suggest linking to math.h
    float x0 = f*g0;

    return x0;
}

