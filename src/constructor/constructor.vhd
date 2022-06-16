library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.AMEpkg.all;

entity constructor is
	port( MV0,MV1,MV2: in motion_vector(1 downto 0); --0:h,1:v
		  CU_h, CU_W: in std_logic_vector(6 downto 0);
		  START, GOT, clk, CU_RST: in std_logic;
		  READY, DONE: out std_logic;
		  MVP0,MVP1,MVP2: out motion_vector(1 downto 0) --MV Prediction
		);
end entity;

architecture structural of constructor is

	component CU_constructor is
		port ( START, GOT, CNT_compEN_OUT, CNT_STOPcompEN_OUT: in std_logic;
			   clk, CU_RST: in std_logic;
			   RST, RSH_LE, cmd_SH_EN, READY, DONE, CE_compEN, CE_STOPcompEN, compEN: out std_logic);
	end component;

	component DP_constructor is
		port ( MV0,MV1,MV2: in motion_vector(1 downto 0); --0:h,1:v
			   clk, RST, RSH_LE, cmd_SH_en : in std_logic;
			   CU_h,CU_w:	in std_logic_vector(6 downto 0);
			   CE_compEN, CE_STOPcompEN, compEN: in std_logic;
			   CNT_compEN_OUT, CNT_STOPcompEN_OUT: out std_logic;
			   MVP0,MVP1,MVP2: out motion_vector(1 downto 0)); --0:h,1:v
	end component;

	signal CNT_compEN_OUT_int,CNT_STOPcompEN_OUT_int,RST_int,RSH_LE_int,cmd_SH_EN_int: std_logic;
	signal CE_compEN_int, CE_STOPcompEN_int, compEN_int, DONE_int: std_logic;

begin

	Control_Unit: CU_constructor
		port map(START=>START,GOT=>GOT,CNT_compEN_OUT=>CNT_compEN_OUT_int,CNT_STOPcompEN_OUT=>CNT_STOPcompEN_OUT_int,
				clk=>clk,CU_RST=>CU_RST,RST=>RST_int,RSH_LE=>RSH_LE_int,
				 cmd_SH_EN=>cmd_SH_EN_int,READY=>READY,DONE=>DONE_int,CE_compEN=>CE_compEN_int,CE_STOPcompEN=>CE_STOPcompEN_int, compEN=>compEN_int);

	Datapath: DP_constructor
		port map(MV0=>MV0,MV1=>MV1,MV2=>MV2,clk=>clk,RST=>RST_int,RSH_LE=>RSH_LE_int,cmd_SH_en=>cmd_SH_EN_int,CU_h=>CU_h,CU_w=>CU_w,
				CE_compEN=>CE_compEN_int,CE_STOPcompEN=>CE_STOPcompEN_int,CNT_compEN_OUT=>CNT_compEN_OUT_int,
				CNT_STOPcompEN_OUT=>CNT_STOPcompEN_OUT_int,MVP0=>MVP0,MVP1=>MVP1,MVP2=>MVP2, compEN=>compEN_int);

	DONE<=DONE_int;

end architecture structural;





