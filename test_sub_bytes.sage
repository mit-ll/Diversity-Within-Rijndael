# *****************************************************************
#  Copyright 2016 MIT Lincoln Laboratory  
#  Project:            CryptoSynth
#  Authors:            Merrielle Spain
#  Description:        This tests SubBytes.
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
    load("sub_bytes.sage")
    load("aes_test_vectors.sage")
    
    
def test_sub_bytes():
    """Runs tests on SubBytes and components.

    Tests whether sub_bytes, sub_bytes_inv, and components work as intended.  It 
    compares the values for the AES sub_bytes with values stored in 
    aes_test_vectors.sage.  Then for both AES and a random variant, it tests 
    that sub_bytes and sub_bytes_inv are inverses, that the affine 
    transformations are inverses, that the multiplicative inverse is correct, 
    and that the transformation to coefficients and back yields the original 
    value. Prints the indices of any test failures.
    """
    print '---Testing AES sub_bytes---'
    field = gen_aes_field()
    affine = gen_aes_affine()
    sub_bytes = build_sub_bytes(field, affine)
    sub_bytes_inv = build_sub_bytes_inv(field, affine)
    report_results(test_aes_sub_bytes(sub_bytes, aes_sub_bytes), 
        'Matching against AES SubBytes')
    report_results(test_aes_sub_bytes_inv(sub_bytes_inv, aes_sub_bytes_inv), 
        'Matching against AES inverse SubBytes')
    report_results(test_random_sub_bytes(sub_bytes, sub_bytes_inv, field), 
        'sub_bytes and sub_bytes_inv are inverses')
    report_results(test_affine(field, affine), 
        'Affine transformations are inverses')
    report_results(test_inverse_el(field), 'Multiplicative inverse')
    report_results(test_coeff(field), 'Transformation to coefficients and back')
    
    print '---Testing random sub_bytes---'
    field = gen_random_field()
    affine = gen_random_affine()
    sub_bytes = build_sub_bytes(field, affine)
    sub_bytes_inv = build_sub_bytes_inv(field, affine)
    report_results(test_random_sub_bytes(sub_bytes, sub_bytes_inv, field), 
        'sub_bytes and sub_bytes_inv are inverses')
    report_results(test_affine(field, affine), 
        'Affine transformations are inverses')
    report_results(test_inverse_el(field), 'Multiplicative inverse')
    report_results(test_coeff(field), 'Transformation to coefficients and back')
    
    
def test_aes_sub_bytes(sub_bytes, aes_sub_bytes):
    """Tests whether variant matches the AES SubBytes.
 
    Verifies that sub_bytes permutation matches the hardcoded integer 
    representation in aes_test_vectors.sage.
    
    Args:
        sub_bytes: A list of 256 elements of GF(2^8). 
        aes_sub_bytes: A list of 256 integers.

    Returns:
        An empty list if the integer representation of sub_bytes matches 
        aes_sub_bytes, and list of mismatched indices otherwise.
    """
    incorrect = []
    for i in range(256):
        if sub_bytes[i].integer_representation()  !=  aes_sub_bytes[i]:
            incorrect.append(i)
    return incorrect
    
    
def test_aes_sub_bytes_inv(sub_bytes_inv, aes_sub_bytes_inv):
    """Tests whether variant inverse matches the AES inverse SubBytes.
 
    Verifies that sub_bytes_inv permutation matches the hardcoded integer 
    representation in aes_test_vectors.sage.
    
    Args:
        sub_bytes_inv: A list of 256 elements of GF(2^8). 
        aes_sub_bytes_inv: A list of 256 integers.

    Returns:
        An empty list if the integer representation of sub_bytes_inv matches 
        aes_sub_bytes_inv, and list of mismatched indices otherwise.
    """
    incorrect = []
    for i in range(256):
        if (sub_bytes_inv[i].integer_representation()  !=  
            aes_sub_bytes_inv[i]):
            incorrect.append(i)
    return incorrect


def test_random_sub_bytes(sub_bytes, sub_bytes_inv, field):
    """Tests whether SubBytes and its nominal inverse are inverses.
    
    Tests whether sub_bytes and sub_bytes_inv are inverses for each element of 
    field.
    
    Args:
        sub_bytes: A list of 256 elements of GF(2^8). 
        sub_bytes_inv: A list of 256 elements of GF(2^8).
        field: A Galois field (GF) with 2^8 elements.

    Returns:
        An empty list if sub_bytes and sub_bytes_inv are inverses, and list of 
        mismatched field indices otherwise.
    """       
    incorrect = []
    for i in range(256):
        x = field.fetch_int(i)
        if x  !=  sub_bytes_inv[(sub_bytes[x.integer_representation()]).
            integer_representation()]:
            incorrect.append(i)
    return incorrect


def test_affine(field, affine):
    """Tests whether the affine transformation and nominal inverse are inverses.
    
    Tests whether matrix_a*x+vector_b and matrix_a_inv*x+vector_b_inv are 
    inverse operations.
    
    Args:
        field: A Galois field (GF) with 2^8 elements.
        affine: A tuple of 4 matrices representing affine transformations 
            matrix_a*x+vector_b and matrix_a_inverse*x+vector_b_inverse as:   
            matrix_a: An 8x8 matrix over GF(2).
            vector_b: An 8x1 matrix over GF(2).
            matrix_a_inverse: An 8x8 matrix over GF(2).
            vector_b_inverse: An 8x1 matrix over GF(2).
    
    Returns:
        An empty list if elements of affine compose inverse operations, and list
        of mismatched field indices otherwise.
    """
    incorrect = []
    for i in range(256):
        x_vec = poly2coeff(field.fetch_int(i))
        if x_vec  !=  apply_affine_inv(affine, apply_affine(affine, x_vec)):
            incorrect.append(i)
    return incorrect
    
    
def test_inverse_el(field):
    """Tests multiplicative inverse generation.
    
    Tests inverse_el on every element of field using the fact that the product 
    of an element and its inverse is 1. 
    
    Args:
        field: A Galois field (GF) with 2^8 elements.
    
    Returns:
        Empty list if inverting elements correctly, and list of mismatched field
        indices otherwise.
    """    
    incorrect = []
    for i in range(1, 256):
        x = field.fetch_int(i)
        if not (x*inverse_el(x)).is_one:
            incorrect.append(i)
    return incorrect
    
    
def test_coeff(field):
    """Tests transformations between polynomial and vector representations.
    
    Tests coeff2poly and poly2coeff for inversion. These functions bridge the 
    gap between inversion in the Galois field and the affine transformation.
    
    Args:
        field: A Galois field (GF) with 2^8 elements.
    
    Returns:
        An empty list if correct, and list of mismatched field indices 
        otherwise.
    """    
    incorrect = []
    for i in range(256):
        x = field.fetch_int(i)
        if x  !=  coeff2poly(field, poly2coeff(x)):
            incorrect.append(i)
    return incorrect