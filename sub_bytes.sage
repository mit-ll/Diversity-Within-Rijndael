# *****************************************************************
#  Copyright 2016 MIT Lincoln Laboratory  
#  Project:            CryptoSynth
#  Authors:            Merrielle Spain
#  Description:        This generates SubBytes.
#  THE SOFTWARE IS PROVIDED TO YOU ON AN "AS IS" BASIS                    
#                      
# 
#  Modifications:
#  Date              Name           Modification
#  ----              ----           ------------
#  29 January 2016   MS             Original Version
# *****************************************************************

def gen_random_field():
    """Generates a random field.
    
    Generates a random Galois field of size 2^8 with a random modulus. 
        
    Returns:
        A Galois field (GF) with 2^8 elements.
    """ 
    return GF(2**8, name='a', modulus='random')

def gen_aes_field(): 
    """Generates the AES field.
    
    Generates a Galois field of size 2^8 with the AES modulus, x^8+x^4+x^3+x+1.
        
    Returns:
        A Galois field (GF) with 2^8 elements.
    """
    F.<x> = GF(2)[] # This causes a SyntaxError exception for pydoc
    return GF(2**8, name='a', modulus=x^8+x^4+x^3+x+1)
    
            
def inverse_el(x):
    """Computes the inverse element.

    Calculates the inverse element using Fermat's Little Theorem. We assign 0 as 
    its own multiplicative inverse, as specified by AES.

    Args:
        x: An element of GF(2^8).

    Returns:
        An element of GF(2^8).
    """
    if x.is_unit():
        return x^(x.multiplicative_order()-1)
    else:
        return x   


def gen_random_affine():
    """Generates a random affine transformation.

    Generates an random invertible affine transformation that combines 
    multiplication with a matrix and addition with a vector, both in GF(2). It 
    also calculates the inverse transformation.

    Returns:
        A tuple of 4 matrices representing affine transformations 
            matrix_a*x+vector_b and matrix_a_inverse*x+vector_b_inverse as:   
            matrix_a: An 8x8 matrix over GF(2).
            vector_b: An 8x1 matrix over GF(2).
            matrix_a_inverse: An 8x8 matrix over GF(2).
            vector_b_inverse: An 8x1 matrix over GF(2).    
    """    
    matrix_a = matrix(GF(2), 8, 8)
    vector_b = matrix(GF(2), 8, 1)
    vector_b.randomize()
    while not det(matrix_a):
        matrix_a.randomize()
    matrix_a_inverse = matrix_a.inverse()
    vector_b_inverse = matrix_a_inverse*vector_b
    return (matrix_a, vector_b, matrix_a_inverse, vector_b_inverse)


def gen_aes_affine():
    """Generates AES affine transformation.
    
    Generates AES affine transformation that combines multiplication with a 
    matrix and addition with a vector, both in GF(2). It also calculates the 
    inverse transformation.

    Returns:
        A tuple of 4 matrices representing affine transformations 
            matrix_a*x+vector_b and matrix_a_inverse*x+vector_b_inverse as:   
            matrix_a: An 8x8 matrix over GF(2).
            vector_b: An 8x1 matrix over GF(2).
            matrix_a_inverse: An 8x8 matrix over GF(2).
            vector_b_inverse: An 8x1 matrix over GF(2).    
    """ 
    matrix_a = zero_matrix(GF(2), 8, 8)
    for i in [0, 4, 5, 6, 7]:
        for j in range(8):
            matrix_a[j, mod(i+j, 8)] = 1
    vector_b = zero_matrix(GF(2), 8, 1)
    vector_b[[0, 1, 5, 6]] = 1

    matrix_a_inverse = matrix_a.inverse()
    vector_b_inverse = matrix_a_inverse*vector_b
    return (matrix_a, vector_b, matrix_a_inverse, vector_b_inverse)


def apply_affine(affine, x_vec):
    """Applies affine transformation.
    
    Applies matrix_a*x+vector_b to a vector over GF(2). 
    
    Args:
        affine: A tuple of 4 matrices representing affine transformations 
            matrix_a*x+vector_b and matrix_a_inverse*x+vector_b_inverse as:   
            matrix_a: An 8x8 matrix over GF(2).
            vector_b: An 8x1 matrix over GF(2).
            matrix_a_inverse: An 8x8 matrix over GF(2).
            vector_b_inverse: An 8x1 matrix over GF(2). 
        x_vec: An 8x1 matrix over GF(2).

    Returns:
        An 8x1 matrix over GF(2).
    """
    return affine[0]*x_vec+affine[1]


