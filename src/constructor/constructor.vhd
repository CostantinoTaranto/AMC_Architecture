library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.AMEpkg.all;

entity constructor is
	port ( MV0,MV1,MV2: in motion_vector(0 to 1); --0:h,1:v
		   clk, RST, RSH_LE, cmd_SH_en : in std_logic;
		   CU_h,CU_w:	in std_logic_vector(6 downto 0);
		   CE_final: in std_logic;
		   CE_final_OUT: out std_logic;
		   MVP0,MVP1,MVP2: out motion_vector(0 to 1)); --0:h,1:v
end entity;

architecture structural of constructor is

	--MV_in Pipe
	constant PIPE_DEPTH: integer := 14;
	signal MV0_int_h, MV1_int_h, MV2_int_h: motion_vector (PIPE_DEPTH downto 0);
	signal MV0_int_v, MV1_int_v, MV2_int_v: motion_vector (PIPE_DEPTH downto 0);
	signal RST1, RST2: std_logic;--RST1 is for the first 2 registers, RST2 for the others
	signal LE1, LE2, LE3: std_logic; --LE1 for the first 2 registers, LE3 for the last one, LE2 for the middle ones

	--Sub1
	constant SUB1_DEPTH: integer := 4;
	signal mv1v_mv0v_int, mv1h_mv0h_int: slv_12(SUB1_DEPTH downto 0);

	--H OVER W
	signal CU_h_int, CU_w_int: std_logic_vector(1 downto 0);
	signal SH_cmd_int: std_logic_vector(2 downto 0);

	--LR_SH2
	signal diff_mult_v_int, diff_mult_h_int : slv_14(1 downto 0);
	signal MV0_int_h_ext, MV0_int_v_ext: slv_14(1 downto 0);

	--SUBD
	signal MV2p_int_h, MV2p_int_v, MV2_int_h_ext, MV2_int_v_ext: slv_15(1 downto 0);

	--Squarer	
	signal D_h_tmp   ,D_v_tmp:    std_logic_vector(15 downto 0);
	signal D_h   ,D_v:    std_logic_vector(14 downto 0);

	--D_adder
	signal D_h_sq_tmp,D_v_sq_tmp: std_logic_vector(29 downto 0);
	signal D_h_sq,D_v_sq: std_logic_vector(26 downto 0);
	signal D_sq: std_logic_vector(27 downto 0);

	--if_UA block
	constant if_UA_DEPTH: integer := 10;
	signal UA_flag: std_logic_vector(2 downto 0);		--Generated by each if_UA block
	signal UA_flag_int: std_logic_vector(if_UA_DEPTH downto 0);	--Propagated through the pipeline

	--Final stage
	constant CE_FINAL_TARGET: integer := 19;
	signal D_sel, comp_out, comp_out_d: std_logic;
	signal D_Cur_tmp, D_Cur, D_D, D_min, D_comp: std_logic_vector(27 downto 0);

begin


----Left branch

------L_SUB1
	L_sub1: subtractor
		generic map(N=>11)
		port map(MV1_int_v(1),MV0_int_v(1),mv1v_mv0v_int(0));

	--I need to separate the first register from the other ones since the first one has a different reset (due to the CU delay)
	mv1v_mv0v_REG_0: REG_N
			generic map(N=>12)
			port map (D=>mv1v_mv0v_int(0),RST=>'0',clk=>clk,Q=>mv1v_mv0v_int(1));

	mv1v_mv0v_delay: for I in 2 to SUB1_DEPTH generate
		mv1v_mv0v_REG_X: REG_N
			generic map(N=>12)
			port map (D=>mv1v_mv0v_int(I-1),RST=>RST,clk=>clk,Q=>mv1v_mv0v_int(I));
	end generate mv1v_mv0v_delay;

------H OVER W

	h_sample: REG_N
		generic map(N=>2)
		port map(D=>CU_h(6 downto 5), RST=>'0',clk=>clk,Q=>CU_h_int);
	w_sample: REG_N
		generic map(N=>2)
		port map(D=>CU_w(6 downto 5), RST=>'0',clk=>clk,Q=>CU_w_int);
	
	hOw: h_over_w
		port map(h=>CU_h_int,w=>CU_w_int,clk=>clk, RSH_LE=>RSH_LE, cmd_SH_EN=>cmd_SH_EN, SH_cmd=>SH_cmd_int);

------L_LR_SH2

	L_LR_SH2: LR_SH2
		port map(shift_dir=>SH_cmd_int(2),shift_amt=>SH_cmd_int(1 downto 0),MV1_MV0=>mv1v_mv0v_int(SUB1_DEPTH),RST=>RST,clk=>clk,diff_mult=>diff_mult_v_int(0));

	diff_mult_v_int_samp: REG_N
		generic map(N=>14)
		port map(D=>diff_mult_v_int(0),Q=>diff_mult_v_int(1),RST=>RST,clk=>clk);

