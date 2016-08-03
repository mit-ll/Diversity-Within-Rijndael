# *****************************************************************
#  Copyright 2016 MIT Lincoln Laboratory  
#  Project:            CryptoSynth
#  Authors:            Merrielle Spain
#  Description:        This encrypts and decrypts with a 128-bit key.
#  THE SOFTWARE IS PROVIDED TO YOU ON AN "AS IS" BASIS                    
# 
#
#  Modifications:
#  Date              Name           Modification
#  ----              ----           ------------
#  29 January 2016   MS             Original Version
# *****************************************************************

if __name__ == '__main__':
    load("key.sage")
    load("sub_bytes.sage")
    load("shift_rows.sage")


def encrypt(field, affine, mix_columns, shifts, pt, cipher_key):
    """Encrypts one block of plaintext under specified Rijndael variant.

    Encrypts pt under cipher_key using SubBytes as specified by multiplicative 
    inversion in field and affine transformation, MixColumns as specified by 
    mix_columns, and ShiftRows as specified by shifts. Returns ciphertext.

    Args:
        field: A Galois field (GF) with 2^8 elements.
        affine: A tuple of 4 matrices representing affine transformations 
            matrix_a*x+vector_b and matrix_a_inverse*x+vector_b_inverse as:   
            matrix_a: An 8x8 matrix over GF(2).
            vector_b: An 8x1 matrix over GF(2).
            matrix_a_inverse: An 8x8 matrix over GF(2).
            vector_b_inverse: An 8x1 matrix over GF(2).
        mix_columns: A tuple of 2 4x4 matrices over GF(2^8).
        shifts: A tuple of 2 lists:
            A list of 4 lists of 4 integers describing horizontal shift.
            A list of 4 lists of 4 integers describing vertical shift.
        pt: A list of 16 integers representing one plaintext block.
        cipher_key: A list of 16 integers representing the cipher key.
            
    Returns:
        A list of 16 integers representing one ciphertext block.
    """
    sb = build_sub_bytes(field, affine)
    cipher_key = list2mat(field, cipher_key)
    key_expansion = key_schedule(sb, cipher_key)
    ct = list2mat(field, copy(pt))

    round_number = 0
    ct = add_round_key(ct, key_expansion[:, range(4*round_number, 4*(
        round_number+1))])
        
    for round_number in range(1, 10):
        ct = ct.apply_map(lambda x:sb[x.integer_representation()])
        ct = shift_rows(ct, shifts)
        ct = mix_columns[0]*ct
        ct = add_round_key(ct, key_expansion[:, range(4*round_number, 4*(
            round_number+1))])
            
    round_number += 1
    ct = ct.apply_map(lambda x:sb[x.integer_representation()])
    ct = shift_rows(ct, shifts)
    ct = add_round_key(ct, key_expansion[:, range(4*round_number, 4*(
        round_number+1))])
    
    ct = mat2list(ct)
    return ct


def decrypt(field, affine, mix_columns, shifts, ct, cipher_key):
    """Decrypts one block of ciphertext under specified Rijndael variant.

    Decrypts ct under cipher_key using SubBytes as specified by multiplicative 
    inversion in field and affine transformation, MixColumns as specified by 
    mix_columns, and ShiftRows as specified by shifts. Returns plaintext.

    Args:
        field: A Galois field (GF) with 2^8 elements.
        affine: A tuple of 4 matrices representing affine transformations 
            matrix_a*x+vector_b and matrix_a_inverse*x+vector_b_inverse as:   
            matrix_a: An 8x8 matrix over GF(2).
            vector_b: An 8x1 matrix over GF(2).
            matrix_a_inverse: An 8x8 matrix over GF(2).
            vector_b_inverse: An 8x1 matrix over GF(2).
        mix_columns: A tuple of 2 4x4 matrices over GF(2^8).
        shifts: A tuple of 2 lists:
            A list of 4 lists of 4 integers describing horizontal shift.
            A list of 4 lists of 4 integers describing vertical shift.
        ct: A list of 16 integers representing one ciphertext block.
        cipher_key: A list of 16 integers representing the cipher key.
            
    Returns:
        A list of 16 integers representing one plaintext block.
    """
    sb = build_sub_bytes(field, affine)
    sb_inv = build_sub_bytes_inv(field, affine)
    cipher_key = list2mat(field, cipher_key)
    key_expansion = key_schedule(sb, cipher_key)
    pt = list2mat(field, copy(ct))

    round_number = 10
    pt = add_round_key(pt, key_expansion[:, range(4*round_number, 4*(
        round_number+1))])
    
    for round_number in range(1, 10)[::-1]:
        pt = pt.apply_map(lambda x:sb_inv[x.integer_representation()])
        pt = shift_rows_inv(pt, shifts)
        pt = mix_columns[1]*pt
        pt = add_round_key(pt, mix_columns[1]*key_expansion[:, range(4*
            round_number, 4*(round_number+1))])

    round_number -= 1
    pt = pt.apply_map(lambda x:sb_inv[x.integer_representation()])
    pt = shift_rows_inv(pt, shifts)
    pt = add_round_key(pt, key_expansion[:, range(4*round_number, 4*(
        round_number+1))])

    pt = mat2list(pt)
    return pt