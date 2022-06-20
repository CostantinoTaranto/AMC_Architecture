--Extimator Result Calculation Unit
--This unit takes as input the pixels, control signals and the "current MVs" and
--calculates the extimation

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


library work;
use work.AMEpkg.all;

entity extimator_ResCal is
	port( MV0_in, MV1_in, MV2_in: in motion_vector(1 downto 0);
		  clk, RST, SAD_tmp_RST, Comp_EN, OUT_LE, CountTerm_EN, CandCount_CE: in std_logic;
		  RefPel, CurPel: in slv_8(3 downto 0);
		  MV0_out, MV1_out, MV2_out: out motion_vector(1 downto 0);
		  BestCand, CountTerm_OUT, last_cand: out std_logic;
		  --For the output checker
		  CurSAD_out: out std_logic_vector(17 downto 0)		  
		 );

end entity;

architecture struct of extimator_ResCal is

	--Absolute differences calculation
	signal Pel_diff, Pel_diff_samp: slv_9(3 downto 0);
	signal Abs_Pel_diff, ABs_Pel_diff_samp: slv_8(3 downto 0);
	--CurRowSAD calculation (PelAdd)
	signal PelAdd_stage1_out, PelAdd_stage1_out_samp: slv_9(1 downto 0);
	signal PelAdd_out, CurRowSAD: std_logic_vector(9 downto 0);
	--CurSAD calculation
	signal CurRowSAD_ext, SAD_tmp: std_logic_vector(17 downto 0);
	signal CurSAD_tmp, CurSAD: std_logic_vector(17 downto 0);
	--Found_best calculation
	signal SAD_min: std_logic_vector(17 downto 0);
	signal ltmin: std_logic; --ltmin: "less than minumun (SAD)"
	signal Found_best: std_logic;
	--CurCand and Best_cand
	signal CurCand : std_logic;
	--Output register
	signal MV0_in_int, MV1_in_int, MV2_in_int: motion_vector(1 downto 0); 
	
	

begin

------Absolute differences calculation
	Abs_diff_gen: for I in 0 to 3 generate
		Pel_sub_X: unsigned_subtractor
			generic map(N=> 8)
			port map(RefPel(I),CurPel(I),Pel_diff(I));
		Pel_diff_reg: REG_N
			generic map(N=>9)
			port map(D=>Pel_diff(I),Q=>Pel_diff_samp(I),clk=>clk,RST=>RST);
		Abs_X: abs_unit
			generic map(N=>9)
			port map(abs_in=>Pel_diff_samp(I),abs_out=>Abs_Pel_diff(I));
		Abs_Pel_diff_reg: REG_N
			generic map(N=>8)
			port map(D=>Abs_Pel_diff(I),Q=>Abs_Pel_diff_samp(I),clk=>clk,RST=>RST);
	end generate;
	
------CurRowSAD calculation (PelAdd)
	
	PelAdd_stage1: for I in 0 to 1 generate
		PelAdd_stage1_X: unsigned_adder
			generic map(N=>8)
			port map(Abs_Pel_diff_samp(2*I),Abs_Pel_diff_samp(2*I+1),PelAdd_stage1_out(I));
		PelAdd_stage1_out_reg: REG_N
			generic map(N=>9)
			port map(D=>PelAdd_stage1_out(I),Q=>PelAdd_stage1_out_samp(I),clk=>clk,RST=>RST);
	end generate;
	
	PelAdd_stage2: unsigned_adder
		generic map(N=>9)
		port map(PelAdd_stage1_out_samp(0), PelAdd_stage1_out_samp(1), PelAdd_out);
	CurRowSAD_reg: REG_N
		generic map(N=>10)
		port map(D=>PelAdd_out,Q=>CurRowSAD,clk=>clk,RST=>RST);

------CurSAD calculation
	CurRowSAD_ext<= "00000000" & CurRowSAD;
	CurSAD_tmp<=std_logic_vector(unsigned(CurRowSAD_ext)+unsigned(SAD_tmp));

	SAD_tmp_reg: REG_N_sRST
		generic map(N=>18)
		port map(D=>CurSAD_tmp,Q=>SAD_tmp,sRST=>SAD_tmp_RST,clk=>clk);
	
	CurSAD_reg: REG_N
		generic map(N=>18)
		port map(D=>CurSAD_tmp,Q=>CurSAD,clk=>clk,RST=>RST);

------Found_best calculation
	
	SAD_comparator: comparator
		generic map(N=>18)
		port map(in_pos=>SAD_min,in_neg=>CurSAD,isGreater=>ltmin);

	Found_best<=ltmin AND Comp_EN;
	
	SAD_min_register: SAD_min_REG
		port map(D=>CurSAD,Q=>SAD_min,RST=>RST,clk=>clk,LE=>Found_best);

------CurCand and Best_cand
	
	CurCand_counter: FlFl_T
		port map(T=>Comp_EN,RST=>RST,clk=>clk,Q=>CurCand);
		
	BestCand_register: FlFl_LE
		port map(D=>CurCand,Q=>BestCand,clk=>clk,RST=>RST,LE=>Found_best);
		
------Terminal Counter and CandCount
	Terminal_counter: COUNT_N
		generic map(N=>5,TARGET=>18)
		port map(CE=>CountTerm_EN,RST=>RST,clk=>clk,COUNT_OUT=>CountTerm_OUT);
	
	--Notice that the number of candidates counted by "Candidate_counter" is just two,
	--this is why the flag "last_cand" coincides with the counter output. For an higher number
	--of candidates, this is no longer valid
	Candidate_counter: FlFl_T
		port map(T=>CandCount_CE,Q=>last_cand,RST=>RST,clk=>clk);
	

------Output register

	output_register: process(RST,clk)
	begin
		if RST='1' then
			MV0_in_int<= (others=>"00000000000");
			MV1_in_int<= (others=>"00000000000");
			MV2_in_int<= (others=>"00000000000");
		elsif rising_edge(clk) AND OUT_LE='1' then
			MV0_in_int<=MV0_in;
			MV1_in_int<=MV1_in;
			MV2_in_int<=MV2_in;
		--else
			--MV0_in_int<=MV0_in_int;
			--MV1_in_int<=MV1_in_int;
	        --MV2_in_int<=MV2_in_int;
		end if;
	end process;
		
	MV0_out<=MV0_in_int;
	MV1_out<=MV1_in_int;
	MV2_out<=MV2_in_int;

	--For the output checker
	CurSAD_out<=CurSAD;

end architecture struct;
