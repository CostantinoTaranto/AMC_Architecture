--This component calculates the memory addresses for the motion extimation,
--given the motion vectors with the proper control signals

library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.AMEpkg.all;

entity extimator_AddCalc is
	port( VALID_VTM, VALID_CONST: in std_logic;	--The "Valid" signal can be supplied by the constructor or the VTM alternatively
		  MV0_in, MV1_in, MV2_in: in motion_vector(1 downto 0);--0:h, 1:v
		  CurCU_h, CurCU_w: in std_logic_vector(6 downto 0);
		  sixPar: in std_logic;
		  clk, CU_RST: in std_logic;
		  RADDR_RefCu_x, RADDR_RefCu_y: out std_logic_vector(12 downto 0);
		  RADDR_CurCu_x, RADDR_CurCu_y: out std_logic_vector(5 downto 0);
		  MEM_RE: out std_logic; --Memory Read Enable
		  extimator_READY: out std_logic
	);
end entity;

architecture structural of extimator_AddCalc is

	component extimator_PelRet is
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
	end component;

	component CU_extimator is
		port( VALID, last_block_x, last_block_y: in std_logic;
			  last_cand, Second_ready, CountTerm_OUT: in std_logic;
			  clk, CU_RST: in std_logic;
			  INTER_DATA_VALID_SET, INTER_DATA_VALID_RESET: out std_logic;
			  --INTER_DATA_VALID_(SET/RESET) is quite particular. When it is set, after 3 clock
			  --cycles the "intermediate data valid" is set. When it is reset, after 5 clock cycles it is reset.
			  --this signal feeds, with different timigs, "MULT1_VALID", "ADD3_VALID" and "incrY".
			  ADD3_MVin_LE_fSET, ADD3_MVin_LE_nSET, ADD3_MVin_LE_fRESET: out std_logic;
			  --ADD3_MVin_LE_(fSET,nSET,fRESET) are also three particular signals. "fSET" and "fRESET" (forced SET/RESET) force
			  --the LE to be IMMEDIATELY 1 or 0. "nSET" (normal SET) sets the LE to be 1 after 9 clock cycles.
			  READY_RST, RST1, RST2, CE_REPx, CE_BLKx, RST_BLKx, CE_REPy, CE_BLKy, RST_BLKy : out std_logic;
			  RF_Addr: out std_logic_vector(1 downto 0);
			  --RF_Addr selects the input for the RF_Addr, which is '0' when "00", '1' when "01" and 'Best_Cand' when "11"
			  LE_ab, SAD_tmp_RST, Comp_EN, OUT_LE, CountTerm_EN, CandCount_CE, RF_in_RE: out std_logic;
			  DONE: out std_logic		  
		);
	end component;

	component CU_Ready_Handler is
		port( VALID, Ready_RST: in std_logic;
			  clk, RST: in std_logic;
			  READY, Second_Ready, GOT: out std_logic
			);
	end component;

	component CU_extimator_adapter is
		port (	INTER_DATA_VALID_SET, INTER_DATA_VALID_RESET: in std_logic;
			  --INTER_DATA_VALID_(SET/RESET) is quite particular. When it is set, after 3 clock
			  --cycles the "intermediate data valid" is set. When it is reset, after 5 clock cycles it is reset.
			  --this signal feeds, with different timigs, "MULT1_VALID", "ADD3_VALID" and "incrY".
			  ADD3_MVin_LE_fSET, ADD3_MVin_LE_nSET, ADD3_MVin_LE_fRESET: in std_logic;
			  --ADD3_MVin_LE_(fSET,nSET,fRESET) are also three particular signals. "fSET" and "fRESET" (forced SET/RESET) force
			  --the LE to be IMMEDIATELY 1 or 0. "nSET" (normal SET) sets the LE to be 1 after 9 clock cycles.
			  RF_Addr_CU: in std_logic_vector(1 downto 0);
			  --RF_Addr selects the input for the RF_Addr, which is '0' when "00", '1' when "01" and 'Best_Cand' when "11"
			  LE_ab_CU, SAD_tmp_RST_CU, Comp_EN_CU: in std_logic;
			  BestCand: in std_logic;
			  clk, RST: in std_logic;
			  MULT1_VALID, ADD3_VALID, incrY, MEM_RE: out std_logic;
			  ADD3_MVin_LE: out std_logic;
			  RF_Addr_DP, LE_ab_DP, SAD_tmp_RST_DP, Comp_EN_DP: out std_logic
		);
	end component;

	--extimator PelRet
	signal RF_Addr_DP_int, RF_in_WE_int, RF_in_RE_int, MULT1_VALID_int, ADD3_MVin_LE_int, ADD3_VALID_int, incrY_int : std_logic;
	signal CE_REPx_int, CE_BLKx_int, RST_BLKx_int, CE_REPy_int, CE_BLKy_int, RST_BLKy_int, last_block_x_int, last_block_y_int: std_logic;
	signal RST1_int, RST2_int, LE_ab_DP_int: std_logic;
	signal MV0_out_int, MV1_out_int, MV2_out_int: motion_vector(1 downto 0);
	--Extimator CU
	signal VALID_int, Second_ready_int, INTER_DATA_VALID_SET_int, INTER_DATA_VALID_RESET_int: std_logic;
	signal ADD3_MVin_LE_fSET_int, ADD3_MVin_LE_nSET_int, ADD3_MVin_LE_fRESET_int, READY_RST_int: std_logic;
	signal RF_Addr_CU_int : std_logic_vector(1 downto 0);
	signal LE_ab_CU_int, SAD_tmp_RST_CU_int, Comp_EN_CU_int, OUT_LE_int, CountTerm_EN_int, CandCount_CE_int, DONE_int: std_logic;
	--Ready Handler
	signal READY_int, GOT_int: std_logic;
	--CU Adapter
	signal SAD_tmp_RST_DP_int, Comp_EN_DP_int: std_logic;

