--Extimator Pixel Retrieval unit
--It is the first stage of the extimator, in charge of generating the memory address
--in order to extract the correct pixels from memory

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.AMEpkg.all;

entity extimator_PelRet is
	port ( MV0_in, MV1_in, MV2_in: in motion_vector(1 downto 0);--0:h, 1:v
		   RF_Addr, clk, RF_in_WE, RF_in_RE, MULT1_VALID, ADD3_MVin_LE, ADD3_VALID, incrY: in std_logic;
		   --firstPelPos
		   CE_REPx, CE_BLKx, RST_BLKx, CE_REPy, CE_BLKy, RST_BLKy: in std_logic;
		   last_block_x, last_block_y: out std_logic;
		   CurCU_h, CurCU_w: in std_logic_vector(6 downto 0);
		   sixPar,RST1, RST2, LE_ab: in std_logic; --The RST1 is for the first two registers, RST2 is for the remaining ones
		   RADDR_RefCu_x, RADDR_RefCu_y: out std_logic_vector(12 downto 0);
		   RADDR_CurCu_x, RADDR_CurCu_y: out std_logic_vector(5 downto 0);
		   MV0_out, MV1_out, MV2_out: out motion_vector(1 downto 0)--0:h, 1:v
		); 
end entity;

architecture structural of extimator_PelRet is

	--W, H, sixPar sampling
	signal CurCU_w_short, CurCU_h_short: std_logic_vector(1 downto 0);
	signal sixPar_samp: std_logic;
	--Register file
	signal RF_out0, RF_out1, RF_out2: motion_vector(1 downto 0);	--Register file output (current motion vectors)
	--firstPelPos 
	constant X0Y0_DEPTH: integer := 12;
	signal x0_int, y0_int: slv_6(X0Y0_DEPTH downto 0);
	--Producing a_(1,2) and b_(1,2)
	signal sub1_pos_in, sub1_neg_in: motion_vector(3 downto 0);
	signal sub1_out_tmp: slv_12(3 downto 0);
	signal sub1_out_samp: slv_12(3 downto 0);
	signal R_SH2_out_tmp: slv_12(3 downto 0);
	signal R_SH2_out2_inv: std_logic_vector(11 downto 0);
	signal R_SH2_cmd, R_SH2_cmd_samp: slv_2(3 downto 0);
	signal R_SH2_out, R_SH2_out_samp: slv_12(3 downto 0);
	--Multiplication {a_(1,2);b_(1,2)}*{x0;y0}
	signal x0_int_ext, y0_int_ext: std_logic_vector(7 downto 0);
	signal coord_comp: slv_12(3 downto 0);
	signal MULT1_out : slv_24(3 downto 0);
	signal MULT1_out_0, MULT1_out_1, MULT1_out_2, MULT1_out_3 : std_logic_vector(23 downto 0);
	signal MULT1_out_cut: slv_18(3 downto 0);
	--ADD3 stage
	signal MV0_in_ADD3 : motion_vector(1 downto 0);
	signal MV0_in_ADD3_sh4 : slv_15(1 downto 0);
	signal MV0_in_ADD3_ext : slv_18(1 downto 0);
	signal MVr_ex_v, MVr_ex_h: std_logic_vector(19 downto 0);
	--Rounding stage
	signal MVr_v_tmp, MVr_h_tmp, MVr_v, MVr_h: std_logic_vector(11 downto 0);
	--RADDR calculation stage
	signal x,y: std_logic_vector(11 downto 0);
	signal y_count_out: std_logic_vector(1 downto 0);
	signal y_count_out_ext: std_logic_vector(5 downto 0);
	signal y_short: std_logic_vector(5 downto 0);
	signal RADDR_RefCu_x_tmp, RADDR_RefCu_y_tmp: std_logic_vector(12 downto 0);
	signal RADDR_CurCu_x_tmp, RADDR_CurCu_y_tmp: std_logic_vector(5 downto 0);

begin

----Input registers and RF
	width_register: REG_N
		generic map(N=>2)
		port map(D=>CurCU_w(6 downto 5),Q=>CurCU_w_short,RST=>RST1,clk=>clk);
	height_register: REG_N
		generic map(N=>2)
		port map(D=>CurCU_h(6 downto 5),Q=>CurCU_h_short,RST=>RST1,clk=>clk);
	sixPar_reg: FlFl
		port map(D=>sixPar,Q=>sixPar_samp,clk=>clk,RST=>RST1);

	input_RF: Ext_RF
		port map( RF_Addr, MV0_in,MV1_in,MV2_in, clk, RF_in_WE, RF_in_RE, RST1, RF_out0, RF_out1, RF_out2);
	
