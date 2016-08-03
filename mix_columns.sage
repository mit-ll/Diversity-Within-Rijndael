# *****************************************************************
#  Copyright 2016 MIT Lincoln Laboratory  
#  Project:            CryptoSynth
#  Authors:            Merrielle Spain
#  Description:        This generates MixColumns.
#  THE SOFTWARE IS PROVIDED TO YOU ON AN "AS IS" BASIS                    
#                      
# 
#  Modifications:
#  Date              Name           Modification
#  ----              ----           ------------
#  29 January 2016   MS             Original Version
# *****************************************************************

if __name__ == '__main__':
    load("shift_rows.sage")
    from random import choice

def gen_random_mix_columns(field):
    """Generates a random MixColumns matrix and inverse matrix.
    
    Generates a random circulant matrix over GF(2^8):
    [c_0 c_3 c_2 c_1]
    [c_1 c_0 c_3 c_2]
    [c_2 c_1 c_0 c_3]
    [c_3 c_2 c_1 c_0]    
    We apply the following constraints from Grosek and Zajac to build a matrix 
    with a branch number of 5: 
    1. c_i != 0
    2. c_i != c_{i+2}
    3. c_i*c_{i+1} != c_{i+2}*c_{i+3}
    4. (c_i)^2 != c_{i+1}*c_{i-1}
    5. c_0+c_1+c_2+c_3 != 0
    All constraints must hold for all i, considered mod 4.  We also generate the
    inverse matrix.
    
    O. Grosek and P. Zajac, "Searching for a different AES-class MixColumns 
    operation," in WSEAS International Conference on Applied Computer Science, 
    2006, pp. 307-310.
       
    Args:
        field: A Galois field (GF) with 2^8 elements.
            
    Returns:
        A tuple of 2 4x4 matrices over GF(2^8).
    """
    nonzero = [field.fetch_int(x) for x in range(1,256)]
    c0 = choice(nonzero)
    c1 = choice(nonzero)
    disallowed = [c0, c1**2/c0]
    c2 = choice(list(set(nonzero).difference(set(disallowed))))
    disallowed = list(set([c1, c0*c1/c2, c2*c1/c0 , c0**2/c1, c2**2/c1, 
        sqrt(c0*c2), c0+c1+c2]))
    c3 = choice(list(set(nonzero).difference(set(disallowed))))
    col = [c0, c1, c2, c3]
    assert(all(map(bool,col)))
    for i in range(4):
        assert(col[i] != col[mod(i+2, 4)])
        assert(col[i]*col[mod(i+1, 4)] != col[mod(i+2, 4)]*col[mod(i+3, 4)])
        assert(col[i]**2 != col[mod(i+1, 4)]*col[mod(i-1, 4)])
    assert(sum(col))
    mat = shift_rows_inv(matrix(4*[[c0, c3, c2, c1]]), aes_shift_rows_params())
    return (mat, mat.inverse())       


def gen_aes_mix_columns(field):
    """Generates the AES MixColumns matrix and inverse matrix.
    
    Generates the AES MixColumns circulant matrix over GF(2^8), and its inverse.
    
    Args:
        field: A Galois field (GF) with 2^8 elements.
            
    Returns:
        A tuple of 2 4x4 matrices over GF(2^8).
    """  
    vec = [2, 3, 1, 1]
    row = [field.fetch_int(idx) for idx in vec]
    mat = shift_rows_inv(matrix(4*[row]), aes_shift_rows_params())
    return (mat, mat.inverse())