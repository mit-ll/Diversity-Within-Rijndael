# *****************************************************************
#  Copyright 2016 MIT Lincoln Laboratory  
#  Project:            CryptoSynth
#  Authors:            Merrielle Spain
#  Description:        This tests ShiftRows.
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
    load("shift_rows.sage")
    load("sub_bytes.sage")
    
def test_shift_rows():
    """Tests ShiftRows and its inverse.
    
    Prints pass or fail for tests on shift_rows and shift_rows_inv.        
    """
    print '---Testing ShiftRows---'
    print_passed(test_shift_rows_aes(), 'AES shift rows')
    shifts = random_shift_rows_params()
    field = gen_aes_field()
    mat = random_matrix(field, 4, 4)
    print_passed(test_shift_rows_inversion(mat, shifts), 
        'Inversion on random matrix')
    print_passed(test_no_shift(mat), 'No shift on random matrix')
    print_passed(test_reflect_in_columns(mat), 
        'Reflection in columns on random matrix')
    print_passed(test_reflect_in_rows(mat), 
        'Reflection in rows on random matrix')
    
            
    mat = matrix(map(lambda x: range(16)[4*x:4*x+4], range(4)))
    shifts = random_shift_rows_params()
    print_passed(test_shift_rows_inversion(mat, shifts), 
        'Inversion on int matrix')
    print_passed(test_no_shift(mat), 'No shift on int matrix')
    print_passed(test_reflect_in_columns(mat), 
        'Reflection in columns on int matrix')
    print_passed(test_reflect_in_rows(mat), 'Reflection in rows on int matrix')


def test_shift_rows_inversion(mat, shifts):
    """Tests whether ShiftRows and its nominal inverse are inverses.
    
    Verifies that applying shift_rows then shift_rows_inv yields the original
    matrix.

    Args:
        mat: A 4x4 matrix over GF(2^8) representing state.
        shifts: A tuple of 2 lists:
            A list of 4 lists of 4 integers describing horizontal shift.
            A list of 4 lists of 4 integers describing vertical shift.

    Returns:
        A bool True if the orignal matrix was recovered, and False otherwise.
    """   
    return mat == shift_rows_inv(shift_rows(mat, shifts), shifts)
    
    
def test_shift_rows_aes():
    """Tests whether shift_rows works correctly with AES parameters.
    
    Verifies that shift_rows with parameters from aes_shift_rows_params produces
    the circulant shift from AES.

    Returns:
        A bool True if AES circulant shift occurs, and False otherwise.
    """
    list16 = map(lambda x: range(16)[4*x:4*x+4], range(4))
    mat_shifted = matrix([list16[x][x:]+list16[x][:x] for x in range(4)])
    shifts = aes_shift_rows_params()
    return mat_shifted == shift_rows(matrix(list16), shifts)
    
    
def test_no_shift(mat):
    """Tests ShiftRows when parameters indicate no shift.
    
    Verifies that no shift has occurred when parameterizing shift_rows not to 
    shift.

    Args:
        mat: A 4x4 matrix over GF(2^8) representing state.

    Returns:
        A bool True if no shift occurs, and False otherwise.
    """
    to_row = 4*[range(4)]
    to_column = 4*[range(4)]
    return mat == shift_rows(mat, (to_row, to_column))
    
    
def test_reflect_in_columns(mat):
    """Tests whether ShiftRows can reflect values in columns.
    
    Verifies shift when parameterizing shift_rows to reflect values in columns, 
    while leaving column membership intact. 

    Args:
        mat: A 4x4 matrix over GF(2^8) representing state.

    Returns:
        A bool True if reflection in columns occurs, and False otherwise.
    """
    to_row = 4*[range(4)]
    to_column = 4*[range(4)[::-1]]
    return mat[:, ::-1] == shift_rows(mat, (to_column, to_row))
    
    
def test_reflect_in_rows(mat):
    """Tests whether ShiftRows can reflect values in rows.
        
    Verifies shift when parameterizing shift_rows to reflect values in rows, 
    while leaving row membership intact. 

    Args:
        mat: A 4x4 matrix over GF(2^8) representing state.

    Returns:
        A bool True if reflection in rows occurs, and False otherwise.
    """
    to_row = 4*[range(4)[::-1]]
    to_column = 4*[range(4)]
    return mat[::-1, :] == shift_rows(mat, (to_column, to_row))