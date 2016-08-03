# Diversity-Within-Rijndael
This project generates Rijndael variants as described in "Diversity Within the Rijndael Design Principles for Resistance to Differential Power Analysis." This is for demonstration purposes only and does not address timing side channels.

It runs inside the SageMath environment:  
W. Stein et al., Sage Mathematics Software (Version 6.2), The Sage Development Team, 2015, http://www.sagemath.org.

A single text block can be encrypted or decrypted with a new variant.

# Contents
The code generalizes the steps of a round as follows:  
<table>
 <tr><td> </td>        <td>Generalization</td>    <td>Testing</td>  </tr>
 <tr><td>1. SubBytes</td>     <td>sub_bytes.sage</td>    <td>test_sub_bytes.sage</td>  </tr>
 <tr><td>2. ShiftRows</td>    <td>shift_rows.sage</td>   <td>test_shift_rows.sage</td>  </tr>
 <tr><td>3. MixColumns</td>   <td>mix_columns.sage</td>  <td>test_mix_columns.sage</td>  </tr>
 <tr><td>4. AddRoundKey</td>  <td>key.sage</td>          <td>test_key_expansion.sage</td>  </tr>
 <tr><td>Encrypt block</td>   <td>encrypt.sage</td>      <td>test_encryption.sage</td>  </tr>
</table>
Other files contain test data to verify implementation in aes_test_vectors.sage, general purpose testing in test_util.sage, and examples in example.sage.

Documentation is included through pydoc in html files corresponding to each sage file.

# Testing
In the same directory as the above files, verify that all tests pass.  
```
sage: load("test_util.sage")  
sage: test_all()  
---Testing AES sub_bytes---  
Matching against AES SubBytes passed...  
```

Generate a SubBytes variant and measure its properties (outputs will vary).  
```
sage: load("example.sage")  
sage: example_sub_bytes()  
SubBytes: [6, 67, 118, 87, 75, 205, 39, 111, 174, 142, 236,...  
Free of fixed points: False  
Maximal linear bias: 16  
Maximal difference probability: 4
```

# Copyright

Copyright 2016 Massachusetts Institute of Technology  
Project: CryptoSynth  
Author: Merrielle Spain  

This software is distributed by open source pursuant to the GNU General Public License ("GPLv2") Version 2 authored by the Free Software Foundation (available at http://www.fsf.org).

# Disclaimer

The software/firmware is provided to you on an As-Is basis

This material is based upon work supported by the Department of the Navy under Air Force Contract No. FA8721-05-C-0002 and/or FA8702-15-D-0001. Any opinions, findings, conclusions or recommendations expressed in this material are those of the author(s) and do not necessarily reflect the views of the Department of the Navy.