begin

	VALID_int<=VALID_VTM OR VALID_CONST;

	Pixel_Retrieval_Unit: extimator_PelRet
		port map( MV0_in=>MV0_in, MV1_in=>MV1_in, MV2_in=>MV2_in,
		   RF_Addr=>RF_Addr_DP_int, clk=>clk, RF_in_WE=>RF_in_WE_int, RF_in_RE=>RF_in_RE_int, MULT1_VALID=>MULT1_VALID_int, ADD3_MVin_LE=>ADD3_MVin_LE_int, ADD3_VALID=>ADD3_VALID_int, incrY=>incrY_int,
		   CE_REPx=>CE_REPx_int, CE_BLKx=>CE_BLKx_int, RST_BLKx=>RST_BLKx_int, CE_REPy=>CE_REPy_int, CE_BLKy=>CE_BLKy_int, RST_BLKy=>RST_BLKy_int,
		   last_block_x=>last_block_x_int, last_block_y=>last_block_y_int,
		   CurCU_h=>CurCU_h, CurCU_w=>CurCU_w,
		   sixPar=>sixPar,RST1=>RST1_int, RST2=>RST2_int, LE_ab=>LE_ab_DP_int,
		   RADDR_RefCu_x=>RADDR_RefCu_x, RADDR_RefCu_y=>RADDR_RefCu_y,
		   RADDR_CurCu_x=>RADDR_CurCu_x, RADDR_CurCu_y=>RADDR_CurCu_y,
		   MV0_out=>MV0_out_int, MV1_out=>MV1_out_int, MV2_out=>MV2_out_int);
	
	RF_in_WE_int<=VALID_int AND READY_int;
	
	extimator_CU: CU_extimator
		port map( VALID=>VALID_int, last_block_x=>last_block_x_int, last_block_y=>last_block_y_int,
			  last_cand=>'0', Second_ready=>Second_ready_int, CountTerm_OUT=>'0',
			  clk=>clk, CU_RST=>CU_RST,	INTER_DATA_VALID_SET=>INTER_DATA_VALID_SET_int, INTER_DATA_VALID_RESET=>INTER_DATA_VALID_RESET_int,
			  ADD3_MVin_LE_fSET=>ADD3_MVin_LE_fSET_int, ADD3_MVin_LE_nSET=>ADD3_MVin_LE_nSET_int, ADD3_MVin_LE_fRESET=>ADD3_MVin_LE_fRESET_int,
			  READY_RST=>READY_RST_int, RST1=>RST1_int, RST2=>RST2_int, CE_REPx=>CE_REPx_int, CE_BLKx=>CE_BLKx_int, RST_BLKx=>RST_BLKx_int, CE_REPy=>CE_REPy_int, CE_BLKy=>CE_BLKy_int, RST_BLKy=>RST_BLKy_int,
			  RF_Addr=>RF_Addr_CU_int, LE_ab=>LE_ab_CU_int, SAD_tmp_RST=>SAD_tmp_RST_CU_int, Comp_EN=>Comp_EN_CU_int, OUT_LE=>OUT_LE_int, CountTerm_EN=>CountTerm_EN_int, CandCount_CE=>CandCount_CE_int,
			  RF_in_RE=>RF_in_RE_int, DONE=>DONE_int);

	Ready_Handler: CU_Ready_Handler 
		port map( VALID=>VALID_int, Ready_RST=>Ready_RST_int, clk=>clk, RST=>CU_RST, READY=>READY_int, Second_Ready=>Second_Ready_int, GOT=>GOT_int);
	
	extimator_READY<=READY_int;

	CU_adapter:	CU_extimator_adapter
		port map(	INTER_DATA_VALID_SET=>INTER_DATA_VALID_SET_int, INTER_DATA_VALID_RESET=>INTER_DATA_VALID_RESET_int,
			  ADD3_MVin_LE_fSET=>ADD3_MVin_LE_fSET_int, ADD3_MVin_LE_nSET=>ADD3_MVin_LE_nSET_int, ADD3_MVin_LE_fRESET=>ADD3_MVin_LE_fRESET_int,
			  RF_Addr_CU=>RF_Addr_CU_int,
			  LE_ab_CU=>LE_ab_CU_int, SAD_tmp_RST_CU=>SAD_tmp_RST_CU_int, Comp_EN_CU=>Comp_EN_CU_int, BestCand=>'0',
			  clk=>clk, RST=>CU_RST,
			  MULT1_VALID=>MULT1_VALID_int, ADD3_VALID=>ADD3_VALID_int, incrY=>incrY_int, MEM_RE=>MEM_RE,
			  ADD3_MVin_LE=>ADD3_MVin_LE_int,
			  RF_Addr_DP=>RF_Addr_DP_int, LE_ab_DP=>LE_ab_DP_int, SAD_tmp_RST_DP=>SAD_tmp_RST_DP_int, Comp_EN_DP=>Comp_EN_DP_int
		);


end architecture structural;