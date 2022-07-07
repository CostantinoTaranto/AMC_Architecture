library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.AMEpkg.all;

entity extimator_expanded_netlist_wrapper is
		port( VALID_VTM, VALID_CONST: in std_logic;	--The "Valid" signal can be supplied by the constructor or the VTM alternatively
			  MV0_in, MV1_in, MV2_in: in motion_vector(1 downto 0);--0:h, 1:v
			  CurCU_h, CurCU_w: in std_logic_vector(6 downto 0);
			  sixPar: in std_logic;
			  clk, CU_RST: in std_logic;
			  RefPel, CurPel: in slv_8(3 downto 0);
			  RADDR_RefCu_x, RADDR_RefCu_y: out std_logic_vector(12 downto 0);
			  RADDR_CurCu_x, RADDR_CurCu_y: out std_logic_vector(5 downto 0);
			  MEM_RE: out std_logic; --Memory Read Enable
			  extimator_READY, GOT: out std_logic;
			  MV0_out, MV1_out, MV2_out: out motion_vector(1 downto 0); --Extimation result
			  DONE: out std_logic;
			  --For the output checker
			  eComp_EN: out std_logic;
			  CurSAD: out std_logic_vector(17 downto 0);
			  --Expanded part
			  last_block_x, last_block_y: out std_logic;
			  last_cand, Second_ready, CountTerm_OUT: out std_logic;
			  INTER_DATA_VALID_SET, INTER_DATA_VALID_RESET: out std_logic;
			  ADD3_MVin_LE_fSET, ADD3_MVin_LE_nSET, ADD3_MVin_LE_fRESET: out std_logic;
			  LE_ab, SAD_tmp_RST, Comp_EN, OUT_LE, CountTerm_EN, CandCount_CE, RF_in_RE: out std_logic;
			  BestCand: out std_logic;
			  MULT1_VALID, ADD3_VALID, incrY: out std_logic;
			  ADD3_MVin_LE: out std_logic;
			  eCU_PS, eCU_NS: out std_logic_vector(4 downto 0)
		);
end entity;

architecture structural of extimator_expanded_netlist_wrapper is

	component extimator_expanded is
			port( VALID_VTM, VALID_CONST: in std_logic;	--The "Valid" signal can be supplied by the constructor or the VTM alternatively
		  MV0_in, MV1_in, MV2_in: in std_logic_vector(21 downto 0);--0:h, 1:v
		  CurCU_h, CurCU_w: in std_logic_vector(6 downto 0);
		  sixPar: in std_logic;
		  clk, CU_RST: in std_logic;
		  RefPel, CurPel: in std_logic_vector(31 downto 0);
		  RADDR_RefCu_x, RADDR_RefCu_y: out std_logic_vector(12 downto 0);
		  RADDR_CurCu_x, RADDR_CurCu_y: out std_logic_vector(5 downto 0);
		  MEM_RE: out std_logic; --Memory Read Enable
		  extimator_READY, GOT: out std_logic;
		  MV0_out, MV1_out, MV2_out: out std_logic_vector(21 downto 0); --Extimation result
		  DONE: out std_logic;
		  --For the output checker
		  eComp_EN: out std_logic;
		  CurSAD: out std_logic_vector(17 downto 0);
		  --Expanded part
		  last_block_x, last_block_y: out std_logic;
		  last_cand, Second_ready, CountTerm_OUT: out std_logic;
		  INTER_DATA_VALID_SET, INTER_DATA_VALID_RESET: out std_logic;
		  ADD3_MVin_LE_fSET, ADD3_MVin_LE_nSET, ADD3_MVin_LE_fRESET: out std_logic;
		  LE_ab, SAD_tmp_RST, Comp_EN, OUT_LE, CountTerm_EN, CandCount_CE, RF_in_RE: out std_logic;
		  BestCand: out std_logic;
		  MULT1_VALID, ADD3_VALID, incrY: out std_logic;
		  ADD3_MVin_LE: out std_logic;
		  eCU_PS, eCU_NS: out std_logic_vector(4 downto 0)
	);
	end component;

	signal MV0_in_int, MV1_in_int, MV2_in_int: std_logic_vector(21 downto 0);
	signal RefPel_int, CurPel_int: std_logic_vector(31 downto 0);
	signal MV0_out_int, MV1_out_int, MV2_out_int: std_logic_vector(21 downto 0); --Extimation result

begin

	--eMV(0,1,2)_int
	MV0_in_int(10 downto 0)<=MV0_in(0);
	MV0_in_int(21 downto 11)<=MV0_in(1);
	MV1_in_int(10 downto 0)<=MV1_in(0);
	MV1_in_int(21 downto 11)<=MV1_in(1);
	MV2_in_int(10 downto 0)<=MV2_in(0);
	MV2_in_int(21 downto 11)<=MV2_in(1);

	--RefPel_int
	RefPel_int(7 downto 0)<=RefPel(0);
	RefPel_int(15 downto 8)<=RefPel(1);
	RefPel_int(23 downto 16)<=RefPel(2);
	RefPel_int(31 downto 24)<=RefPel(3);

	--CurPel_int
	CurPel_int(7 downto 0)<=CurPel(0);
	CurPel_int(15 downto 8)<=CurPel(1);
	CurPel_int(23 downto 16)<=CurPel(2);
	CurPel_int(31 downto 24)<=CurPel(3);
	
	--MV(0,1,2)_out_int
	MV0_out(0)<=MV0_out_int(10 downto 0);
	MV0_out(1)<=MV0_out_int(21 downto 11);
	MV1_out(0)<=MV1_out_int(10 downto 0);
	MV1_out(1)<=MV1_out_int(21 downto 11);
	MV2_out(0)<=MV2_out_int(10 downto 0);
	MV2_out(1)<=MV2_out_int(21 downto 11);

	extimator_netlist : extimator_expanded
	port map( VALID_VTM, VALID_CONST,
		  MV0_in_int, MV1_in_int, MV2_in_int,
		  CurCU_h, CurCU_w,
		  sixPar,
		  clk, CU_RST,
		  RefPel_int, CurPel_int,
		  RADDR_RefCu_x, RADDR_RefCu_y,
		  RADDR_CurCu_x, RADDR_CurCu_y,
		  MEM_RE,
		  extimator_READY, GOT,
		  MV0_out_int, MV1_out_int, MV2_out_int,
		  DONE,
		  --For the output checker
		  eComp_EN,
		  CurSAD,
		  --Expanded part
		  last_block_x, last_block_y,
		  last_cand, Second_ready, CountTerm_OUT,
		  INTER_DATA_VALID_SET, INTER_DATA_VALID_RESET,
		  ADD3_MVin_LE_fSET, ADD3_MVin_LE_nSET, ADD3_MVin_LE_fRESET,
		  LE_ab, SAD_tmp_RST, Comp_EN, OUT_LE, CountTerm_EN, CandCount_CE, RF_in_RE,
		  BestCand,
		  MULT1_VALID, ADD3_VALID, incrY,
		  ADD3_MVin_LE,
		  eCU_PS, eCU_NS
	);


end architecture structural;
