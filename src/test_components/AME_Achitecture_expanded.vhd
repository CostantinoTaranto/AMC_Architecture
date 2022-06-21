library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.AMEpkg.all;

entity AME_Architecture_expanded is
	port ( cMV0_in, cMV1_in, cMV2_in: in motion_vector(1 downto 0);--Constructor motion vectors (0:h, 1:v)
		   START: in std_logic; --constructor's "START"
		   CU_h, CU_w: in std_logic_vector(6 downto 0);
		   clk, RST: in std_logic;
		   cREADY: out std_logic; --constructor's READY
		   VALID: in std_logic; --extimator's VALID
		   eMV0_in, eMV1_in, eMV2_in: in motion_vector(1 downto 0);--Extimator motion vectors (0:h, 1:v)
		   sixPar : in std_logic;
		   eIN_SEL : in std_logic; --extimator input selector: 0: from VTM, 1: form constructor
		   RefPel, CurPel: in slv_8(3 downto 0);
		   RADDR_RefCu_x, RADDR_RefCu_y: out std_logic_vector(12 downto 0);
		   RADDR_CurCu_x, RADDR_CurCu_y: out std_logic_vector(5 downto 0);
		   MEM_RE: out std_logic; --Memory Read Enable
		   eREADY: out std_logic; --extimator's READY
		   eDONE: out std_logic;  --extimator's DONE
		   MV0_out, MV1_out, MV2_out: out motion_vector(1 downto 0); --Extimation result
		   --For the output checker
		   cComp_EN, cDONE, eComp_EN: out std_logic;
		   MVP0, MVP1, MVP2: out motion_vector(1 downto 0);
		   CurSAD: out std_logic_vector(17 downto 0);
		   D_Cur: out std_logic_vector(27 downto 0);
		   --Expanded part
		   last_block_x, last_block_y: out std_logic;
		   last_cand, Second_ready, CountTerm_OUT: out std_logic;
		   INTER_DATA_VALID_SET, INTER_DATA_VALID_RESET: out std_logic;
		   ADD3_MVin_LE_fSET, ADD3_MVin_LE_nSET, ADD3_MVin_LE_fRESET: out std_logic;
		   LE_ab, SAD_tmp_RST, Comp_EN, OUT_LE, CountTerm_EN, CandCount_CE, RF_in_RE: out std_logic;
		   BestCand: out std_logic;
		   MULT1_VALID, ADD3_VALID, incrY: out std_logic;
		   ADD3_MVin_LE: out std_logic
		);
end entity;

architecture structural of AME_Architecture_expanded is

	component constructor is
	port( MV0,MV1,MV2: in motion_vector(1 downto 0); --0:h,1:v
		  CU_h, CU_W: in std_logic_vector(6 downto 0);
		  START, GOT, clk, CU_RST: in std_logic;
		  READY, DONE: out std_logic;
		  MVP0,MVP1,MVP2: out motion_vector(1 downto 0); --MV Prediction
		  --For the output checker
		  cComp_EN: out std_logic;
		  D_Cur: out std_logic_vector(27 downto 0)
		);
	end component;

	component extimator_expanded is
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
			  ADD3_MVin_LE: out std_logic
		);
	end component;

	signal GOT_int, VALID_CONST_int : std_logic;
	signal cMVP0, cMVP1, cMVP2: motion_vector(1 downto 0);
	signal eMV0_in_int, eMV1_in_int, eMV2_in_int: motion_vector(1 downto 0);--Extimator motion vectors (0:h, 1:v)

begin

	constructing_unit: constructor
		port map ( cMV0_in, cMV1_in, cMV2_in, CU_h, CU_w, START, GOT_int, clk, RST, cREADY, VALID_CONST_int, cMVP0, cMVP1, cMVP2, cComp_EN, D_Cur);
	
	extimating_unit: extimator_expanded
		port map ( VALID, VALID_CONST_int, eMV0_in_int, eMV1_in_int, eMV2_in_int, CU_h, CU_w, sixPar, clk, RST, RefPel, CurPel, RADDR_RefCu_x, RADDR_RefCu_y,
				   RADDR_CurCu_x, RADDR_CurCu_y, MEM_RE, eREADY, GOT_int, MV0_out, MV1_out, MV2_out, eDONE, eComp_EN, CurSAD, last_block_x, last_block_y, last_cand,
				   Second_ready, CountTerm_OUT, INTER_DATA_VALID_SET, INTER_DATA_VALID_RESET, ADD3_MVin_LE_fSET, ADD3_MVin_LE_nSET, ADD3_MVin_LE_fRESET, LE_ab, SAD_tmp_RST,
				   Comp_EN, OUT_LE, CountTerm_EN, CandCount_CE, RF_in_RE, BestCand, MULT1_VALID, ADD3_VALID, incrY, ADD3_MVin_LE );
	
	eMV0_in_int<= eMV0_in when eIN_SEL='0' else cMVP0;
	eMV1_in_int<= eMV1_in when eIN_SEL='0' else cMVP1;
	eMV2_in_int<= eMV2_in when eIN_SEL='0' else cMVP2;
	
	--For the output checker
	cDONE<=VALID_CONST_int;
	MVP0<=cMVP0;
	MVP1<=cMVP1;
	MVP2<=cMVP2;
	
end architecture structural;