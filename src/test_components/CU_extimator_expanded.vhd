library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.AMEpkg.all;

	entity CU_extimator_expanded is
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
			  DONE: out std_logic;
			  --Expanded part
			  PS_out, NS_out: out std_logic_vector(4 downto 0)			  
		);
	end entity;

architecture beh of CU_extimator_expanded is

	
	
	--type CU_extimator_state is (ON_RESET,IDLE,    SREP_WAIT2, SREP_WAIT3,  SECOND_REP,TREP_WAIT1,TREP_WAIT2,TREP_WAIT3,THIRD_REP,FREP_WAIT1,FREP_WAIT2,FREP_WAIT3,
	--type CU_extimator_state is ("00000", "00001",   "00010",   "00011",     "00100",    "00101",    "00110",   "00111",   "01000",  "01001",  "01010",    "01011",
	--FOURTH_REP,NB_WAIT1,NB_WAIT2,NB_WAIT3,NEW_LINE,NEXT_BLOCK,TERM_CANDIDATE1,SREP_WAIT1,SREP_WAIT1_NEW_CANDIDATE,SECOND_CANDIDATE_WAIT,TERM_LAST_CAND,WAIT_FOR_COUNT,READ_BEST_CAND,WRITE_BEST_CAND,EXTIMATE);
	--"01100",    "01101", "01110","01111",  "10000",  "10001",   "10010",       "10011",          "10100",                    "10101",      "10110",        "10111",     "11000",      "11001",      "11010");

	signal PS, NS: std_logic_vector(4 downto 0);
	signal VALID_int, last_block_x_int, last_block_y_int, last_cand_int, Second_ready_int, CountTerm_OUT_int: std_logic;
	signal RF_in_RE_dummy_int : std_logic;
	
	--Moving registers
	
	signal READY_RST_int				: std_logic;
	signal RST1_int					    : std_logic;
	signal RST2_int					    : std_logic;
	signal CE_REPx_int					: std_logic;
	signal CE_BLKx_int					: std_logic;
	signal RST_BLKx_int				    : std_logic;
	signal CE_REPy_int					: std_logic;
	signal CE_BLKy_int					: std_logic;
	signal RST_BLKy_int				    : std_logic;
	signal RF_Addr_int					: std_logic_vector(1 downto 0);
	signal LE_ab_int					: std_logic;
	signal SAD_tmp_RST_int				: std_logic;
	signal Comp_EN_int					: std_logic;
	signal OUT_LE_int					: std_logic;
	signal CountTerm_EN_int			    : std_logic;
	signal CandCount_CE_int			    : std_logic;
	--signal RF_in_RE_dummy_int			: std_logic;
	signal INTER_DATA_VALID_SET_int	    : std_logic;
	signal INTER_DATA_VALID_RESET_int	: std_logic;
	signal ADD3_MVin_LE_fSET_int		: std_logic;
	signal ADD3_MVin_LE_nSET_int		: std_logic;
	signal ADD3_MVin_LE_fRESET_int		: std_logic;
	signal DONE_int					    : std_logic;

begin

----INPUT SAMPLING

	VALID_samp: FlFl
		port map(D=>VALID,Q=>VALID_int,clk=>clk,RST=>CU_RST);
	last_block_x_samp: FlFl
		port map(D=>last_block_x,Q=>last_block_x_int,clk=>clk,RST=>CU_RST);
	last_block_y_samp: FlFl
		port map(D=>last_block_y,Q=>last_block_y_int,clk=>clk,RST=>CU_RST);
	last_cand_samp: FlFl
		port map(D=>last_cand,Q=>last_cand_int,clk=>clk,RST=>CU_RST);
	Second_ready_samp: FlFl
		port map(D=>Second_ready,Q=>Second_ready_int,clk=>clk,RST=>CU_RST);
	CountTerm_OUT_samp: FlFl
		port map(D=>CountTerm_OUT,Q=>CountTerm_OUT_int,clk=>clk,RST=>CU_RST);

----PRESENT STATE REGISTER
	present_state_REG: process(clk,CU_RST)
		begin
			if CU_RST='1' then
				PS<="00000";
			elsif rising_edge(clk) then
				PS<=NS;
			--else
				--PS<=PS;
			end if;
	end process;