----FirstPelPos
	firstPelPos_calc: firstPelPos
		port map ( CE_REPx, CE_BLKx, RST_BLKx, clk, RST1, CE_REPy, CE_BLKy, RST_BLKy, CurCU_w_short, CurCU_h_short,
			   last_block_x, last_block_y, x0_int(0), y0_int(0));
	--{x0;y0} pipeline. I distinguish between the first one and the subsequent registers because of the CU slow reactivity
	X0_REG_N_1: REG_N
			generic map(N=>6)
			port map(D=>x0_int(0),Q=>x0_int(1),RST=>RST1,clk=>clk);	
	Y0_REG_N_1: REG_N
			generic map(N=>6)
			port map(D=>y0_int(0),Q=>y0_int(1),RST=>RST1,clk=>clk);	
	X0Y0_Pipe: for I in 2 to X0Y0_DEPTH generate
		X0_REG_N_X: REG_N
			generic map(N=>6)
			port map(D=>x0_int(I-1),Q=>x0_int(I),RST=>RST2,clk=>clk);
		Y0_REG_N_X: REG_N
			generic map(N=>6)
			port map(D=>y0_int(I-1),Q=>y0_int(I),RST=>RST2,clk=>clk);
	end generate;
	
	
----Producing a_(1,2) and b_(1,2)
	
	sub1_pos_in(0)<= RF_out1(0);
	sub1_neg_in(0)<= RF_out0(0);
	sub1_pos_in(1)<= RF_out1(1);
	sub1_neg_in(1)<= RF_out0(1);
	sub1_pos_in(2)<= RF_out2(0) when sixPar_samp='1' else RF_out1(1);
	sub1_neg_in(2)<= RF_out0(0) when sixPar_samp='1' else RF_out0(1);
	sub1_pos_in(3)<= RF_out2(1) when sixPar_samp='1' else RF_out1(0);
	sub1_neg_in(3)<= RF_out0(1) when sixPar_samp='1' else RF_out0(0);

	R_SH2_cmd(0)<=CurCU_w_short;
	R_SH2_cmd(1)<=R_SH2_cmd(0);
	R_SH2_cmd(2)<=CurCU_h_short WHEN sixPar_samp='1' else CurCU_w_short;
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
	end generate;
	
	RSH2_GEN: for I in 0 to 3 generate
		R_SH2_X: R_SH2
			generic map(N=>12)
			port map(SH_in=>sub1_out_samp(I),shift_amt=>R_SH2_cmd_samp(I),clk=>clk,RST=>RST2,LE=>'1',SH_out=>R_SH2_out_tmp(I));
			--a2<=(0);a1<=(1);b2(2);b1<=(3);
	end generate;

	--In this intermediate passage, the inversion of b2 is done if sixPar='0'
	R_SH2_out(0)<=R_SH2_out_tmp(0);
	R_SH2_out(1)<=R_SH2_out_tmp(1);
	R_SH2_out(3)<=R_SH2_out_tmp(3);
	
	R_SH2_out2_inv<=std_logic_vector(signed(NOT R_SH2_out_tmp(2))+1); --the negative of b2
	R_SH2_out(2)<= R_SH2_out_tmp(2) WHEN sixPar_samp='1' ELSE R_SH2_out2_inv;
	
	a12b12_REG_GEN: for I in 0 to 3 generate
		a12b12_REG: REG_N_LE
			generic map(N=>12)
			port map(D=>R_SH2_out(I),Q=>R_SH2_out_samp(I), RST=>RST2, clk=>clk, LE=>LE_ab);
			--a2<=(0);a1<=(1);b2(2);b1<=(3);
	end generate;

	--NOTE: From now on the notation is FXP X.4
	--Inizialmente avevo scelto di usare la notazione FXP X.3 perche' avevo dimostrato che 3 cifre decimali erano il minimo sindacale per far sì che
	--l'algoritmo hardware coincidesse con quello software. Alla fine ho scelto di lasciarle tutte perche' in ogni caso al moltiplicatore serve un
	--ingresso pari. Non avrebbe senso scartare dell'informazione per ridurre il parallelismo e poi aggiungere un bit di padding!

----Multiplication {a_(1,2);b_(1,2)}*{x0;y0}

	x0_int_extender: sign_extender
		generic map(N_in=>6,N_out=>8)
		port map(x0_int(4),x0_int_ext);
	y0_int_extender: sign_extender
		generic map(N_in=>6,N_out=>8)
		port map(y0_int(4),y0_int_ext);
	
	coord_comp(0)<= "0000" & x0_int_ext;
	coord_comp(1)<= coord_comp(0);
	coord_comp(2)<= "0000" & y0_int_ext;
	coord_comp(3)<= coord_comp(2);
	
	MULT1_GEN: for I in 0 to 3 generate
		MULT1_X: MULT1
			generic map( N=>12)
			port map (R_SH2_out_samp(I), coord_comp(I), MULT1_VALID, RST2,clk, MULT1_out(I));
	end generate;

	--I need to explicitate to extract the LSBs
	MULT1_out_0<=MULT1_out(0);
	MULT1_out_1<=MULT1_out(1);
	MULT1_out_2<=MULT1_out(2);
	MULT1_out_3<=MULT1_out(3); --FXP 14.4
	
	MULT1_out_cut(0)<=MULT1_out_0(17 downto 0);
	MULT1_out_cut(1)<=MULT1_out_1(17 downto 0);
	MULT1_out_cut(2)<=MULT1_out_2(17 downto 0);
	MULT1_out_cut(3)<=MULT1_out_3(17 downto 0);