------L_SUB2

	L_MV0_h_ext: sign_extender
		generic map(N_in=>11, N_out=>14)
		port map(MV0_int_h(7),MV0_int_h_ext(0));

	MV0_int_h_ext_sample: REG_N
		generic map(N=>14)
		port map(D=>MV0_int_h_ext(0),Q=>MV0_int_h_ext(1),RST=>RST,clk=>clk);

	L_sub2: subtractor
		generic map(N=>14)
		port map(MV0_int_h_ext(1),diff_mult_v_int(1),MV2p_int_h(0));

	L_MV2_h_ext: sign_extender
		generic map(N_in=>11, N_out=>15)
		port map(MV2_int_h(8),MV2_int_h_ext(0));

------L_SUBD

	MV2p_int_h_sample: REG_N
		generic map(N=>15)
		port map(D=>MV2p_int_h(0),Q=>MV2p_int_h(1),RST=>RST,clk=>clk);

	MV2_int_h_ext_sample: REG_N
		generic map(N=>15)
		port map(D=>MV2_int_h_ext(0),Q=>MV2_int_h_ext(1),RST=>RST,clk=>clk);

	L_subD: subtractor
		generic map(N=>15)
		port map(MV2p_int_h(1),MV2_int_h_ext(1),D_h_tmp);

------L_Squarer
	
	D_h_sample: REG_N
		generic map(N=>15)
		port map (D=>D_h_tmp(14 downto 0),Q=>D_h,RST=>RST,clk=>clk);

	L_squarer: multiplier
		generic map(N=>15)
		port map(D_h,D_h,D_h_sq_tmp);

----Right branch

------R_SUB1
	R_sub1: subtractor
		generic map(N=>11)
		port map(MV1_int_h(1),MV0_int_h(1),mv1h_mv0h_int(0));

	--I need to separate the first register from the other ones since the first one has a different reset (due to the CU delay)
	mv1h_mv0h_REG_0: REG_N
			generic map(N=>12)
			port map (D=>mv1h_mv0h_int(0),RST=>'0',clk=>clk,Q=>mv1h_mv0h_int(1));

	mv1h_mv0h_delay: for I in 2 to SUB1_DEPTH generate
		mv1h_mv0h_REG_X: REG_N
			generic map(N=>12)
			port map (D=>mv1h_mv0h_int(I-1),RST=>RST,clk=>clk,Q=>mv1h_mv0h_int(I));
	end generate mv1h_mv0h_delay;

------R_LR_SH2

	R_LR_SH2: LR_SH2
		port map(shift_dir=>SH_cmd_int(2),shift_amt=>SH_cmd_int(1 downto 0),MV1_MV0=>mv1h_mv0h_int(SUB1_DEPTH),RST=>RST,clk=>clk,diff_mult=>diff_mult_h_int(0));

	diff_mult_h_int_samp: REG_N
		generic map(N=>14)
		port map(D=>diff_mult_h_int(0),Q=>diff_mult_h_int(1),RST=>RST,clk=>clk);

------R_SUB2

	R_MV0_v_ext: sign_extender
		generic map(N_in=>11, N_out=>14)
		port map(MV0_int_v(7),MV0_int_v_ext(0));

	MV0_int_v_ext_sample: REG_N
		generic map(N=>14)
		port map(D=>MV0_int_v_ext(0),Q=>MV0_int_v_ext(1),RST=>RST,clk=>clk);

	R_sub2: subtractor
		generic map(N=>14)
		port map(MV0_int_v_ext(1),diff_mult_h_int(1),MV2p_int_v(0));

	R_MV2_v_ext: sign_extender
		generic map(N_in=>11, N_out=>15)
		port map(MV2_int_v(8),MV2_int_v_ext(0));

------R_SUBD

	MV2p_int_v_sample: REG_N
		generic map(N=>15)
		port map(D=>MV2p_int_v(0),Q=>MV2p_int_v(1),RST=>RST,clk=>clk);

	MV2_int_v_ext_sample: REG_N
		generic map(N=>15)
		port map(D=>MV2_int_v_ext(0),Q=>MV2_int_v_ext(1),RST=>RST,clk=>clk);

	R_subD: subtractor
		generic map(N=>15)
		port map(MV2p_int_v(1),MV2_int_v_ext(1),D_v_tmp);

------R_Squarer
	
	D_v_sample: REG_N
		generic map(N=>15)
		port map (D=>D_v_tmp(14 downto 0),Q=>D_v,RST=>RST,clk=>clk);

	R_squarer: multiplier
		generic map(N=>15)
		port map(D_v,D_v,D_v_sq_tmp);

