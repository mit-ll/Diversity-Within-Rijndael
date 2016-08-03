# *****************************************************************
#  Copyright 2016 MIT Lincoln Laboratory  
#  Project:            CryptoSynth
#  Authors:            Merrielle Spain
#  Description:        This generates and applies ShiftRows.
#  THE SOFTWARE IS PROVIDED TO YOU ON AN "AS IS" BASIS                    
#                      
# 
#  Modifications:
#  Date              Name           Modification
#  ----              ----           ------------
#  29 January 2016   MS             Original Version
# *****************************************************************

if __name__ == '__main__':
    from numpy.random import permutation


def shift_rows(mat, shifts):
    """Applies ShiftRows variant where elements can change column and row.
    
    Applies ShiftRows variant conceptualized in two steps: First, it distributes
    the elements of a column across output columns according to shifts[0]. 
    Second, it distributes the output column contents across rows according to 
    shifts[1].
    
    Args:
        mat: A 4x4 matrix over GF(2^8) representing state.
        shifts: A tuple of 2 lists:
            A list of 4 lists of 4 integers describing horizontal shift.
            A list of 4 lists of 4 integers describing vertical shift.
            
    Returns:
        A 4x4 matrix over GF(2^8) representing state.
    """
    n = mat.ncols()
    assert(mat.ncols() == mat.nrows()), 'Matrix must be square'
    assert(mat.ncols() == 4), 'Matrix must be 4x4 for AES 128'
    assert(all(map(lambda x: set(x) == set(range(n)), shifts[0]))), 'Need permutation'
    assert(all(map(lambda x: set(x) == set(range(n)), shifts[1]))), 'Need permutation'
    assert(len(shifts[0]) == n), 'Need 4 dispersions to columns'
    assert(len(shifts[1]) == n), 'Need 4 dispersions to rows'
    mat_shifted = matrix.zero(mat[0, 0].parent(), n, n)
    for a in range(n):
        for b in range(n):
            c = shifts[0][a][b]
            r = shifts[1][c][a]
            mat_shifted[r, c] = mat[a, b]
    return mat_shifted
    
    
def shift_rows_inv(mat, shifts):
    """Applies ShiftRows variant inverse.
    
    Applies the inverse of shift_rows.  Given the row and column of an element, 
    it finds and places the element in its original position given shift_rows 
    with parameters shifts.
    
    Args:
        mat: A 4x4 matrix over GF(2^8) representing state.
        shifts: A tuple of 2 lists:
            A list of 4 lists of 4 integers describing horizontal shift.
            A list of 4 lists of 4 integers describing vertical shift.
            
    Returns:
        A 4x4 matrix over GF(2^8) representing state.
    """
    n = mat.ncols()
    assert(mat.ncols() == mat.nrows()), 'Matrix must be square'
    assert(mat.ncols() == 4), 'Matrix must be 4x4 for AES 128'
    assert(all(map(lambda x: set(x) == set(range(n)), shifts[0]))), 'Need permutation'
    assert(all(map(lambda x: set(x) == set(range(n)), shifts[1]))), 'Need permutation'
    assert(len(shifts[0]) == n), 'Need 4 dispersions to columns'
    assert(len(shifts[1]) == n), 'Need 4 dispersions to rows'
    mat_shifted = matrix.zero(mat[0, 0].parent(), n, n)
    for a in range(4):
        for b in range(4):
            c = shifts[0][a][b]
            r = shifts[1][c][a]
            mat_shifted[a, b] = mat[r, c]
    return mat_shifted
    
    
def aes_shift_rows_params():
    """Generates AES parameters to build ShiftRows variant.
            
    Returns: A tuple containing 2 elements that parameterize shift_rows for AES:
        A list of 4 lists of 4 integers describing circulant shift.
        A list of 4 lists of 4 integers describing no vertical shift.
    """
    range4 = range(4)
    return ([range4[-x:]+range4[:-x] for x in range4], 4*[range4])
    

def random_shift_rows_params():    
    """Generates random parameters to build ShiftRows variant.
            
    Returns: A tuple containing 2 elements that parameterize shift_rows:
        A list of 4 lists of 4 integers describing horizontal shift.
        A list of 4 lists of 4 integers describing vertical shift.
    """
    return ([permutation(int(4)) for _ in range(4)], 
    [permutation(int(4)) for _ in range(4)])