----ADD3 stage

	MV0_reg_for_ADD3: for I in 0 to 1 generate
		MV0_hv_in_ADD3_reg: REG_N_LE
			generic map(N=>11)
			port map(D=>RF_out0(I),Q=>MV0_in_ADD3(I),RST=>RST1,clk=>clk,LE=>ADD3_MVin_LE);
	end generate;
	
	MV0_forADD3_extender_gen: for I in 0 to 1 generate
		MV0_in_ADD3_sh4(I)<= MV0_in_ADD3(I) & "0000";
		MV0_forADD3_extender: sign_extender
			generic map(N_in=>15,N_out=>18)
			port map(MV0_in_ADD3_sh4(I),MV0_in_ADD3_ext(I));
	end generate;

	ADD3_1: ADD3
		generic map(N=>18)
		port map( MULT1_out_cut(3),MV0_in_ADD3_ext(1),MULT1_out_cut(1), ADD3_VALID, RST2, clk, MVr_ex_v );
		
	ADD3_0: ADD3
		generic map(N=>18)
		port map( MULT1_out_cut(0),MV0_in_ADD3_ext(0),MULT1_out_cut(2), ADD3_VALID, RST2, clk, MVr_ex_h );

----Round Stage
	
	MVr_ex_v_round: Round
		port map(Round_in=>MVr_ex_v,Round_out=>MVr_v_tmp);
	
	MVr_ex_h_round: Round
		port map(Round_in=>MVr_ex_h,Round_out=>MVr_h_tmp);

	MVr_v_REG: REG_N
		generic map(N=>12)
		port map(D=>MVr_v_tmp,Q=>MVr_v,RST=>RST2,clk=>clk);
		
	MVr_h_REG: REG_N
		generic map(N=>12)
		port map(D=>MVr_h_tmp,Q=>MVr_h,RST=>RST2,clk=>clk);	

----RADDR calculation stage

	--x
	x<= "000000" & x0_int(X0Y0_DEPTH);

	--Here the fact that the adder is signed is not a problem since x of course is a positive number (starts with at least 6 zeroes)
	--and it is treated as one
	RADDR_RefCu_x_calculator: adder
		generic map(N=>12)
		port map(MVr_h,x,RADDR_RefCu_x_tmp);
	
	RADDR_CurCu_x_tmp<=x0_int(X0Y0_DEPTH);
	
	--y
	
	y_counter: COUNT_VAL
		generic map(N=>2)
		port map(CE=>incrY,RST=>RST2,clk=>clk,COUNT=>y_count_out);
		
	y_count_out_ext<= "0000"&y_count_out;
	
	y_short<= std_logic_vector(unsigned(y0_int(X0Y0_DEPTH))+unsigned(y_count_out_ext));
	y<= "000000" & y_short;

	--Here the fact that the adder is signed is not a problem since y of course is a positive number (starts with at least 6 zeroes)
	--and it is treated as one
	RADDR_RefCu_y_calculator: adder
		generic map(N=>12)
		port map(MVr_v,y,RADDR_RefCu_y_tmp);
	
	RADDR_CurCu_y_tmp<=y(5 downto 0);

	--RADDR_sampling
	RADDR_CurCu_x_sampling: REG_N
		generic map(N=>6)
		port map(D=>RADDR_CurCu_x_tmp,Q=>RADDR_CurCu_x,clk=>clk,RST=>RST2);
	RADDR_CurCu_y_sampling: REG_N
		generic map(N=>6)
		port map(D=>RADDR_CurCu_y_tmp,Q=>RADDR_CurCu_y,clk=>clk,RST=>RST2);
	
	RADDR_RefCu_x_sampling: REG_N
		generic map(N=>13)
		port map(D=>RADDR_RefCu_x_tmp,Q=>RADDR_RefCu_x,clk=>clk,RST=>RST2);
	RADDR_RefCu_y_sampling: REG_N
		generic map(N=>13)
		port map(D=>RADDR_RefCu_y_tmp,Q=>RADDR_RefCu_y,clk=>clk,RST=>RST2);

-----Output assignment. This output goes directly into the output register file
	MV0_out<=RF_out0;
	MV1_out<=RF_out1;	
	MV2_out<=RF_out2;

end architecture structural;
