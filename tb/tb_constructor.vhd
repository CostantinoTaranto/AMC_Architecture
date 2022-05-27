library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.AMEpkg.all;

entity tb_constructor is
end entity;

architecture tb of tb_constructor is

	component constructor is
		port( MV0,MV1,MV2: in motion_vector(0 to 1); --0:h,1:v
			  CU_h, CU_W: in std_logic_vector(6 downto 0);
			  START, GOT, clk, CU_RST: in std_logic;
			  READY, DONE: out std_logic;
			  MVP0,MVP1,MVP2: out motion_vector(0 to 1) --MV Prediction
			);
	end component;
	
	--Constructor INPUT
	signal MV0_t,MV1_t,MV2_t:	motion_vector(0 to 1);
	signal CU_h_t,CU_w_t:		std_logic_vector(6 downto 0); 
	signal START_t, GOT_t, clk_t, CU_RST_t: std_logic;

	--Constructor OUTPUT
	signal READY_t, DONE_t: std_logic;
	signal MVP0_t, MVP1_t, MVP2_t: motion_vector(0 to 1);

	--clock
	signal clk: std_logic;
	constant Tc: time := 2 ns;

begin

	uut: constructor
		port map(MV0_t,MV1_t,MV2_t, CU_h_t,CU_w_t, START_t, GOT_t, clk, CU_RST_t, READY_t, DONE_t,MVP0_t,MVP1_t,MVP2_t);

	clock_gen: process
	begin
		clk<='0';
		wait for Tc/2;
		clk<='1';
		wait for Tc/2;
	end process;

	stimuli:process
	begin
		--Example 14 from "constrcution_examples-hardware.xlsx"
		wait for 3*Tc;
		CU_RST_t<='1';
		wait for Tc;
		CU_RST_t<='0';		
		wait for 5*Tc;
		CU_RST_t<='0';
		START_t<='1';
		GOT_t<='0';
		--1st triplet (1,1,1)
		CU_h_t	<=std_logic_vector(to_signed(32,CU_h_t'length));
		CU_w_t	<=std_logic_vector(to_signed(64,CU_h_t'length));
		MV0_t(0)<=std_logic_vector(to_signed(   -2,MV0_t(0)'length));
		MV0_t(1)<=std_logic_vector(to_signed(    32,MV0_t(0)'length));
		MV1_t(0)<=std_logic_vector(to_signed(   -90,MV0_t(0)'length));
		MV1_t(1)<=std_logic_vector(to_signed(   46,MV0_t(0)'length));
		MV2_t(0)<=std_logic_vector(to_signed(   -5,MV0_t(0)'length));
		MV2_t(1)<=std_logic_vector(to_signed(    -6,MV0_t(0)'length));
		wait for Tc;
		--2nd triplet (2,1,1)
		CU_h_t	<=std_logic_vector(to_signed(32,CU_h_t'length));
		CU_w_t	<=std_logic_vector(to_signed(64,CU_h_t'length));
		MV0_t(0)<=std_logic_vector(to_signed(   12,MV0_t(0)'length));
		MV0_t(1)<=std_logic_vector(to_signed(    44,MV0_t(0)'length));
		MV1_t(0)<=std_logic_vector(to_signed(   -90,MV0_t(0)'length));
		MV1_t(1)<=std_logic_vector(to_signed(   46,MV0_t(0)'length));
		MV2_t(0)<=std_logic_vector(to_signed(   -5,MV0_t(0)'length));
		MV2_t(1)<=std_logic_vector(to_signed(    -6,MV0_t(0)'length));
		wait for Tc;
		--3rd triplet (3,1,1)
		CU_h_t	<=std_logic_vector(to_signed(32,CU_h_t'length));
		CU_w_t	<=std_logic_vector(to_signed(64,CU_h_t'length));
		MV0_t(0)<=std_logic_vector(to_signed(   -5,MV0_t(0)'length));
		MV0_t(1)<=std_logic_vector(to_signed(    42,MV0_t(0)'length));
		MV1_t(0)<=std_logic_vector(to_signed(   -90,MV0_t(0)'length));
		MV1_t(1)<=std_logic_vector(to_signed(   46,MV0_t(0)'length));
		MV2_t(0)<=std_logic_vector(to_signed(   -5,MV0_t(0)'length));
		MV2_t(1)<=std_logic_vector(to_signed(    -6,MV0_t(0)'length));
		wait for Tc;
		--4th triplet (1,2,1)
		CU_h_t	<=std_logic_vector(to_signed(32,CU_h_t'length));
		CU_w_t	<=std_logic_vector(to_signed(64,CU_h_t'length));
		MV0_t(0)<=std_logic_vector(to_signed(   -2,MV0_t(0)'length));
		MV0_t(1)<=std_logic_vector(to_signed(    32,MV0_t(0)'length));
		MV1_t(0)<=std_logic_vector(to_signed(   192,MV0_t(0)'length));
		MV1_t(1)<=std_logic_vector(to_signed(   -64,MV0_t(0)'length));
		MV2_t(0)<=std_logic_vector(to_signed(   -5,MV0_t(0)'length));
		MV2_t(1)<=std_logic_vector(to_signed(    -6,MV0_t(0)'length));
		wait for Tc;
		--5th triplet (2,2,1)
		CU_h_t	<=std_logic_vector(to_signed(32,CU_h_t'length));
		CU_w_t	<=std_logic_vector(to_signed(64,CU_h_t'length));
		MV0_t(0)<=std_logic_vector(to_signed(   12,MV0_t(0)'length));
		MV0_t(1)<=std_logic_vector(to_signed(    44,MV0_t(0)'length));
		MV1_t(0)<=std_logic_vector(to_signed(   192,MV0_t(0)'length));
		MV1_t(1)<=std_logic_vector(to_signed(   -64,MV0_t(0)'length));
		MV2_t(0)<=std_logic_vector(to_signed(   -5,MV0_t(0)'length));
		MV2_t(1)<=std_logic_vector(to_signed(    -6,MV0_t(0)'length));
		wait for Tc;
		--6th triplet (3,2,1)
		CU_h_t	<=std_logic_vector(to_signed(32,CU_h_t'length));
		CU_w_t	<=std_logic_vector(to_signed(64,CU_h_t'length));
		MV0_t(0)<=std_logic_vector(to_signed(   -5,MV0_t(0)'length));
		MV0_t(1)<=std_logic_vector(to_signed(    42,MV0_t(0)'length));
		MV1_t(0)<=std_logic_vector(to_signed(   192,MV0_t(0)'length));
		MV1_t(1)<=std_logic_vector(to_signed(   -64,MV0_t(0)'length));
		MV2_t(0)<=std_logic_vector(to_signed(   -5,MV0_t(0)'length));
		MV2_t(1)<=std_logic_vector(to_signed(    -6,MV0_t(0)'length));
		wait for Tc;
		--7th triplet (1,1,2)
		CU_h_t	<=std_logic_vector(to_signed(32,CU_h_t'length));
		CU_w_t	<=std_logic_vector(to_signed(64,CU_h_t'length));
		MV0_t(0)<=std_logic_vector(to_signed(   -2,MV0_t(0)'length));
		MV0_t(1)<=std_logic_vector(to_signed(    32,MV0_t(0)'length));
		MV1_t(0)<=std_logic_vector(to_signed(   -90,MV0_t(0)'length));
		MV1_t(1)<=std_logic_vector(to_signed(   46,MV0_t(0)'length));
		MV2_t(0)<=std_logic_vector(to_signed(   -35,MV0_t(0)'length));
		MV2_t(1)<=std_logic_vector(to_signed(    -2,MV0_t(0)'length));
		wait for Tc;
		--8th triplet (2,1,2)
		CU_h_t	<=std_logic_vector(to_signed(32,CU_h_t'length));
		CU_w_t	<=std_logic_vector(to_signed(64,CU_h_t'length));
		MV0_t(0)<=std_logic_vector(to_signed(   12,MV0_t(0)'length));
		MV0_t(1)<=std_logic_vector(to_signed(    44,MV0_t(0)'length));
		MV1_t(0)<=std_logic_vector(to_signed(   -90,MV0_t(0)'length));
		MV1_t(1)<=std_logic_vector(to_signed(   46,MV0_t(0)'length));
		MV2_t(0)<=std_logic_vector(to_signed(   -35,MV0_t(0)'length));
		MV2_t(1)<=std_logic_vector(to_signed(    -2,MV0_t(0)'length));
		wait for Tc;
		--9th triplet (3,1,2)
		CU_h_t	<=std_logic_vector(to_signed(32,CU_h_t'length));
		CU_w_t	<=std_logic_vector(to_signed(64,CU_h_t'length));
		MV0_t(0)<=std_logic_vector(to_signed(   -5,MV0_t(0)'length));
		MV0_t(1)<=std_logic_vector(to_signed(    42,MV0_t(0)'length));
		MV1_t(0)<=std_logic_vector(to_signed(   -90,MV0_t(0)'length));
		MV1_t(1)<=std_logic_vector(to_signed(   46,MV0_t(0)'length));
		MV2_t(0)<=std_logic_vector(to_signed(   -35,MV0_t(0)'length));
		MV2_t(1)<=std_logic_vector(to_signed(    -2,MV0_t(0)'length));
		wait for Tc;
		--10th triplet (1,2,2)
		CU_h_t	<=std_logic_vector(to_signed(32,CU_h_t'length));
		CU_w_t	<=std_logic_vector(to_signed(64,CU_h_t'length));
		MV0_t(0)<=std_logic_vector(to_signed(   -2,MV0_t(0)'length));
		MV0_t(1)<=std_logic_vector(to_signed(    32,MV0_t(0)'length));
		MV1_t(0)<=std_logic_vector(to_signed(   192,MV0_t(0)'length));
		MV1_t(1)<=std_logic_vector(to_signed(   -64,MV0_t(0)'length));
		MV2_t(0)<=std_logic_vector(to_signed(   -35,MV0_t(0)'length));
		MV2_t(1)<=std_logic_vector(to_signed(    -2,MV0_t(0)'length));
		wait for Tc;
		--11th triplet (2,2,2)
		CU_h_t	<=std_logic_vector(to_signed(32,CU_h_t'length));
		CU_w_t	<=std_logic_vector(to_signed(64,CU_h_t'length));
		MV0_t(0)<=std_logic_vector(to_signed(   12,MV0_t(0)'length));
		MV0_t(1)<=std_logic_vector(to_signed(    44,MV0_t(0)'length));
		MV1_t(0)<=std_logic_vector(to_signed(   192,MV0_t(0)'length));
		MV1_t(1)<=std_logic_vector(to_signed(   -64,MV0_t(0)'length));
		MV2_t(0)<=std_logic_vector(to_signed(   -35,MV0_t(0)'length));
		MV2_t(1)<=std_logic_vector(to_signed(    -2,MV0_t(0)'length));
		wait for Tc;
		--12th triplet (3,2,2)
		CU_h_t	<=std_logic_vector(to_signed(32,CU_h_t'length));
		CU_w_t	<=std_logic_vector(to_signed(64,CU_h_t'length));
		MV0_t(0)<=std_logic_vector(to_signed(   -5,MV0_t(0)'length));
		MV0_t(1)<=std_logic_vector(to_signed(    42,MV0_t(0)'length));
		MV1_t(0)<=std_logic_vector(to_signed(   192,MV0_t(0)'length));
		MV1_t(1)<=std_logic_vector(to_signed(   -64,MV0_t(0)'length));
		MV2_t(0)<=std_logic_vector(to_signed(   -35,MV0_t(0)'length));
		MV2_t(1)<=std_logic_vector(to_signed(    -2,MV0_t(0)'length));

		wait;
	end process;
		

end architecture tb;
