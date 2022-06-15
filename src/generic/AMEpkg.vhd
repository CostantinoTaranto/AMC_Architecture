library IEEE;
use IEEE.std_logic_1164.all;

package AMEpkg is
-----TYPES
	type motion_vector is array (natural range <>) of std_logic_vector(10 downto 0);
	type slv_2  is array (natural range <>) of std_logic_vector(1  downto 0);
	type slv_6  is array (natural range <>) of std_logic_vector(5  downto 0);
	type slv_8  is array (natural range <>) of std_logic_vector(7  downto 0);
	type slv_9  is array (natural range <>) of std_logic_vector(8  downto 0);
	type slv_11 is array (natural range <>) of std_logic_vector(10 downto 0);
	type slv_12 is array (natural range <>) of std_logic_vector(11 downto 0);
	type slv_14 is array (natural range <>) of std_logic_vector(13 downto 0);
	type slv_15 is array (natural range <>) of std_logic_vector(14 downto 0);
	type slv_18 is array (natural range <>) of std_logic_vector(17 downto 0);
	type slv_20 is array (natural range <>) of std_logic_vector(19 downto 0);
	type slv_24 is array (natural range <>) of std_logic_vector(23 downto 0);
	
	--Extimator CU state type
	type CU_extimator_state is (ON_RESET,IDLE,SREP_WAIT2,SREP_WAIT3,SECOND_REP,TREP_WAIT1,TREP_WAIT2,TREP_WAIT3,THIRD_REP,FREP_WAIT1,FREP_WAIT2,FREP_WAIT3,
	FOURTH_REP,NB_WAIT1,NB_WAIT2,NB_WAIT3,NEW_LINE,NEXT_BLOCK,TERM_CANDIDATE1,SREP_WAIT1,SREP_WAIT1_NEW_CANDIDATE,SECOND_CANDIDATE_WAIT,TERM_LAST_CAND,WAIT_FOR_COUNT,READ_BEST_CAND,WRITE_BEST_CAND,EXTIMATE);