----NEXT STATE CALCULATION
	next_state_calc: process(PS,VALID,last_block_x,last_block_y,last_cand,Second_ready,CountTerm_OUT)
	begin
		case PS is
			when "00000" =>
				NS<="00001";
			when "00001" =>
				if VALID='1' then
					NS<="00010";
				else
					NS<="00001";
				end if;
			when "00010" =>
				NS<="00011";
			when "00011" =>
				NS<="00100";
			when "00100" =>
				NS<="00101";
			when "00101" =>
				NS<="00110";
			when "00110" =>
				NS<="00111";
			when "00111" =>
				NS<="01000";
			when "01000" =>
				NS<= "01001";
			when "01001" =>
				NS<="01010";
			when "01010" =>
				NS<="01011";
			when "01011" =>
				NS<="01100";
			when "01100" =>
				NS<="01101";
			when "01101" =>
				NS<="01110";
			when "01110" =>
				NS<="01111";
			when "01111" =>
				if last_block_x='0' THEN
					NS<="10001";
				elsif last_block_x='1' AND last_block_y='0' THEN
					NS<="10000";
				elsif last_block_x='1' AND last_block_y='1' THEN
					if last_cand='0' then
						NS<="10010";
					else
						NS<="10110";
					end if;
				else
						NS<="01111";
				end if;
			when "10000" =>
				NS<="10011";
			when "10001" =>
				NS<="10011";
			when "10010" =>
				if Second_ready='1' OR VALID='1' THEN
					NS<="10100";
				else
					NS<="10101";
				end if;
			when "10100" =>
				NS<="00010";
			when "10011" =>
				NS<="00010";
			when "10101" =>
				if VALID ='1' THEN
					NS<="00010";
				else
					NS<="10101";
				end if;
			when "10110" =>
				NS<="10111";
			when "10111"=>
				if CountTerm_OUT='1' then
					NS<="11000";
				else
					NS<="10111";
				end if;
			when "11000" =>
				NS<="11001";
			when "11001" =>
				NS<="11010";
			when "11010" =>
				NS<="00001";
			when OTHERS =>
				NS<="00000";
		end case;
	end process;

