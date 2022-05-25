library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.AMEpkg.all;

entity constructor is
	port( MV0,MV1,MV2: in motion_vector(0 to 1); --0:h,1:v
		  CU_h, CU_W: in std_logic_vector(6 downto 0);
		  START, GOT, clk, CU_RST: in std_logic;
		  READY, DONE: out std_logic;
		  MVP0,MVP1,MVP2: out motion_vector(0 to 1) --MV Prediction
		);
end entity;

architecture structural of constructor is

	component CU_constructor is
	port ( START, GOT, CE_final_OUT: in std_logic;
		   clk, CU_RST: in std_logic;
		   RST, RSH_LE, cmd_SH_EN, READY, DONE, CE_final: out std_logic);
	end component;

	component DP_constructor is
		port ( MV0,MV1,MV2: in motion_vector(0 to 1); --0:h,1:v
			   clk, RST, RSH_LE, cmd_SH_en : in std_logic;
			   CU_h,CU_w:	in std_logic_vector(6 downto 0);
			   CE_final: in std_logic;
			   CE_final_OUT: out std_logic;
			   MVP0,MVP1,MVP2: out motion_vector(0 to 1)); --0:h,1:v
	end component;

	signal CE_final_OUT_int,RST_int,RSH_LE_int,cmd_SH_EN_int: std_logic;
	signal CE_final_int: std_logic;

begin

	Control_Unit: CU_constructor
		port map(START=>START,GOT=>GOT,CE_final_OUT=>CE_final_OUT_int,clk=>clk,CU_RST=>CU_RST,RST=>RST_int,RSH_LE=>RSH_LE_int,
				 cmd_SH_EN=>cmd_SH_EN_int,READY=>READY,DONE=>DONE,CE_final=>CE_final_int);

	Datapath: DP_constructor
		port map(MV0=>MV0,MV1=>MV1,MV2=>MV2,clk=>clk,RST=>RST_int,RSH_LE=>RSH_LE_int,cmd_SH_en=>cmd_SH_EN_int,CU_h=>CU_h,CU_w=>CU_w,
				CE_final=>CE_final_int,CE_final_OUT=>CE_final_OUT_int,MVP0=>MVP0,MVP1=>MVP1,MVP2=>MVP2);

end architecture structural;





