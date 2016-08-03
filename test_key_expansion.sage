# *****************************************************************
#  Copyright 2016 MIT Lincoln Laboratory  
#  Project:            CryptoSynth
#  Authors:            Merrielle Spain
#  Description:        This tests the key schedule.
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
    load("key.sage")
    load("aes_test_vectors.sage")
    load("sub_bytes.sage")


def test_key_expansion():
    """Test AES-128 key schedule against AES-128 test vectors.

    Tests key_schedule against several test vectors. Note that this only makes 
    sense for the AES settings, because the key expansion uses sub_bytes.
    """
    field = gen_aes_field()
    sub_bytes = build_sub_bytes(field, gen_aes_affine())
    
    print '---Testing key expansion---'
    key_expansion = key_schedule(sub_bytes, zero_matrix(field, 4, 4))
    report_results(test_against_vector(key_expansion00, key_expansion), 
        'Key expansion of 0x00')
    key_expansion = key_schedule(sub_bytes, field.fetch_int(0xff)*
        ones_matrix(field, 4, 4))
    report_results(test_against_vector(key_expansionff, key_expansion), 
        'Key expansion of 0xff')
    cipher_key = list2mat(field, key_expansion0f[:16])
    key_expansion = key_schedule(sub_bytes, cipher_key)
    report_results(test_against_vector(key_expansion0f, key_expansion), 
        'Key expansion of 0x00,...0xff')
    cipher_key = list2mat(field, key_expansion69[:16])
    key_expansion = key_schedule(sub_bytes, cipher_key)
    report_results(test_against_vector(key_expansion69, key_expansion), 
        'Key expansion of 0x69, 0x20...')


def test_against_vector(vector, key_expansion):
    """Compares AES-128 key expansion with AES-128 test vector.

    Compares key expansion matrix over GF(2^8) with test data in 
    aes_test_vectors.sage, and returns a list of any mismatches.

    Args:
        vector: A list of 176 integers representing the 11 round keys.
        key_expansion: A 4x44 matrix over GF(2^8).

    Returns:
        An empty list if key_expansion matches vector, and a list of mismatched 
        indices otherwise.
    """
    incorrect = []
    for i in range(4*44):
        if (key_expansion[mod(i, 4), floor(i/4)].integer_representation() != 
            vector[i]):
            incorrect.append(i)
        return incorrect