def apply_affine_inv(affine, x_vec):
    """Applies inverse affine transformation.
    
    Applies matrix_a_inverse*x+vector_b_inverse to a vector over GF(2). 
    
    Args:
        affine: A tuple of 4 matrices representing affine transformations 
            matrix_a*x+vector_b and matrix_a_inverse*x+vector_b_inverse as:   
            matrix_a: An 8x8 matrix over GF(2).
            vector_b: An 8x1 matrix over GF(2).
            matrix_a_inverse: An 8x8 matrix over GF(2).
            vector_b_inverse: An 8x1 matrix over GF(2). 
        x: An 8x1 matrix over GF(2).

    Returns:
        An 8x1 matrix over GF(2).
    """
    return affine[2]*x_vec+affine[3]
 
       
def build_sub_bytes(field, affine):
    """Builds SubBytes from Galois field and affine transformation.
    
    Builds sub_bytes by applying multiplicative inversion in field and 
    affine transformation. When used, sub_bytes[i] replaces the ith element of 
    GF(2^8).
    
    Args:
        field: A Galois field (GF) with 2^8 elements.
        affine: A tuple of 4 matrices representing affine transformations 
            matrix_a*x+vector_b and matrix_a_inverse*x+vector_b_inverse as:   
            matrix_a: An 8x8 matrix over GF(2).
            vector_b: An 8x1 matrix over GF(2).
            matrix_a_inverse: An 8x8 matrix over GF(2).
            vector_b_inverse: An 8x1 matrix over GF(2). 
            
    Returns:
        A list of 256 elements of GF(2^8).
    """
    sub_bytes = []
    for i in range(256):
        x = copy(field.fetch_int(i))
        x = inverse_el(x)
        x_vec = poly2coeff(x)
        x_vec = apply_affine(affine, x_vec)
        x = coeff2poly(field, x_vec)
        sub_bytes.append(x)
    return sub_bytes    

    
def build_sub_bytes_inv(field, affine):
    """Builds inverse SubBytes from Galois field and affine transformation.
    
    Builds sub_bytes_inv by applying multiplicative inversion in field and 
    affine transformation.  When used, sub_bytes_inv[i] replaces the ith element 
    of GF(2^8).  
    
    Args:
        field: A Galois field (GF) with 2^8 elements.
        affine: A tuple of 4 matrices representing affine transformations 
            matrix_a*x+vector_b and matrix_a_inverse*x+vector_b_inverse as:   
            matrix_a: An 8x8 matrix over GF(2).
            vector_b: An 8x1 matrix over GF(2).
            matrix_a_inverse: An 8x8 matrix over GF(2).
            vector_b_inverse: An 8x1 matrix over GF(2). 
            
    Returns:
        A list of 256 elements of GF(2^8).
    """
    sub_bytes_inv = []
    for i in range(256):
        x = copy(field.fetch_int(i))
        x_vec = poly2coeff(x)
        x_vec = apply_affine_inv(affine, x_vec)
        x = coeff2poly(field, x_vec)
        x = inverse_el(x)
        sub_bytes_inv.append(x)
    return sub_bytes_inv


def not_any_fixed_points(sub_bytes):
    """Checks SubBytes for fixed and anti-fixed points.
    
    Checks sub_bytes for outputs that match their input or the two's complement 
    of their input.
    
    Args:
        sub_bytes: A list of 256 elements of GF(2^8).
            
    Returns:
        A bool True if sub_bytes has neither fixed nor anti-fixed points, and
        False otherwise. 
    """
    antirange = map(lambda x: 256+~int(x), range(256))
    sub_bytesint = map(lambda x: Integer(x.integer_representation()), sub_bytes)
    any_fixed = any(map(lambda x, y: x == y, sub_bytesint, range(256)))
    any_anti = any(map(lambda x, y: x == y, sub_bytesint, antirange))
    return not any_fixed and not any_anti

def poly2coeff(poly):
    """Transforms polynomial to vector representation.
      
    Transforms an element of GF(2^8) to a vector over GF(2).
    
    Args:
        poly: An element of GF(2^8).

    Returns:
        An 8x1 matrix over GF(2).    
    """
    x_vec = zero_matrix(GF(2), 8, 1)
    terms = poly._poly_repr().split(' + ')
    terms = map(lambda x: x.split('^'),terms)
    for term in terms:
        if len(term) == 2:
            x_vec[int(term[1])] = 1
        else:
            if term[0] is 'a':
                x_vec[1] = 1
            else:
                x_vec[0] = int(term[0])
    return x_vec
    
    
def coeff2poly(field, x_vec):
    """Transforms vector to polynomial representation.

    Transforms a vector over GF(2) to an element of GF(2^8).
    
    Args:
        field: A Galois field (GF) with 2^8 elements.
        x_vec: An 8x1 matrix over GF(2).
            
    Returns:
        An element of GF(2^8).
    """
    x_int = sum(map(lambda x,y,:int(x[0])*2**y,x_vec,range(8)))
    return field.fetch_int(x_int)