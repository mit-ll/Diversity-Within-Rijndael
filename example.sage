# *****************************************************************
#  Copyright 2016 MIT Lincoln Laboratory  
#  Project:            CryptoSynth
#  Authors:            Merrielle Spain
#  Description:        This provides an example of generating SubBytes.
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


def example_sub_bytes():
    """Demonstrates building a random SubBytes variant and testing properties.
    
    Builds a random sub_bytes and measures properties: lacks (anti-)fixed 
    points, maximal linear bias, and maximal difference probability.
    """
    K = gen_random_field()
    af = gen_random_affine()
    sb = build_sub_bytes(K, af)
    sbint = map(lambda x: Integer(x.integer_representation()), sb)
    S = mq.SBox(sbint)
    print 'SubBytes: '+str(sbint)
    print 'Free of fixed points: '+str(bool(not_any_fixed_points(sb)))
    print 'Maximal linear bias: '+str(S.maximal_linear_bias_absolute())
    print 'Maximal difference probability: '+str(S.
        maximal_difference_probability_absolute())