# *****************************************************************
#  Copyright 2016 MIT Lincoln Laboratory  
#  Project:            CryptoSynth
#  Authors:            Merrielle Spain
#  Description:        This tests MixColumns.
#  THE SOFTWARE IS PROVIDED TO YOU ON AN "AS IS" BASIS                    
#                      
# 
#  Modifications:
#  Date              Name           Modification
#  ----              ----           ------------
#  29 January 2016   MS             Original Version
# *****************************************************************

if __name__ == '__main__':
    from random import randrange
    load("test_util.sage")
    load("mix_columns.sage")
    load("sub_bytes.sage")
        
        
def test_mix_columns():
    """Tests functions that builds MixColumns matrices.
    
    Tests invertibility and inversion of mix_columns matrices on AES and random 
    matrices.
    """
    print '---Testing MixColumns---'
    field = gen_aes_field()
    print_passed(test_mix_columns_determinant(gen_aes_mix_columns(field)), 
        'Invertible on AES matrix')
    print_passed(test_mix_columns_inversion(gen_aes_mix_columns(field)), 
        'Inversion on AES matrix')
    field = gen_random_field()
    print_passed(test_mix_columns_determinant(gen_random_mix_columns(field)), 
        'Invertible on random matrix')
    print_passed(test_mix_columns_inversion(gen_random_mix_columns(field)), 
        'Inversion on random matrix')
    

def test_mix_columns_inversion(mat_tuple):
    """Tests whether MixColumns matrices are inverses.
    
    Tests whether pair of matrices in mat_tuple are inverses by checking whether 
    their product is the identity matrix.
    
    Args:
        mat_tuple: A tuple of 2 4x4 matrices over GF(2^8).

    Returns:
        A bool True if matrices are inverses, and False otherwise.
    """
    return mat_tuple[0]*mat_tuple[1] == matrix.identity(4)


def test_mix_columns_determinant(mat_tuple):
    """Tests whether determinants are non-zero.
    
    Tests whether determinants of both matrices in mat_tuple are non-zero.

    Args:
        mat_tuple: A tuple of 2 4x4 matrices over GF(2^8).

    Returns:
        A bool True if both matrix determinants are non-zero, and False 
        otherwise.
    """
    return bool(det(mat_tuple[0])) and bool(det(mat_tuple[1]))