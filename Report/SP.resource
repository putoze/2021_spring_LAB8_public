 
****************************************
Report : resources
Design : SP
Version: N-2017.09-SP2
Date   : Fri Aug 12 12:28:41 2022
****************************************


Resource Report for this hierarchy in file
        /home/rain/IC_LAB/IC_training/LAB_8/CG/SP.v
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| add_x_13       | DW01_inc       | width=5    | add_172 (SP.v:172)         |
| sub_x_32       | DW01_dec       | width=3    | sub_286 (SP.v:286)         |
| add_x_185      | DW01_inc       | width=4    | Mul_inst/add_632_S2 (SP.v:632) |
| mult_x_188     | DW_mult_uns    | a_width=9  | Mul_inst/mult_660 (SP.v:660) |
               |                | b_width=9  |                            |
| gt_x_192       | DW_cmp         | width=9    | Sort_inst/gt_795 (SP.v:795) |
| lt_x_211       | DW_cmp         | width=11   | U_inst_C/lt_301 (SP.v:301) |
| lt_x_212       | DW_cmp         | width=11   | U_inst_C/lt_302 (SP.v:302) |
| lt_x_213       | DW_cmp         | width=11   | U_inst_C/lt_303 (SP.v:303) |
| lt_x_215       | DW_cmp         | width=11   | Mul_inst/U_inst_C/lt_301 (SP.v:301) |
| lt_x_216       | DW_cmp         | width=11   | Mul_inst/U_inst_C/lt_302 (SP.v:302) |
| lt_x_217       | DW_cmp         | width=11   | Mul_inst/U_inst_C/lt_303 (SP.v:303) |
| lt_x_219       | DW_cmp         | width=5    | lt_67 (SP.v:67)            |
|                |                |            | lt_68 (SP.v:68)            |
|                |                |            | lt_69 (SP.v:69)            |
|                |                |            | lt_70 (SP.v:70)            |
| gt_x_220       | DW_cmp         | width=5    | gt_256_S2 (SP.v:256)       |
|                |                |            | gt_270_S2 (SP.v:270)       |
| gt_x_221       | DW_cmp         | width=5    | gt_257 (SP.v:257)          |
|                |                |            | gt_271 (SP.v:271)          |
| lt_x_222       | DW_cmp         | width=9    | Sort_inst/lt_814 (SP.v:814) |
                |                |            | Sort_inst/lt_815 (SP.v:815) |
| lt_x_223       | DW_cmp         | width=9    | Sort_inst/lt_814_I2 (SP.v:814) |
             |                |            | Sort_inst/lt_815_I2 (SP.v:815) |
| lt_x_224       | DW_cmp         | width=9    | Sort_inst/lt_821 (SP.v:821) |
                |                |            | Sort_inst/lt_822 (SP.v:822) |
| lt_x_225       | DW_cmp         | width=9    | Sort_inst/lt_821_I2 (SP.v:821) |
             |                |            | Sort_inst/lt_822_I2 (SP.v:822) |
| add_x_15       | DW01_inc       | width=3    | add_182_S2 (SP.v:182)      |
|                |                |            | add_183_S2 (SP.v:183)      |
|                |                |            | add_184_S2 (SP.v:184)      |
|                |                |            | add_186_S2 (SP.v:186)      |
| DP_OP_427J1_122_3038            |            |                            |
|                | DP_OP_427J1_122_3038 |      |                            |
| DP_OP_428J1_123_3694            |            |                            |
|                | DP_OP_428J1_123_3694 |      |                            |
| DP_OP_435J1_124_5956            |            |                            |
|                | DP_OP_435J1_124_5956 |      |                            |
=============================================================================

