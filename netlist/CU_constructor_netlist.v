
module CU_constructor_netlist ( START, GOT, CNT_compEN_OUT, CNT_STOPcompEN_OUT, 
        clk, CU_RST, RST, RSH_LE, cmd_SH_EN, READY, DONE, CE_compEN, 
        CE_STOPcompEN, compEN, PS_out, NS_out );
  output [2:0] PS_out;
  output [2:0] NS_out;
  input START, GOT, CNT_compEN_OUT, CNT_STOPcompEN_OUT, clk, CU_RST;
  output RST, RSH_LE, cmd_SH_EN, READY, DONE, CE_compEN, CE_STOPcompEN, compEN;
  wire   START_int, GOT_int, CNT_compEN_OUT_int, CNT_STOPcompEN_OUT_int, n1,
         n2, n3, n4, RSH_LE, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16,
         compEN, START_sampling_n1, GOT_sampling_n2,
         CNT_compEN_OUT_sampling_n2, CNT_STOPcompEN_OUT_sampling_n2;
  assign READY = RSH_LE;
  assign CE_STOPcompEN = compEN;

  DFFR_X1 PS_reg_0_ ( .D(NS_out[0]), .CK(clk), .RN(n1), .Q(PS_out[0]), .QN(n9)
         );
  DFFR_X1 PS_reg_1_ ( .D(NS_out[1]), .CK(clk), .RN(n1), .Q(PS_out[1]), .QN(n8)
         );
  DFFR_X1 PS_reg_2_ ( .D(NS_out[2]), .CK(clk), .RN(n1), .Q(PS_out[2]), .QN(n7)
         );
  INV_X1 U3 ( .A(CU_RST), .ZN(n1) );
  NAND3_X1 U23 ( .A1(n14), .A2(n8), .A3(CNT_STOPcompEN_OUT_int), .ZN(n13) );
  INV_X1 U24 ( .A(n14), .ZN(n6) );
  INV_X1 U25 ( .A(n10), .ZN(RSH_LE) );
  OAI221_X1 U26 ( .B1(n12), .B2(n8), .C1(n10), .C2(n2), .A(n13), .ZN(NS_out[1]) );
  AOI21_X1 U27 ( .B1(PS_out[2]), .B2(n3), .A(n9), .ZN(n12) );
  OAI22_X1 U28 ( .A1(n9), .A2(n4), .B1(n11), .B2(n7), .ZN(NS_out[2]) );
  NOR3_X1 U29 ( .A1(n3), .A2(n9), .A3(n8), .ZN(n11) );
  INV_X1 U30 ( .A(cmd_SH_EN), .ZN(n4) );
  NOR2_X1 U31 ( .A1(PS_out[1]), .A2(PS_out[2]), .ZN(RST) );
  NOR3_X1 U32 ( .A1(n7), .A2(PS_out[1]), .A3(PS_out[0]), .ZN(CE_compEN) );
  NOR2_X1 U33 ( .A1(n8), .A2(PS_out[2]), .ZN(cmd_SH_EN) );
  NOR2_X1 U34 ( .A1(PS_out[1]), .A2(n6), .ZN(compEN) );
  OAI211_X1 U35 ( .C1(CNT_STOPcompEN_OUT_int), .C2(n6), .A(n15), .B(n16), .ZN(
        NS_out[0]) );
  OAI21_X1 U36 ( .B1(CNT_compEN_OUT_int), .B2(n7), .A(n9), .ZN(n15) );
  AOI22_X1 U37 ( .A1(RST), .A2(n2), .B1(PS_out[1]), .B2(PS_out[2]), .ZN(n16)
         );
  NOR2_X1 U38 ( .A1(n7), .A2(n9), .ZN(n14) );
  NOR2_X1 U39 ( .A1(n6), .A2(n8), .ZN(DONE) );
  NAND2_X1 U40 ( .A1(RST), .A2(PS_out[0]), .ZN(n10) );
  INV_X1 U41 ( .A(GOT_int), .ZN(n3) );
  INV_X1 U42 ( .A(START_int), .ZN(n2) );
  INV_X1 START_sampling_U3 ( .A(CU_RST), .ZN(START_sampling_n1) );
  DFFR_X1 START_sampling_Q_int_reg ( .D(START), .CK(clk), .RN(
        START_sampling_n1), .Q(START_int) );
  INV_X1 GOT_sampling_U3 ( .A(CU_RST), .ZN(GOT_sampling_n2) );
  DFFR_X1 GOT_sampling_Q_int_reg ( .D(GOT), .CK(clk), .RN(GOT_sampling_n2), 
        .Q(GOT_int) );
  INV_X1 CNT_compEN_OUT_sampling_U3 ( .A(CU_RST), .ZN(
        CNT_compEN_OUT_sampling_n2) );
  DFFR_X1 CNT_compEN_OUT_sampling_Q_int_reg ( .D(CNT_compEN_OUT), .CK(clk), 
        .RN(CNT_compEN_OUT_sampling_n2), .Q(CNT_compEN_OUT_int) );
  INV_X1 CNT_STOPcompEN_OUT_sampling_U3 ( .A(CU_RST), .ZN(
        CNT_STOPcompEN_OUT_sampling_n2) );
  DFFR_X1 CNT_STOPcompEN_OUT_sampling_Q_int_reg ( .D(CNT_STOPcompEN_OUT), .CK(
        clk), .RN(CNT_STOPcompEN_OUT_sampling_n2), .Q(CNT_STOPcompEN_OUT_int)
         );
endmodule

