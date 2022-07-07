library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.AMEpkg.all;

entity constructor_netlist_wrapper is
		port( MV0,MV1,MV2: in motion_vector(1 downto 0); --0:h,1:v
		  CU_h, CU_W: in std_logic_vector(6 downto 0);
		  START, GOT, clk, CU_RST: in std_logic;
		  READY, DONE: out std_logic;
		  MVP0,MVP1,MVP2: out motion_vector(1 downto 0); --MV Prediction
		  --For the output checker
		  cComp_EN: out std_logic;
		  D_Cur: out std_logic_vector(27 downto 0)
		);
end entity;

architecture structural of constructor_netlist_wrapper is

	component constructor is
			port( MV0,MV1,MV2: in std_logic_vector(21 downto 0); --0:h,1:v
		  CU_h, CU_W: in std_logic_vector(6 downto 0);
		  START, GOT, clk, CU_RST: in std_logic;
		  READY, DONE: out std_logic;
		  MVP0,MVP1,MVP2: out std_logic_vector(21 downto 0); --MV Prediction
		  --For the output checker
		  cComp_EN: out std_logic;
		  D_Cur: out std_logic_vector(27 downto 0)
		);
	end component;

	signal MV0_in_int, MV1_in_int, MV2_in_int: std_logic_vector(21 downto 0);
	signal MV0_out_int, MV1_out_int, MV2_out_int: std_logic_vector(21 downto 0); --Extimation result

begin

	--cMV(0,1,2)_int
	MV0_in_int(10 downto 0)<=MV0(0);
	MV0_in_int(21 downto 11)<=MV0(1);
	MV1_in_int(10 downto 0)<=MV1(0);
	MV1_in_int(21 downto 11)<=MV1(1);
	MV2_in_int(10 downto 0)<=MV2(0);
	MV2_in_int(21 downto 11)<=MV2(1);
	
	--MV(0,1,2)_out_int
	MVP0(0)<=MV0_out_int(10 downto 0);
	MVP0(1)<=MV0_out_int(21 downto 11);
	MVP1(0)<=MV1_out_int(10 downto 0);
	MVP1(1)<=MV1_out_int(21 downto 11);
	MVP2(0)<=MV2_out_int(10 downto 0);
	MVP2(1)<=MV2_out_int(21 downto 11);

	constructor_netlist : constructor
	port map( MV0_in_int,MV1_in_int,MV2_in_int,
		  CU_h, CU_W,
		  START, GOT, clk, CU_RST,
		  READY, DONE,
		  MV0_out_int,MV1_out_int,MV2_out_int,
		  --For the output checker
		  cComp_EN,
		  D_Cur
		);


end architecture structural;