Datapath Report for DP_OP_427J1_122_3038
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_427J1_122_3038 | U_inst_C/add_294 (SP.v:294)                         |
|                      | U_inst_C/add_294_2 (SP.v:294)                       |
|                      | U_inst_C/sub_295 (SP.v:295)                         |
|                      | U_inst_C/sub_296 (SP.v:296)                         |
|                      | U_inst_C/sub_298 (SP.v:298)                         |
|                      | U_inst_C/lt_300 (SP.v:300)                          |
|                      | U_inst_C/sub_297 (SP.v:297)                         |
|                      | U_inst_C/sub_297_2 (SP.v:297)                       |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 9     |                                          |
| I2    | PI   | Unsigned | 2     |                                          |
| I3    | PI   | Unsigned | 3     |                                          |
| T364  | IFO  | Signed   | 9     | O1[8:0]                                  |
| O1    | PO   | Unsigned | 11    | I1 + I2 + I3 (SP.v:294)                  |
| O2    | PO   | Signed   | 11    | O1 - $unsigned(9'b111111101) (SP.v:295)  |
| O3    | PO   | Signed   | 11    | O1 - $unsigned(10'b1111111010) (SP.v:296) |
| O4    | PO   | Signed   | 9     | T364 - $signed(5'b10100) (SP.v:298)      |
| O5    | PO   | Unsigned | 1     | O1 < $unsigned(9'b111111101) (SP.v:300)  |
| O6    | PO   | Unsigned | 11    | O1 + $unsigned(11'b01000001001) (SP.v:297) |
==============================================================================

Datapath Report for DP_OP_428J1_123_3694
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_428J1_123_3694 | Mul_inst/U_inst_C/add_294 (SP.v:294)                |
|                      | Mul_inst/U_inst_C/add_294_2 (SP.v:294)              |
|                      | Mul_inst/U_inst_C/sub_295 (SP.v:295)                |
|                      | Mul_inst/U_inst_C/sub_296 (SP.v:296)                |
|                      | Mul_inst/U_inst_C/sub_298 (SP.v:298)                |
|                      | Mul_inst/U_inst_C/lt_300 (SP.v:300)                 |
|                      | Mul_inst/U_inst_C/sub_297 (SP.v:297)                |
|                      | Mul_inst/U_inst_C/sub_297_2 (SP.v:297)              |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 9     |                                          |
| I2    | PI   | Unsigned | 9     |                                          |
| I3    | PI   | Unsigned | 10    |                                          |
| T371  | IFO  | Signed   | 9     | O1[8:0]                                  |
| O1    | PO   | Unsigned | 11    | I1 + I2 + I3 (SP.v:294)                  |
| O2    | PO   | Signed   | 11    | O1 - $unsigned(9'b111111101) (SP.v:295)  |
| O3    | PO   | Signed   | 11    | O1 - $unsigned(10'b1111111010) (SP.v:296) |
| O4    | PO   | Signed   | 9     | T371 - $signed(5'b10100) (SP.v:298)      |
| O5    | PO   | Unsigned | 1     | O1 < $unsigned(9'b111111101) (SP.v:300)  |
| O6    | PO   | Unsigned | 11    | O1 + $unsigned(11'b01000001001) (SP.v:297) |
==============================================================================

Datapath Report for DP_OP_435J1_124_5956
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_435J1_124_5956 | add_230_S2 (SP.v:230) add_230_S2_2 (SP.v:230)       |
|                      | add_238 (SP.v:238) add_238_2 (SP.v:238)             |
|                      | C2089 (SP.v:235) C2087 (SP.v:230) C2085 (SP.v:226)  |
|                      | C2091 (SP.v:222) add_235_S2 (SP.v:235)              |
|                      | add_236_S2 (SP.v:236) add_237_S2 (SP.v:237)         |
|                      | add_231_S2 (SP.v:231) add_232 (SP.v:232)            |
|                      | add_226_S2 (SP.v:226) add_227 (SP.v:227)            |
|                      | add_223 (SP.v:223)                                  |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 9     |                                          |
| I2    | PI   | Unsigned | 10    |                                          |
| I3    | PI   | Unsigned | 1     |                                          |
| I4    | PI   | Unsigned | 11    |                                          |
| I5    | PI   | Unsigned | 1     |                                          |
| I6    | PI   | Unsigned | 11    |                                          |
| T408  | IFO  | Unsigned | 11    | I1 + I2 ( SP.v:230 SP.v:238 )            |
| T433  | IFO  | Unsigned | 11    | { I3, I5 } ? T408 : I4 ( SP.v:222 SP.v:226 SP.v:230 SP.v:235 ) |
| O1    | PO   | Unsigned | 11    | I6 + T433 ( SP.v:223 SP.v:226 SP.v:227 SP.v:230 SP.v:231 SP.v:232 SP.v:235 SP.v:236 SP.v:237 SP.v:238 ) |
==============================================================================


Datapath Extraction Report

Information: Operator associated with resources 'U_inst_C/sub_295 (SP.v:295)' in design 'SP' breaks the datapath extraction because there is leakage due to truncation on its fanout to operator of resources 'U_inst_C/lt_301 (SP.v:301)'.  (HDL-120)

Information: Operator associated with resources 'U_inst_C/sub_296 (SP.v:296)' in design 'SP' breaks the datapath extraction because there is leakage due to truncation on its fanout to operator of resources 'U_inst_C/lt_302 (SP.v:302)'.  (HDL-120)

Information: Operator associated with resources 'U_inst_C/sub_297 (SP.v:297) U_inst_C/sub_297_2 (SP.v:297)' in design 'SP' breaks the datapath extraction because there is leakage due to truncation on its fanout to operator of resources 'U_inst_C/lt_303 (SP.v:303)'.  (HDL-120)

Information: Operator associated with resources 'Mul_inst/U_inst_C/sub_295 (SP.v:295)' in design 'SP' breaks the datapath extraction because there is leakage due to truncation on its fanout to operator of resources 'Mul_inst/U_inst_C/lt_301 (SP.v:301)'.  (HDL-120)

Information: Operator associated with resources 'Mul_inst/U_inst_C/sub_296 (SP.v:296)' in design 'SP' breaks the datapath extraction because there is leakage due to truncation on its fanout to operator of resources 'Mul_inst/U_inst_C/lt_302 (SP.v:302)'.  (HDL-120)

Information: Operator associated with resources 'Mul_inst/U_inst_C/sub_297 (SP.v:297) Mul_inst/U_inst_C/sub_297_2 (SP.v:297)' in design 'SP' breaks the datapath extraction because there is leakage due to truncation on its fanout to operator of resources 'Mul_inst/U_inst_C/lt_303 (SP.v:303)'.  (HDL-120)


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| add_x_13           | DW01_inc         | apparch (area)     |                |
| sub_x_32           | DW01_dec         | apparch (area)     |                |
| add_x_185          | DW01_inc         | apparch (area)     |                |
| mult_x_188         | DW_mult_uns      | pparch (area,speed)                 |
|                    |                  | mult_arch: benc_radix4              |
| gt_x_192           | DW_cmp           | apparch (area)     |                |
| lt_x_211           | DW_cmp           | apparch (area)     |                |
| lt_x_212           | DW_cmp           | apparch (area)     |                |
| lt_x_213           | DW_cmp           | apparch (area)     |                |
| lt_x_215           | DW_cmp           | apparch (area)     |                |
| lt_x_216           | DW_cmp           | apparch (area)     |                |
| lt_x_217           | DW_cmp           | apparch (area)     |                |
| lt_x_219           | DW_cmp           | apparch (area)     |                |
| gt_x_220           | DW_cmp           | apparch (area)     |                |
| gt_x_221           | DW_cmp           | apparch (area)     |                |
| lt_x_222           | DW_cmp           | apparch (area)     |                |
| lt_x_223           | DW_cmp           | apparch (area)     |                |
| lt_x_224           | DW_cmp           | apparch (area)     |                |
| lt_x_225           | DW_cmp           | apparch (area)     |                |
| add_x_15           | DW01_inc         | apparch (area)     |                |
| DP_OP_427J1_122_3038                  |                    |                |
|                    | DP_OP_427J1_122_3038 | str (area)     |                |
| DP_OP_428J1_123_3694                  |                    |                |
|                    | DP_OP_428J1_123_3694 | str (area)     |                |
| DP_OP_435J1_124_5956                  |                    |                |
|                    | DP_OP_435J1_124_5956 | str (area)     |                |
===============================================================================

1
