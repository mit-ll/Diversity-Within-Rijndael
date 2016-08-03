# *****************************************************************
#  Copyright 2016 MIT Lincoln Laboratory  
#  Project:            CryptoSynth
#  Authors:            Merrielle Spain
#  Description:        This tests encryption and decryption for a 128-bit key.
#  THE SOFTWARE IS PROVIDED TO YOU ON AN "AS IS" BASIS                    
#                      
# 
#  Modifications:
#  Date              Name           Modification
#  ----              ----           ------------
#  29 January 2016   MS             Original Version
# *****************************************************************

if __name__ == '__main__':
    load("test_util.sage")
    load("aes_test_vectors.sage")
    load("mix_columns.sage")
    load("sub_bytes.sage")
    load("encrypt.sage")
    
    
def test_encryption():
    """Tests AES encryption and decryption.
    
    Compares encrypt and decrypt under AES settings with AES test vectors from 
    aes_test_vectors.sage.
    """
    field = gen_aes_field()
    affine = gen_aes_affine()
    mix_columns = gen_aes_mix_columns(field)
    shifts = aes_shift_rows_params()

    print '---Testing AES encryption---'  
    print_passed(ct0 == encrypt(field, affine, mix_columns, shifts, pt0, 
        key_for_test), 'Test vector 0')
    print_passed(ct1 == encrypt(field, affine, mix_columns, shifts, pt1, 
        key_for_test), 'Test vector 1')
    print_passed(ct2 == encrypt(field, affine, mix_columns, shifts, pt2, 
        key_for_test), 'Test vector 2')
    print_passed(ct3 == encrypt(field, affine, mix_columns, shifts, pt3, 
        key_for_test), 'Test vector 3')

    
    print '---Testing AES decryption---'  
    print_passed(pt0 == decrypt(field, affine, mix_columns, shifts, ct0, 
        key_for_test), 'Test vector 0')
    print_passed(pt1 == decrypt(field, affine, mix_columns, shifts, ct1, 
        key_for_test), 'Test vector 1')
    print_passed(pt2 == decrypt(field, affine, mix_columns, shifts, ct2, 
        key_for_test), 'Test vector 2')
    print_passed(pt3 == decrypt(field, affine, mix_columns, shifts, ct3, 
        key_for_test), 'Test vector 3')