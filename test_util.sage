# *****************************************************************
#  Copyright 2016 MIT Lincoln Laboratory  
#  Project:            CryptoSynth
#  Authors:            Merrielle Spain
#  Description:        This supports testing.
#  THE SOFTWARE IS PROVIDED TO YOU ON AN "AS IS" BASIS                    
#                      
# 
#  Modifications:
#  Date              Name           Modification
#  ----              ----           ------------
#  29 January 2016   MS             Original Version
# *****************************************************************

def print_passed(passed, test_name):
    """Displays test results.
        
    Args:
        passed: A bool True if test passed, and False otherwise.
        test_name: A str name of test for display.
    """
    if passed:
        print test_name + ' passed'
    else:
        print test_name + ' failed                     X'
        

def report_results(incorrect, test_name):
    """Displays test results with details of incorrect instances.
    
    Prints test_name followed by all indices that failed the test.  If all 
    indices passed, it prints passed.
    
     Args:
        incorrect: A list of incorrect instances.
        test_name: A str name of test for display.
    """
    if bool(incorrect):
        print test_name + ' failures:'
        for i in incorrect:
            print str(i) + ', '
    else:
        print test_name + ' passed'
        
        
def test_all():
    """Runs all tests.
    
    Note that the test name and sage file name match.
    """
    test_list = ["test_sub_bytes", "test_shift_rows", "test_mix_columns", 
        "test_key_expansion", "test_encryption"]
    for test_name in test_list:
        load(test_name+".sage")
        eval(test_name+"()")