# *****************************************************************
#  Copyright 2016 MIT Lincoln Laboratory  
#  Project:            CryptoSynth
#  Authors:            Merrielle Spain
#  Description:        This implements the AES-128 key schedule and AddRoundKey.
#  THE SOFTWARE IS PROVIDED TO YOU ON AN "AS IS" BASIS                    
#                      
# 
#  Modifications:
#  Date              Name           Modification
#  ----              ----           ------------
#  29 January 2016   MS             Original Version
# *****************************************************************

if __name__ == '__main__':
    load("sub_bytes.sage")


def key_schedule(sub_bytes, cipher_key):
    """Expands an AES-128 key into an 11-round expanded key.
    
    Expands cipher_key into a matrix, where each submatrix, of 11, represents a 
    round key.
    
    Args:
        sub_bytes: A list of 256 elements of GF(2^8) providing a permutation.
        cipher_key: A 4x4 matrix over GF(2^8).
            
    Returns:
        A 4x44 matrix over GF(2^8).
    """
    Nb = 4
    Nk = 4
    Nr = 10
    W = zero_matrix(cipher_key[0, 0].parent(), 4, Nb*(Nr+1))
    for j in range(Nk):
        for i in range(4):
            W[i, j] = cipher_key[i, j]
    for j in range(Nk, Nb*(Nr+1)):
        if not mod(j, Nk):
            W[0, j] = (W[0, j-Nk]+sub_bytes[W[1, j-1].integer_representation()]+
                cipher_key[0, 0].parent().gen()^(j/Nk-1))
            for i in range(1, 4):
                W[i, j] = W[i, j-Nk]+sub_bytes[W[mod(i+1, 4), j-1].
                    integer_representation()]
        else:
             for i in range(4):
                 W[i, j] = W[i, j-Nk]+W[i, j-1]
    return W
    
    
def list2mat(field, key_list):
    """Transforms a list of key bytes into a key matrix.
    
    Transforms a list of integers into a matrix over GF(2^8).
    
    Args:
        field: A Galois field (GF) with 2^8 elements.
        key_list: A list of 16 integers.
            
    Returns:
        A 4x4 matrix over GF(2^8).
    """
    key = zero_matrix(field, 4, 4)
    for i in range(4*4):
        key[mod(i, 4), floor(i/4)] = field.fetch_int(key_list[i])
    return key


def mat2list(key):
    """Transforms matrix representation of key into list.
    
    Transforms a matrix over GF(2^8) into a list of integers.
    
    Args:
        key: A 4x4 or 4x44 matrix over GF(2^8).
            
    Returns:
        A list of 16 or 176 integers.
    """
    key_list = []
    for i in range(4*key.ncols()):
        key_list.append(key[mod(i, 4), floor(i/4)].
            integer_representation())
    return key_list
    
                    
def add_round_key(mat, round_key):
    """Exclusive-ors state and round key.
    
    Exclusive-ors state matrix and round key matrix to update state matrix.
    
    Args:
        mat: A 4x4 matrix over GF(2^8).
        round_key: A 4x4 matrix over GF(2^8).
            
    Returns:
        A 4x4 matrix over GF(2^8) representing state.
    """
    return mat+round_key