----OUTPUT CALCULATION
	output_calulation: process (PS)
	begin
		case PS is
			when "00000" =>
				READY_RST_int<='1';
				RST1_int<='1';
				RST2_int<='1';
				CE_REPx_int<='0';
				CE_BLKx_int<='0';
				RST_BLKx_int<='1';
				CE_REPy_int<='0';
				CE_BLKy_int<='0';
				RST_BLKy_int<='1';
				RF_Addr_int<="00";
				LE_ab_int<='0';
				SAD_tmp_RST_int<='1';
				Comp_EN_int<='0';
				OUT_LE_int<='0';
				CountTerm_EN_int<='0';
				CandCount_CE_int<='0';
				RF_in_RE_dummy_int<='0';
				INTER_DATA_VALID_SET_int<='0';
				INTER_DATA_VALID_RESET_int<='0';
				ADD3_MVin_LE_fSET_int<='0';
				ADD3_MVin_LE_nSET_int<='0';
				ADD3_MVin_LE_fRESET_int<='1';
				DONE_int<='0';
			when "00001" =>
				READY_RST_int<='1';
				RST1_int<='0';
				RST2_int<='1';
				CE_REPx_int<='0';
				CE_BLKx_int<='0';
				RST_BLKx_int<='1';
				CE_REPy_int<='0';
				CE_BLKy_int<='0';
				RST_BLKy_int<='1';
				RF_Addr_int<="00";
				LE_ab_int<='1';
				SAD_tmp_RST_int<='1';
				Comp_EN_int<='0';
				OUT_LE_int<='0';
				CountTerm_EN_int<='0';
				CandCount_CE_int<='0';
				RF_in_RE_dummy_int<='1';----
				INTER_DATA_VALID_SET_int<='0';
				INTER_DATA_VALID_RESET_int<='0';
				ADD3_MVin_LE_fSET_int<='1';----
				ADD3_MVin_LE_nSET_int<='0';
				ADD3_MVin_LE_fRESET_int<='0';
				DONE_int<='0';
			when "00010" =>
				READY_RST_int<='0';
				RST1_int<='0';
				RST2_int<='0';
				CE_REPx_int<='0';
				CE_BLKx_int<='0';
				RST_BLKx_int<='0';
				CE_REPy_int<='0';
				CE_BLKy_int<='0';
				RST_BLKy_int<='0';
				RF_Addr_int<="01";----
				LE_ab_int<='0';
				SAD_tmp_RST_int<='0';
				Comp_EN_int<='0';
				OUT_LE_int<='0';
				CountTerm_EN_int<='0';
				CandCount_CE_int<='0';
				RF_in_RE_dummy_int<='1';
				INTER_DATA_VALID_SET_int<='1';----
				INTER_DATA_VALID_RESET_int<='0';
				ADD3_MVin_LE_fSET_int<='0';
				ADD3_MVin_LE_nSET_int<='0';
				ADD3_MVin_LE_fRESET_int<='1';----
				DONE_int<='0';
			when "00011" =>
				READY_RST_int<='0';
				RST1_int<='0';
				RST2_int<='0';
				CE_REPx_int<='0';
				CE_BLKx_int<='0';
				RST_BLKx_int<='0';
				CE_REPy_int<='0';
				CE_BLKy_int<='0';
				RST_BLKy_int<='0';
				RF_Addr_int<="01";
				LE_ab_int<='0';
				SAD_tmp_RST_int<='0';
				Comp_EN_int<='0';
				OUT_LE_int<='0';
				CountTerm_EN_int<='0';
				CandCount_CE_int<='0';
				RF_in_RE_dummy_int<='1';
				INTER_DATA_VALID_SET_int<='0';----
				INTER_DATA_VALID_RESET_int<='0';
				ADD3_MVin_LE_fSET_int<='0';
				ADD3_MVin_LE_nSET_int<='0';
				ADD3_MVin_LE_fRESET_int<='0';
				DONE_int<='0';
			when "00100" =>
				READY_RST_int<='0';
				RST1_int<='0';
				RST2_int<='0';
				CE_REPx_int<='1';-----
				CE_BLKx_int<='0';
				RST_BLKx_int<='0';
				CE_REPy_int<='0';
				CE_BLKy_int<='0';
				RST_BLKy_int<='0';
				RF_Addr_int<="01";
				LE_ab_int<='0';
				SAD_tmp_RST_int<='0';
				Comp_EN_int<='0';
				OUT_LE_int<='0';
				CountTerm_EN_int<='0';
				CandCount_CE_int<='0';
				RF_in_RE_dummy_int<='1';
				INTER_DATA_VALID_SET_int<='0';
				INTER_DATA_VALID_RESET_int<='0';
				ADD3_MVin_LE_fSET_int<='0';
				ADD3_MVin_LE_nSET_int<='0';
				ADD3_MVin_LE_fRESET_int<='0';
				DONE_int<='0';
			when "00101" =>
				READY_RST_int<='0';
				RST1_int<='0';
				RST2_int<='0';
				CE_REPx_int<='0';-----
				CE_BLKx_int<='0';
				RST_BLKx_int<='0';
				CE_REPy_int<='0';
				CE_BLKy_int<='0';
				RST_BLKy_int<='0';
				RF_Addr_int<="01";
				LE_ab_int<='0';
				SAD_tmp_RST_int<='0';
				Comp_EN_int<='0';
				OUT_LE_int<='0';
				CountTerm_EN_int<='0';
				CandCount_CE_int<='0';
				RF_in_RE_dummy_int<='1';
				INTER_DATA_VALID_SET_int<='0';
				INTER_DATA_VALID_RESET_int<='0';
				ADD3_MVin_LE_fSET_int<='0';
				ADD3_MVin_LE_nSET_int<='0';
				ADD3_MVin_LE_fRESET_int<='0';
				DONE_int<='0';
			when "00110" | "00111" =>
			--Same signlas as previous state
				READY_RST_int<='0';
				RST1_int<='0';
				RST2_int<='0';
				CE_REPx_int<='0';
				CE_BLKx_int<='0';
				RST_BLKx_int<='0';
				CE_REPy_int<='0';
				CE_BLKy_int<='0';
				RST_BLKy_int<='0';
				RF_Addr_int<="01";
				LE_ab_int<='0';
				SAD_tmp_RST_int<='0';
				Comp_EN_int<='0';
				OUT_LE_int<='0';
				CountTerm_EN_int<='0';
				CandCount_CE_int<='0';
				RF_in_RE_dummy_int<='1';
				INTER_DATA_VALID_SET_int<='0';
				INTER_DATA_VALID_RESET_int<='0';
				ADD3_MVin_LE_fSET_int<='0';
				ADD3_MVin_LE_nSET_int<='0';
				ADD3_MVin_LE_fRESET_int<='0';
				DONE_int<='0';
			when "01000" =>
				READY_RST_int<='0';
				RST1_int<='0';
				RST2_int<='0';
				CE_REPx_int<='1';----
				CE_BLKx_int<='0';
				RST_BLKx_int<='0';
				CE_REPy_int<='1';----
				CE_BLKy_int<='0';
				RST_BLKy_int<='0';
				RF_Addr_int<="01";
				LE_ab_int<='0';
				SAD_tmp_RST_int<='0';
				Comp_EN_int<='0';
				OUT_LE_int<='0';
				CountTerm_EN_int<='0';
				CandCount_CE_int<='0';
				RF_in_RE_dummy_int<='1';
				INTER_DATA_VALID_SET_int<='0';
				INTER_DATA_VALID_RESET_int<='0';
				ADD3_MVin_LE_fSET_int<='0';
				ADD3_MVin_LE_nSET_int<='0';
				ADD3_MVin_LE_fRESET_int<='0';
				DONE_int<='0';
			when "01001" | "01010" | "01011" | "01101" | "01110" | "01111" =>
				READY_RST_int<='0';
				RST1_int<='0';
				RST2_int<='0';
				CE_REPx_int<='0';----
				CE_BLKx_int<='0';
				RST_BLKx_int<='0';
				CE_REPy_int<='0';----
				CE_BLKy_int<='0';
				RST_BLKy_int<='0';
				RF_Addr_int<="01";
				LE_ab_int<='0';
				SAD_tmp_RST_int<='0';
				Comp_EN_int<='0';
				OUT_LE_int<='0';
				CountTerm_EN_int<='0';
				CandCount_CE_int<='0';
				RF_in_RE_dummy_int<='1';
				INTER_DATA_VALID_SET_int<='0';
				INTER_DATA_VALID_RESET_int<='0';
				ADD3_MVin_LE_fSET_int<='0';
				ADD3_MVin_LE_nSET_int<='0';
				ADD3_MVin_LE_fRESET_int<='0';
				DONE_int<='0';
			when "01100" =>
				READY_RST_int<='0';
				RST1_int<='0';
				RST2_int<='0';
				CE_REPx_int<='1';----
				CE_BLKx_int<='0';
				RST_BLKx_int<='0';
				CE_REPy_int<='0';
				CE_BLKy_int<='0';
				RST_BLKy_int<='0';
				RF_Addr_int<="01";
				LE_ab_int<='0';
				SAD_tmp_RST_int<='0';
				Comp_EN_int<='0';
				OUT_LE_int<='0';
				CountTerm_EN_int<='0';
				CandCount_CE_int<='0';
				RF_in_RE_dummy_int<='1';
				INTER_DATA_VALID_SET_int<='0';
				INTER_DATA_VALID_RESET_int<='0';
				ADD3_MVin_LE_fSET_int<='0';
				ADD3_MVin_LE_nSET_int<='0';
				ADD3_MVin_LE_fRESET_int<='0';
				DONE_int<='0';
			when "10000" =>
				READY_RST_int<='0';
				RST1_int<='0';
				RST2_int<='0';
				CE_REPx_int<='1';----
				CE_BLKx_int<='0';
				RST_BLKx_int<='1';----
				CE_REPy_int<='1';----
				CE_BLKy_int<='1';----
				RST_BLKy_int<='0';
				RF_Addr_int<="01";
				LE_ab_int<='0';
				SAD_tmp_RST_int<='0';
				Comp_EN_int<='0';
				OUT_LE_int<='0';
				CountTerm_EN_int<='0';
				CandCount_CE_int<='0';
				RF_in_RE_dummy_int<='1';
				INTER_DATA_VALID_SET_int<='0';
				INTER_DATA_VALID_RESET_int<='0';
				ADD3_MVin_LE_fSET_int<='0';
				ADD3_MVin_LE_nSET_int<='0';
				ADD3_MVin_LE_fRESET_int<='0';
				DONE_int<='0';
			when "10001" =>
				READY_RST_int<='0';
				RST1_int<='0';
				RST2_int<='0';
				CE_REPx_int<='1';----
				CE_BLKx_int<='1';----
				RST_BLKx_int<='0';
				CE_REPy_int<='1';----
				CE_BLKy_int<='0';
				RST_BLKy_int<='0';
				RF_Addr_int<="01";
				LE_ab_int<='0';
				SAD_tmp_RST_int<='0';
				Comp_EN_int<='0';
				OUT_LE_int<='0';
				CountTerm_EN_int<='0';
				CandCount_CE_int<='0';
				RF_in_RE_dummy_int<='1';
				INTER_DATA_VALID_SET_int<='0';
				INTER_DATA_VALID_RESET_int<='0';
				ADD3_MVin_LE_fSET_int<='0';
				ADD3_MVin_LE_nSET_int<='0';
				ADD3_MVin_LE_fRESET_int<='0';
				DONE_int<='0';
			when "10010" =>
				READY_RST_int<='0';
				RST1_int<='0';
				RST2_int<='0';
				CE_REPx_int<='1';----
				CE_BLKx_int<='0';
				RST_BLKx_int<='1';----
				CE_REPy_int<='1';----
				CE_BLKy_int<='0';
				RST_BLKy_int<='1';----
				RF_Addr_int<="01";
				LE_ab_int<='1';----
				SAD_tmp_RST_int<='0';
				Comp_EN_int<='1';----
				OUT_LE_int<='0';
				CountTerm_EN_int<='0';
				CandCount_CE_int<='1';----
				RF_in_RE_dummy_int<='1';
				INTER_DATA_VALID_SET_int<='0';
				INTER_DATA_VALID_RESET_int<='1';----
				ADD3_MVin_LE_fSET_int<='0';
				ADD3_MVin_LE_nSET_int<='1';----
				ADD3_MVin_LE_fRESET_int<='0';
				DONE_int<='0';
			when "10011" =>
				READY_RST_int<='0';
				RST1_int<='0';
				RST2_int<='0';
				CE_REPx_int<='0';
				CE_BLKx_int<='0';
				RST_BLKx_int<='0';
				CE_REPy_int<='0';
				CE_BLKy_int<='0';
				RST_BLKy_int<='0';
				RF_Addr_int<="01";
				LE_ab_int<='0';----
				SAD_tmp_RST_int<='0';
				Comp_EN_int<='0';
				OUT_LE_int<='0';
				CountTerm_EN_int<='0';
				CandCount_CE_int<='0';
				RF_in_RE_dummy_int<='1';
				INTER_DATA_VALID_SET_int<='0';
				INTER_DATA_VALID_RESET_int<='0';----
				ADD3_MVin_LE_fSET_int<='0';
				ADD3_MVin_LE_nSET_int<='0';
				ADD3_MVin_LE_fRESET_int<='0';
				DONE_int<='0';
			when "10100" =>
				READY_RST_int<='0';
				RST1_int<='0';
				RST2_int<='0';
				CE_REPx_int<='0';
				CE_BLKx_int<='0';
				RST_BLKx_int<='0';
				CE_REPy_int<='0';
				CE_BLKy_int<='0';
				RST_BLKy_int<='0';
				RF_Addr_int<="01";
				LE_ab_int<='0';----
				SAD_tmp_RST_int<='1';----
				Comp_EN_int<='0';
				OUT_LE_int<='0';
				CountTerm_EN_int<='0';
				CandCount_CE_int<='0';
				RF_in_RE_dummy_int<='1';
				INTER_DATA_VALID_SET_int<='0';
				INTER_DATA_VALID_RESET_int<='0';----
				ADD3_MVin_LE_fSET_int<='0';
				ADD3_MVin_LE_nSET_int<='0';
				ADD3_MVin_LE_fRESET_int<='0';
				DONE_int<='0';
			when "10101" =>
				READY_RST_int<='0';
				RST1_int<='0';
				RST2_int<='0';
				CE_REPx_int<='0';
				CE_BLKx_int<='0';
				RST_BLKx_int<='0';
				CE_REPy_int<='0';
				CE_BLKy_int<='0';
				RST_BLKy_int<='0';
				RF_Addr_int<="01";
				LE_ab_int<='1';
				SAD_tmp_RST_int<='1';----
				Comp_EN_int<='0';
				OUT_LE_int<='0';
				CountTerm_EN_int<='0';
				CandCount_CE_int<='0';
				RF_in_RE_dummy_int<='1';
				INTER_DATA_VALID_SET_int<='0';
				INTER_DATA_VALID_RESET_int<='0';----
				ADD3_MVin_LE_fSET_int<='0';
				ADD3_MVin_LE_nSET_int<='0';
				ADD3_MVin_LE_fRESET_int<='0';
				DONE_int<='0';
			when "10110" =>
				READY_RST_int<='0';
				RST1_int<='0';
				RST2_int<='0';
				CE_REPx_int<='1';----
				CE_BLKx_int<='0';
				RST_BLKx_int<='1';----
				CE_REPy_int<='1';----
				CE_BLKy_int<='0';
				RST_BLKy_int<='1';----
				RF_Addr_int<="01";
				LE_ab_int<='0';
				SAD_tmp_RST_int<='0';
				Comp_EN_int<='1';----
				OUT_LE_int<='0';
				CountTerm_EN_int<='1';----
				CandCount_CE_int<='0';
				RF_in_RE_dummy_int<='1';
				INTER_DATA_VALID_SET_int<='0';
				INTER_DATA_VALID_RESET_int<='1';----
				ADD3_MVin_LE_fSET_int<='0';
				ADD3_MVin_LE_nSET_int<='0';
				ADD3_MVin_LE_fRESET_int<='0';
				DONE_int<='0';
			when "10111" =>
				READY_RST_int<='0';
				RST1_int<='0';
				RST2_int<='0';
				CE_REPx_int<='0';----
				CE_BLKx_int<='0';
				RST_BLKx_int<='0';----
				CE_REPy_int<='0';----
				CE_BLKy_int<='0';
				RST_BLKy_int<='0';----
				RF_Addr_int<="01";
				LE_ab_int<='0';
				SAD_tmp_RST_int<='1';----
				Comp_EN_int<='0';----
				OUT_LE_int<='0';
				CountTerm_EN_int<='1';----
				CandCount_CE_int<='0';
				RF_in_RE_dummy_int<='1';
				INTER_DATA_VALID_SET_int<='0';
				INTER_DATA_VALID_RESET_int<='0';
				ADD3_MVin_LE_fSET_int<='0';
				ADD3_MVin_LE_nSET_int<='0';
				ADD3_MVin_LE_fRESET_int<='0';
				DONE_int<='0';
			when "11000" =>
				READY_RST_int<='0';
				RST1_int<='0';
				RST2_int<='0';
				CE_REPx_int<='0';
				CE_BLKx_int<='0';
				RST_BLKx_int<='0';
				CE_REPy_int<='0';
				CE_BLKy_int<='0';
				RST_BLKy_int<='0';
				RF_Addr_int<="11";--Read from "Best Cand"
				LE_ab_int<='0';
				SAD_tmp_RST_int<='1';
				Comp_EN_int<='0';
				OUT_LE_int<='0';
				CountTerm_EN_int<='0';----
				CandCount_CE_int<='0';
				RF_in_RE_dummy_int<='1';
				INTER_DATA_VALID_SET_int<='0';
				INTER_DATA_VALID_RESET_int<='0';
				ADD3_MVin_LE_fSET_int<='0';
				ADD3_MVin_LE_nSET_int<='0';
				ADD3_MVin_LE_fRESET_int<='0';
				DONE_int<='0';
			when "11001" =>
				READY_RST_int<='0';
				RST1_int<='0';
				RST2_int<='0';
				CE_REPx_int<='0';
				CE_BLKx_int<='0';
				RST_BLKx_int<='0';
				CE_REPy_int<='0';
				CE_BLKy_int<='0';
				RST_BLKy_int<='0';
				RF_Addr_int<="11";--Read from "Best Cand"
				LE_ab_int<='0';
				SAD_tmp_RST_int<='1';
				Comp_EN_int<='0';
				OUT_LE_int<='1';----
				CountTerm_EN_int<='0';
				CandCount_CE_int<='0';
				RF_in_RE_dummy_int<='1';
				INTER_DATA_VALID_SET_int<='0';
				INTER_DATA_VALID_RESET_int<='0';
				ADD3_MVin_LE_fSET_int<='0';
				ADD3_MVin_LE_nSET_int<='0';
				ADD3_MVin_LE_fRESET_int<='0';
				DONE_int<='0';
			when "11010" =>
				READY_RST_int<='1';----
				RST1_int<='0';
				RST2_int<='0';
				CE_REPx_int<='0';
				CE_BLKx_int<='0';
				RST_BLKx_int<='0';
				CE_REPy_int<='0';
				CE_BLKy_int<='0';
				RST_BLKy_int<='0';
				RF_Addr_int<="11";--Read from "Best Cand"
				LE_ab_int<='0';
				SAD_tmp_RST_int<='1';
				Comp_EN_int<='0';
				OUT_LE_int<='0';----
				CountTerm_EN_int<='0';
				CandCount_CE_int<='0';
				RF_in_RE_dummy_int<='1';
				INTER_DATA_VALID_SET_int<='0';
				INTER_DATA_VALID_RESET_int<='0';
				ADD3_MVin_LE_fSET_int<='0';
				ADD3_MVin_LE_nSET_int<='0';
				ADD3_MVin_LE_fRESET_int<='0';
				DONE_int<='1';
			when OTHERS =>
				READY_RST_int<='1';
				RST1_int<='1';
				RST2_int<='1';
				CE_REPx_int<='0';
				CE_BLKx_int<='0';
				RST_BLKx_int<='1';
				CE_REPy_int<='0';
				CE_BLKy_int<='0';
				RST_BLKy_int<='1';
				RF_Addr_int<="00";
				LE_ab_int<='0';
				SAD_tmp_RST_int<='1';
				Comp_EN_int<='0';
				OUT_LE_int<='0';
				CountTerm_EN_int<='0';
				CandCount_CE_int<='0';
				RF_in_RE_dummy_int<='0';
				INTER_DATA_VALID_SET_int<='0';
				INTER_DATA_VALID_RESET_int<='0';
				ADD3_MVin_LE_fSET_int<='0';
				ADD3_MVin_LE_nSET_int<='0';
				ADD3_MVin_LE_fRESET_int<='1';
				DONE_int<='0';
		end case;
	end process;		

	--Expanded part
	PS_out<=PS;
	NS_out<=NS;

	--Attempt to understand the glitch problem
	RF_in_RE<='1';

	--Moving the register from in to out
	cu_out_samp: process(clk, CU_RST)
	begin
		if CU_RST='1' then
			READY_RST				<='1';
			RST1					<='1';
			RST2					<='1';
			CE_REPx					<='0';
			CE_BLKx					<='0';
			RST_BLKx				<='1';
			CE_REPy					<='0';
			CE_BLKy					<='0';
			RST_BLKy				<='1';
			RF_Addr					<="00";
			LE_ab					<='0';
			SAD_tmp_RST				<='1';
			Comp_EN					<='0';
			OUT_LE					<='0';
			CountTerm_EN			<='0';
			CandCount_CE			<='0';
			--RF_in_RE_dummy			<='0';
			INTER_DATA_VALID_SET	<='0';
			INTER_DATA_VALID_RESET	<='0';
			ADD3_MVin_LE_fSET		<='0';
			ADD3_MVin_LE_nSET		<='0';
			ADD3_MVin_LE_fRESET		<='1';
			DONE					<='0';
		elsif rising_edge(clk) then
			READY_RST					<=	READY_RST_int				;
			RST1						<=	RST1_int					;
			RST2						<=	RST2_int					;
			CE_REPx						<=	CE_REPx_int					;
			CE_BLKx						<=	CE_BLKx_int					;
			RST_BLKx					<=	RST_BLKx_int				;
			CE_REPy						<=	CE_REPy_int					;
			CE_BLKy						<=	CE_BLKy_int					;
			RST_BLKy					<=	RST_BLKy_int				;
			RF_Addr						<=	RF_Addr_int					;
			LE_ab						<=	LE_ab_int					;
			SAD_tmp_RST					<=	SAD_tmp_RST_int				;
			Comp_EN						<=	Comp_EN_int					;
			OUT_LE						<=	OUT_LE_int					;
			CountTerm_EN				<=	CountTerm_EN_int			;
			CandCount_CE				<=	CandCount_CE_int			;
			--RF_in_RE_dummy				<=	RF_in_RE_dummy_int			;
			INTER_DATA_VALID_SET		<=	INTER_DATA_VALID_SET_int	;
			INTER_DATA_VALID_RESET		<=	INTER_DATA_VALID_RESET_int	;
			ADD3_MVin_LE_fSET			<=	ADD3_MVin_LE_fSET_int		;
			ADD3_MVin_LE_nSET			<=	ADD3_MVin_LE_nSET_int		;
			ADD3_MVin_LE_fRESET			<=	ADD3_MVin_LE_fRESET_int		;
			DONE						<=	DONE_int					;
		end if;
	end process;
	

end architecture;