----IF_UA block
	MV0_check: if_UA
		port map(MV_in_h=>MV0_int_h(1),MV_in_v=>MV0_int_v(1),UA_flag=>UA_flag(0));

	MV1_check: if_UA
		port map(MV_in_h=>MV1_int_h(1),MV_in_v=>MV1_int_v(1),UA_flag=>UA_flag(1));

	MV2_check: if_UA
		port map(MV_in_h=>MV2_int_h(1),MV_in_v=>MV2_int_v(1),UA_flag=>UA_flag(2));

	UA_flag_int(0)<= UA_flag(0) OR UA_flag(1) OR UA_flag(2);

	UA_flag_1st_delay: FlFl
		port map(D=>UA_flag_int(0),Q=>UA_flag_int(1),RST=>'0',clk=>clk);

	UA_flag_delay: for I in 2 to if_UA_DEPTH generate
		UA_flag_delay_FFX: FlFl
			port map(D=>UA_flag_int(I-1),Q=>UA_flag_int(I),RST=>RST,clk=>clk);
	end generate;

----Final adder and comparator

	D_h_sq_sample: REG_N
		generic map(N=>27)
		port map(D=>D_h_sq_tmp(26 downto 0),Q=>D_h_sq,RST=>RST,clk=>clk);

	D_v_sq_sample: REG_N
		generic map(N=>27)
		port map(D=>D_v_sq_tmp(26 downto 0),Q=>D_v_sq,RST=>RST,clk=>clk);

	D_adder: adder
		generic map(N=>27)
		port map(D_h_sq,D_v_sq,D_sq);

	D_sel<=UA_flag_int(if_UA_DEPTH);
	D_Cur_tmp <= D_sq WHEN (D_sel='0') ELSE (others => '1');

	D_Cur_tmp_sample: REG_N
		generic map(N=>28)
		port map(D=>D_Cur_tmp,Q=>D_Cur,RST=>RST,clk=>clk);

	D_D_register: REG_N
		generic map(N=>28)
		port map(D=>D_Cur,Q=>D_D,RST=>RST,clk=>clk);

	D_min_register: REG_N_LE
		generic map(N=>28)
		port map(D=>D_D,Q=>D_min,RST=>RST,clk=>clk,LE=>comp_out_d);

	D_comp<= D_min WHEN (comp_out_d='0') ELSE D_D;

	final_comp: comparator
		generic map(N=>28)
		port map(D_comp,D_Cur,comp_out);

	comp_out_d_ff: FlFl
		port map(D=>comp_out,Q=>comp_out_d,RST=>RST,clk=>clk);

----COUNT FINAL
	COUNT_Final: COUNT_N
		generic map(N=>5,TARGET=>CE_FINAL_TARGET)
		port map(CE=>CE_final,RST=>RST,clk=>clk,COUNT_OUT=>CE_final_OUT);

------------------------------- MOTION VECTOR PIPELINE
----MV_iN Pipe v
	--La profondità della pipeline è pari a 14, ma in realta' io ho 12 candidati. Agendo sui LE dei vari registri potrei ridurre il numero minimo
	--di registiri necessario a 12. Il risparmio pero' sarebbe di due soli registri, quindi per il momento non aggiungo questa complicazione.
	MV0_int_v(0)<=MV0(0);
	MV1_int_v(0)<=MV1(0);
	MV2_int_v(0)<=MV2(0);

	--First and Second (registers)
	FaS_generate0_v: for I in 1 to 2 generate	
		FaS_registers0_v: MV_RF
			port map(MV_in=>MV0_int_v(I-1), clk=>clk, RST=>RST1, LE=>LE1, MV_out=>MV0_int_v(I));
	end generate;
	FaS_generate1_v: for I in 1 to 2 generate	
		FaS_registers1_v: MV_RF
			port map(MV_in=>MV1_int_v(I-1), clk=>clk, RST=>RST1, LE=>LE1, MV_out=>MV1_int_v(I));
	end generate;
	FaS_generate2_v: for I in 1 to 2 generate	
		FaS_registers2_v: MV_RF
			port map(MV_in=>MV2_int_v(I-1), clk=>clk, RST=>RST1, LE=>LE1, MV_out=>MV2_int_v(I));
	end generate;

	--Middle (registers)
	Middle_generate_v0: for I in 3 to PIPE_DEPTH-1 generate	
		Middle_registers0_v: MV_RF
			port map(MV_in=>MV0_int_v(I-1), clk=>clk, RST=>RST2, LE=>LE2, MV_out=>MV0_int_v(I));
	end generate;
	Middle_generate1_v: for I in 3 to PIPE_DEPTH-1 generate	
		Middle_registers1_v: MV_RF
			port map(MV_in=>MV1_int_v(I-1), clk=>clk, RST=>RST2, LE=>LE2, MV_out=>MV1_int_v(I));
	end generate;
	Middle_generate2_v: for I in 3 to PIPE_DEPTH-1 generate	
		Middle_registers2_v: MV_RF
			port map(MV_in=>MV2_int_v(I-1), clk=>clk, RST=>RST2, LE=>LE2, MV_out=>MV2_int_v(I));
	end generate;

	--Last register
	Last_register0_v: MV_RF
		port map(MV_in=>MV0_int_v(PIPE_DEPTH-1), clk=>clk, RST=>RST2, LE=>LE3, MV_out=>MV0_int_v(PIPE_DEPTH));
	Last_register1_v: MV_RF
		port map(MV_in=>MV1_int_v(PIPE_DEPTH-1), clk=>clk, RST=>RST2, LE=>LE3, MV_out=>MV1_int_v(PIPE_DEPTH));
	Last_register2_v: MV_RF
		port map(MV_in=>MV2_int_v(PIPE_DEPTH-1), clk=>clk, RST=>RST2, LE=>LE3, MV_out=>MV2_int_v(PIPE_DEPTH));



