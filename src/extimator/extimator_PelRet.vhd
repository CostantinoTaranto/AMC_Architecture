--Extimator Pixel Retrieval unit
--It is the first stage of the extimator, in charge of generating the memory address
--in order to extract the correct pixels from memory

library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.AMEpkg.all;

entity extimator_PelRet is
	port ( MV0_in, MV1_in, MV2_in: in motion_vector(1 downto 0);--0:h, 1:v
		   RF_Addr, clk, RF_in_WE, RF_in_RE: in std_logic;
		   --firstPelPos
		   CE_REPx, CE_BLKx, RST_BLKx, CE_REPy, CE_BLKy, RST_BLKy: in std_logic;
		   last_block_x, las_block_y: out std_logic;
		   CurCU_h, CurCU_w: in std_logic_vector(6 downto 0);
		   sixPar,RST1, RST2: in std_logic; --The RST1 is for the first two registers, RST2 is for the remaining ones
		   RADDR_RefCu_x, RADDR_RefCu_y: out std_logic_vector(12 downto 0);
		   RADDR_CurCu_x, RADDR_CurCu_y: out std_logic_vector(5 downto 0);
		   MV0_out, MV1_out, MV2_out: in motion_vector(1 downto 0);--0:h, 1:v
		); 
end entity;

architecture structural of extimator_PelRet is

	--W and H sampling
	signal CurCU_w_short, CurCU_h_short: (1 downto 0);
	--Register file
	signal RF_out0, RF_out1, RF_out2: motion_vector(2 downto 0);	--Register file output (current motion vectors)
	--firstPelPos 
	constant X0Y0_DEPTH: integer := 12;
	signal x0_int, y0_int: slv6 (X0Y0_DEPTH downto 0);
	--Producing a_(1,2) and b_(1,2)
	signal sub1_pos_in, sub1_neg_in: motion_vector(3 downto 0);
	signal sub1_out_tmp, sub1_out_tmp: slv_12(3 downto 0);
	signal sub1_up_out_samp, sub1_down_out_samp: slv_12(3 downto 0);
	signal R_SH2_cmd, R_SH2_cmd_samp: slv_2(3 dowto 0);
	signal R_SH2_out: slv_12(3 downto 0);
	signal a1_tmp, b1_tmp, a2_tmp, b2_tmp: std_logic_vector(11 downto 0);
	signal a1, b1, a2, b2: std_logic_vector(10 downto 0);
	

begin

----Input registers and RF
	width_register: REG_N
		generic map(N=>2);
		port map(D=>CurCU_w(6 downto 5),Q=CurCU_w_short,RST=>RST1,clk=>clk);
	height_register: REG_N
		generic map(N=>2);
		port map(D=>CurCU_h(6 downto 5),Q=CurCU_h_short,RST=>RST1,clk=>clk);

	input_RF: Ext_RF
		port map( RF_Addr, MV0_in,MV1_in,MV2_in, clk, RF_in_WE, RF_in_RE, RST1, RF_out0, RF_out1, RF_out2);
	
----FirstPelPos
	firstPelPos_calc: firstPelPos
		port map ( CE_REPx, CE_BLKx, RST_BLKx, clk, RST1, CE_REPy, CE_BLKy, RST_BLKy, CurCU_w_short, CurCU_h_short,
			   last_block_x, last_block_y, x0_int(0), y0_int(0));

----Producing a_(1,2) and b_(1,2)
	
	sub1_pos_in(0)<= RF_out1(0);
	sub1_neg_in(0)<= RF_out0(0);
	sub1_pos_in(1)<= RF_out1(1);
	sub1_neg_in(1)<= RF_out0(1);
	sub1_pos_in(2)<= RF_out2(0) when sixPar(1)='1' else RF_out1(1);
	sub1_neg_in(2)<= RF_out0(0) when sixPar(1)='1' else RF_out0(1);
	sub1_pos_in(3)<= RF_out2(1) when sixPar(1)='1' else RF_out1(0);
	sub1_neg_in(3)<= RF_out0(1) when sixPar(1)='1' else RF_out0(0);

	R_SH2_cmd(0)<=CurCU_w_short;
	R_SH2_cmd(1)<=R_SH2_cmd(0);
	R_SH2_cmd(2)<=CurCU_h_short WHEN sixPar(1)='1' else CurCU_w_short;
	R_SH2_cmd(3)<=R_SH2_cmd(2);

	SUB1_GEN: for I in 0 to 3 generate
		SUB1_x: subtractor
			generic map(N=>11)
			port map(sub1_pos_in(I),sub1_neg_in(I),sub1_out_tmp(I));
		SUB_OUT_samp_x: REG_N
			generic map(N=>12)
			port map(D=>sub1_out_tmp(I),Q=>sub1_out_samp(I), clk=>clk,RST=>RST1);
		R_SH2_cmd_samp_x: REG_N
			generic map(N=>2)
			port map(D=>R_SH2_cmd(I),Q=>R_SH2_cmd_samp(I),clk=>clk,RST=>RST1);
		R_SH2_X: R_SH2
			generic map(N=>12)
			port map(SH_in=>sub1_out_samp(I),shift_amt=>R_SH2_cmd_samp(I),clk=>clk,RST=>RST2,LE=>'1',SH_out=>R_SH2_out(I));
	end generate;

	a2_tmp<=R_SH2_out(0);
	a1_tmp<=R_SH2_out(1);
	b2_tmp<=R_SH2_out(2);
	b1_tmp<=R_SH2_out(3);

	a1_register: REG_N
		generic map(N=>11)
		port map(D=>a1_tmp(11 downto 1), Q=>a1, RST=>RST2, clk=>clk);
	a2_register: REG_N
			generic map(N=>11)
			port map(D=>a2_tmp(11 downto 1), Q=>a2, RST=>RST2, clk=>clk);
	b1_register: REG_N
		generic map(N=>11)
		port map(D=>b1_tmp(11 downto 1), Q=>b1, RST=>RST2, clk=>clk);
	b2_register: REG_N
			generic map(N=>11)
			port map(D=>b2_tmp(11 downto 1), Q=>b2, RST=>RST2, clk=>clk);

	--NOTE: From now on the notation is FXP 8.3




end architecture structural;
