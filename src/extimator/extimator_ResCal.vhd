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
		  clk, RST: in std_logic;
		  RefPel, CurPel: in slv_8(3 downto 0);
		  MV0_out, MV1_out, MV2_out: out motion_vector(1 downto 0);
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
	signal CurSAD_tmp: std_logic_vector(17 downto 0);
	

begin

------Absolute differences calculation
	Abs_diff_gen: for I in 0 to 3 generate
		Pel_sub_X: subtractor
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
			port map(Abs_Pel_diff_samp(I),Abs_Pel_diff_samp(I+1),PelAdd_stage1_out(I));
		PelAdd_stage1_out_reg: REG_N
			generic map(N=>9)
			port map(D=>PelAdd_stage1_out(I),Q=>PelAdd_stage1_out_samp(I),clk=>clk,RST=>RST);
	end generate;
	
	PelAdd_stage2: unsigned_adder
		generic map(N=>9)
		port map(D=>PelAdd_stage1_out_samp(0),Q=>PelAdd_stage1_out_samp(1),PelAdd_out);
	CurRowSAD_reg: REG_N
		generic map(N=>10)
		port map(D=>PelAdd_out,Q=>CurRowSAD,clk=>clk,RST=>RST);

------CurSAD calculation
	CurRowSAD_ext<= "00000000" & CurRowSAD;
	CurSAD_tmp<=std_logic_vector(unsigned(CurRowSAD_ext)+unsigned(SAD_tmp)); --this is to be sampled
	

end architecture struct;