----MV_iN Pipe h
	MV0_int_h(0)<=MV0(0);
	MV1_int_h(0)<=MV1(0);
	MV2_int_h(0)<=MV2(0);

	--First and Second (registers)
	FaS_generate0_h: for I in 1 to 2 generate	
		FaS_registers0_h: MV_RF
			port map(MV_in=>MV0_int_h(I-1), clk=>clk, RST=>RST1, LE=>LE1, MV_out=>MV0_int_h(I));
	end generate;
	FaS_generate1_h: for I in 1 to 2 generate	
		FaS_registers1_h: MV_RF
			port map(MV_in=>MV1_int_h(I-1), clk=>clk, RST=>RST1, LE=>LE1, MV_out=>MV1_int_h(I));
	end generate;
	FaS_generate2_h: for I in 1 to 2 generate	
		FaS_registers2_h: MV_RF
			port map(MV_in=>MV2_int_h(I-1), clk=>clk, RST=>RST1, LE=>LE1, MV_out=>MV2_int_h(I));
	end generate;

	--Middle (registers)
	Middle_generate0_h: for I in 3 to PIPE_DEPTH-1 generate	
		Middle_registers0_h: MV_RF
			port map(MV_in=>MV0_int_h(I-1), clk=>clk, RST=>RST2, LE=>LE2, MV_out=>MV0_int_h(I));
	end generate;
	Middle_generate1_h: for I in 3 to PIPE_DEPTH-1 generate	
		Middle_registers1: MV_RF
			port map(MV_in=>MV1_int_h(I-1), clk=>clk, RST=>RST2, LE=>LE2, MV_out=>MV1_int_h(I));
	end generate;
	Middle_generate2_h: for I in 3 to PIPE_DEPTH-1 generate	
		Middle_registers2: MV_RF
			port map(MV_in=>MV2_int_h(I-1), clk=>clk, RST=>RST2, LE=>LE2, MV_out=>MV2_int_h(I));
	end generate;

	--Last register
	Last_register0_h: MV_RF
		port map(MV_in=>MV0_int_h(PIPE_DEPTH-1), clk=>clk, RST=>RST2, LE=>LE3, MV_out=>MV0_int_h(PIPE_DEPTH));
	Last_register1_h: MV_RF
		port map(MV_in=>MV1_int_h(PIPE_DEPTH-1), clk=>clk, RST=>RST2, LE=>LE3, MV_out=>MV1_int_h(PIPE_DEPTH));
	Last_register2_h: MV_RF
		port map(MV_in=>MV2_int_h(PIPE_DEPTH-1), clk=>clk, RST=>RST2, LE=>LE3, MV_out=>MV2_int_h(PIPE_DEPTH));

	--RST1 is for the first 2 registers, RST2 for the others
	RST1<='0';
	RST2<=RST;
	--LE1 for the first 2 registers, LE3 for the last one, LE2 for the middle ones
	LE1<='1';
	LE2<='1';
	--LE3 is the load enable for the last MV register, which loads the result
	LE3<=comp_out_d;
	--Outputs
	MVP0(0)<=MV0_int_h(PIPE_DEPTH);
	MVP0(1)<=MV0_int_v(PIPE_DEPTH);
	MVP1(0)<=MV1_int_h(PIPE_DEPTH);
	MVP1(1)<=MV1_int_v(PIPE_DEPTH);
	MVP2(0)<=MV2_int_h(PIPE_DEPTH);
	MVP2(1)<=MV2_int_v(PIPE_DEPTH);

end architecture structural;