-----COMPONENTS
	component subtractor is
	generic ( N: integer);
	port 	( minuend, subtrahend:	in std_logic_vector(N-1 downto 0);
		  subtraction:		out std_logic_vector(N downto 0));
	end component;
	
	component unsigned_subtractor is
		generic ( N: integer);
		port 	( minuend, subtrahend:	in std_logic_vector(N-1 downto 0);
			  subtraction:		out std_logic_vector(N downto 0));
	end component;

	component sign_extender is
		generic ( N_in, N_out: integer);
		port	( toExtend: in std_logic_vector( N_in-1 downto 0);
				  extended: out std_logic_vector( N_out-1 downto 0));
	end component;

	component h_over_w is
		port ( h,w:   in std_logic_vector  (1 downto 0);
			   clk, RSH_LE, cmd_SH_EN: in std_logic;
			   SH_cmd:out std_logic_vector (2 downto 0));
	end component;

	component adder is
		generic ( N: integer);
		port	( op1, op2:	in std_logic_vector(N-1 downto 0);
				  sum:		out std_logic_vector(N downto 0));
	end component;

	component multiplier is
		generic ( N: integer);
		port 	( op1, op2:	in std_logic_vector(N-1 downto 0);
			  product:		out std_logic_vector((2*N)-1 downto 0));
	end component;

	component comparator is
		generic ( N: integer);
		port	( in_pos, in_neg:	in std_logic_vector(N-1 downto 0);
				  isGreater:		out std_logic);
	end component;

	--Notice that when a single MV has to be handled the classic "std_logic_vector(10 downto 0)"
	--is used instead of "motion_vector" type. There is no problem in connecting the two types, you
	--can simply specify "motion_vector(0)<=std_logic_vector(10 downto 0)"
	component MV_RF is
		port( MV_in:  in  std_logic_vector(10 downto 0);	
			  clk, RST, LE: std_logic;
			  MV_out: out std_logic_vector(10 downto 0)
			);
	end component;

	component MVin_pipe is
		generic (N: integer);	--The number of stages, tunable in case of error/changes
		port ( MV: in motion_vector(2 downto 0); --MV0, MV1, MV2
			   clk: in std_logic;
			   RST1, RST2: in std_logic; --RST1 is for the first 2 registers, RST2 for the others
			   LE1, LE2, LE3: in std_logic; --LE1 for the first 2 registers, LE3 for the last one, LE2 for the middle ones
			   MVP: out motion_vector (2 downto 0) --The predictions
			);
	end component;

	component FlFl is
		port (D, RST, clk: in std_logic;
			  Q: out std_logic);
	end component;

	component REG_N is
		generic (N: integer);
		port (D: in std_logic_vector (N-1 downto 0);
			  RST, clk: in std_logic;
			  Q: out std_logic_vector (N-1 downto 0));
	end component;

	component REG_N_LE is
		generic (N: integer);
		port( D:  in  std_logic_vector(N-1 downto 0);	
			  clk, RST, LE: std_logic;
			  Q: out std_logic_vector(N-1 downto 0)
			);
	end component;

	component LR_SH2 is
		port ( shift_dir: in std_logic;
			   shift_amt: in std_logic_vector(1 downto 0);
			   MV1_MV0: in std_logic_vector(11 downto 0);
			   RST, clk: in std_logic;
			   diff_mult: out std_logic_vector(13 downto 0)
				);
	end component;

	component if_UA is
		port ( MV_in_h, MV_in_v: in std_logic_vector (10 downto 0);
			   UA_flag: out std_logic);
	end component;

	component COUNT_N is
		generic (N,TARGET: integer);
		port (CE, RST, clk: 	in std_logic;
			  COUNT_OUT:out std_logic);
	end component;

	component signed_Lshifter is
		generic (N_in, N_out: integer);
		port	(SH_in:	 in  std_logic_vector (N_in-1 downto 0);
				 clk, SH_EN, LE, RST: in std_logic;
				 SH_out: out std_logic_vector (N_out-1 downto 0)
				 );
	end component;

	component signed_shifter is
		generic (N: integer);
		port	(SH_in:	 in  std_logic_vector (N-1 downto 0);
				 clk, SH_EN, LE, RST: in std_logic;
				 SH_out: out std_logic_vector (N-1 downto 0)
				 );
	end component;

	component unsigned_shifter is
		generic (N: integer);
		port	(SH_in:	 in  std_logic_vector (N-1 downto 0);
				 clk, SH_EN, LE, RST: in std_logic;
				 SH_out: out std_logic_vector (N-1 downto 0)
				 );
	end component;

	component D_min_REG is
		port (D: in std_logic_vector (27 downto 0);
			  RST, clk, LE: in std_logic;
			  Q: out std_logic_vector (27 downto 0));
	end component;

	component COUNT_VAL_N is
		generic (N,TARGET: integer);
		port (CE, RST, clk: 	in std_logic;
			  COUNT: out std_logic_vector(N-1 downto 0);
			  HIT:out std_logic);
	end component;

	component FlFl_LE is
	port (D, RST, clk, LE: in std_logic;
		  Q: out std_logic);
	end component;

	component firstPelPos is
		port ( CE_REPx, CE_BLKx, RST_BLKx, clk, RST: in std_logic;
			   CE_REPy, CE_BLKy, RST_BLKy : in std_logic;
			   CU_w, CU_h: in std_logic_vector(1 downto 0);
			   last_block_x, last_block_y:  out std_logic;
			   x0, y0: out std_logic_vector( 5 downto 0)	
			  );
	end component;

	component Ext_RF is
		port( RF_Addr: in std_logic;
			  MV0_in,MV1_in,MV2_in: in motion_vector(1 downto 0); --0:h, 1:v
			  clk, WE, RE, RST: in std_logic;
			  MV0_out,MV1_out,MV2_out: out motion_vector(1 downto 0)
			);
	end component;
	
	component COUNT_VAL is
		generic (N: integer);
		port (CE, RST, clk: 	in std_logic;
			  COUNT: out std_logic_vector(N-1 downto 0));
	end component;

	component R_SH2 is
		generic(N: integer);
		port( SH_in: in std_logic_vector(N-1 downto 0);
			  clk, LE, RST: in std_logic;
			  shift_amt: std_logic_vector(1 downto 0);
			  SH_out: out std_logic_vector(N-1 downto 0));
	end component;
	
	component MULT1 is
		generic ( N: integer);
		port 	( op1, op2:	in std_logic_vector(N-1 downto 0);
				  VALID, RST,clk : in std_logic; --For the internal signals and sequential components
				  product:		out std_logic_vector((2*N)-1 downto 0));
	end component;

	component Round is
		port (round_in: in std_logic_vector (19 downto 0);
			  round_out: out std_logic_vector (11 downto 0));
	end component;

	component ADD3 is
		generic (N: integer);
		port( op1,op2,op3: in std_logic_vector (N-1 downto 0);
			  VALID, RST, clk: in std_logic;
			  sum: out std_logic_vector (N+1 downto 0)
			);
	end component;

	component abs_unit is
		generic ( N: integer);
		port	( abs_in:	in std_logic_vector(N-1 downto 0);
				  abs_out:		out std_logic_vector(N-2 downto 0));
	end component;

	component unsigned_adder is
		generic ( N: integer);
		port	( op1, op2:	in std_logic_vector(N-1 downto 0);
				  sum:		out std_logic_vector(N downto 0));
	end component;

	component REG_N_sRST is
		generic (N: integer);
		port (D: in std_logic_vector (N-1 downto 0);
			  sRST, clk: in std_logic;
			  Q: out std_logic_vector (N-1 downto 0));
	end component;

	component SAD_min_REG is
		port (D: in std_logic_vector (17 downto 0);
			  RST, clk, LE: in std_logic;
			  Q: out std_logic_vector (17 downto 0));
	end component;
	
	component FlFl_T is
		port (T, RST, clk: 	in std_logic;
			  Q: out std_logic);
	end component;

end package;

package body AMEpkg is
end package body;
