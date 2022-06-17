library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.AMEpkg.all;

entity CU_extimator is
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
end entity;

architecture beh of CU_extimator is

	signal PS, NS: CU_extimator_state;
	signal VALID_int, last_block_x_int, last_block_y_int, last_cand_int, Second_ready_int, CountTerm_OUT_int: std_logic;

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
				PS<=ON_RESET;
			elsif rising_edge(clk) then
				PS<=NS;
			else
				PS<=PS;
			end if;
	end process;

----NEXT STATE CALCULATION
	next_state_calc: process(PS,VALID_int,last_block_x_int,last_block_y_int,last_cand_int,Second_ready_int,CountTerm_OUT_int)
	begin
		case PS is
			when ON_RESET =>
				NS<=IDLE;
			when IDLE =>
				if VALID_int='1' then
					NS<=SREP_WAIT2;
				else
					NS<=IDLE;
				end if;
			when SREP_WAIT2 =>
				NS<=SREP_WAIT3;
			when SREP_WAIT3 =>
				NS<=SECOND_REP;
			when SECOND_REP =>
				NS<=TREP_WAIT1;
			when TREP_WAIT1 =>
				NS<=TREP_WAIT2;
			when TREP_WAIT2 =>
				NS<=TREP_WAIT3;
			when TREP_WAIT3 =>
				NS<=THIRD_REP;
			when THIRD_REP =>
				NS<= FREP_WAIT1;
			when FREP_WAIT1 =>
				NS<=FREP_WAIT2;
			when FREP_WAIT2 =>
				NS<=FREP_WAIT3;
			when FREP_WAIT3 =>
				NS<=FOURTH_REP;
			when FOURTH_REP =>
				NS<=NB_WAIT1;
			when NB_WAIT1 =>
				NS<=NB_WAIT2;
			when NB_WAIT2 =>
				NS<=NB_WAIT3;
			when NB_WAIT3 =>
				if last_block_x_int='0' THEN
					NS<=NEXT_BLOCK;
				elsif last_block_x_int='1' AND last_block_y_int='0' THEN
					NS<=NEW_LINE;
				elsif last_block_x_int='1' AND last_block_y_int='1' THEN
					if last_cand_int='0' then
						NS<=TERM_CANDIDATE1;
					else
						NS<=TERM_LAST_CAND;
					end if;
				end if;
			when NEW_LINE =>
				NS<=SREP_WAIT1;
			when NEXT_BLOCK =>
				NS<=SREP_WAIT1;
			when TERM_CANDIDATE1 =>
				if Second_ready_int='1' OR VALID_int='1' THEN
					NS<=SREP_WAIT1_NEW_CANDIDATE;
				else
					NS<=SECOND_CANDIDATE_WAIT;
				end if;
			when SREP_WAIT1_NEW_CANDIDATE =>
				NS<=SREP_WAIT2;
			when SREP_WAIT1 =>
				NS<=SREP_WAIT2;
			when SECOND_CANDIDATE_WAIT =>
				if VALID ='1' THEN
					NS<=SREP_WAIT2;
				else
					NS<=SECOND_CANDIDATE_WAIT;
				end if;
			when TERM_LAST_CAND =>
				NS<=WAIT_FOR_COUNT;
			when WAIT_FOR_COUNT=>
				if CountTerm_OUT_int='1' then
					NS<=READ_BEST_CAND;
				else
					NS<=WAIT_FOR_COUNT;
				end if;
			when READ_BEST_CAND =>
				NS<=WRITE_BEST_CAND;
			when WRITE_BEST_CAND =>
				NS<=EXTIMATE;
			when EXTIMATE =>
				NS<=IDLE;
			when OTHERS =>
				NS<=ON_RESET;
		end case;
	end process;

----OUTPUT CALCULATION
	output_calulation: process (PS)
	begin
		case PS is
			when ON_RESET =>
				READY_RST<='1';
				RST1<='1';
				RST2<='1';
				CE_REPx<='0';
				CE_BLKx<='0';
				RST_BLKx<='1';
				CE_REPy<='0';
				CE_BLKy<='0';
				RST_BLKy<='1';
				RF_Addr<="00";
				LE_ab<='0';
				SAD_tmp_RST<='1';
				Comp_EN<='0';
				OUT_LE<='0';
				CountTerm_EN<='0';
				CandCount_CE<='0';
				RF_in_RE<='0';
				INTER_DATA_VALID_SET<='0';
				INTER_DATA_VALID_RESET<='0';
				ADD3_MVin_LE_fSET<='0';
				ADD3_MVin_LE_nSET<='0';
				ADD3_MVin_LE_fRESET<='1';
				DONE<='0';
			when IDLE =>
				READY_RST<='1';
				RST1<='0';
				RST2<='1';
				CE_REPx<='0';
				CE_BLKx<='0';
				RST_BLKx<='1';
				CE_REPy<='0';
				CE_BLKy<='0';
				RST_BLKy<='1';
				RF_Addr<="00";
				LE_ab<='1';
				SAD_tmp_RST<='1';
				Comp_EN<='0';
				OUT_LE<='0';
				CountTerm_EN<='0';
				CandCount_CE<='0';
				RF_in_RE<='1';----
				INTER_DATA_VALID_SET<='0';
				INTER_DATA_VALID_RESET<='0';
				ADD3_MVin_LE_fSET<='1';----
				ADD3_MVin_LE_nSET<='0';
				ADD3_MVin_LE_fRESET<='0';
				DONE<='0';
			when SREP_WAIT2 =>
				READY_RST<='0';
				RST1<='0';
				RST2<='0';
				CE_REPx<='0';
				CE_BLKx<='0';
				RST_BLKx<='0';
				CE_REPy<='0';
				CE_BLKy<='0';
				RST_BLKy<='0';
				RF_Addr<="01";----
				LE_ab<='0';
				SAD_tmp_RST<='0';
				Comp_EN<='0';
				OUT_LE<='0';
				CountTerm_EN<='0';
				CandCount_CE<='0';
				RF_in_RE<='1';
				INTER_DATA_VALID_SET<='1';----
				INTER_DATA_VALID_RESET<='0';
				ADD3_MVin_LE_fSET<='0';
				ADD3_MVin_LE_nSET<='0';
				ADD3_MVin_LE_fRESET<='1';----
				DONE<='0';
			when SREP_WAIT3 =>
				READY_RST<='0';
				RST1<='0';
				RST2<='0';
				CE_REPx<='0';
				CE_BLKx<='0';
				RST_BLKx<='0';
				CE_REPy<='0';
				CE_BLKy<='0';
				RST_BLKy<='0';
				RF_Addr<="01";
				LE_ab<='0';
				SAD_tmp_RST<='0';
				Comp_EN<='0';
				OUT_LE<='0';
				CountTerm_EN<='0';
				CandCount_CE<='0';
				RF_in_RE<='1';
				INTER_DATA_VALID_SET<='0';----
				INTER_DATA_VALID_RESET<='0';
				ADD3_MVin_LE_fSET<='0';
				ADD3_MVin_LE_nSET<='0';
				ADD3_MVin_LE_fRESET<='0';
				DONE<='0';
			when SECOND_REP =>
				READY_RST<='0';
				RST1<='0';
				RST2<='0';
				CE_REPx<='1';-----
				CE_BLKx<='0';
				RST_BLKx<='0';
				CE_REPy<='0';
				CE_BLKy<='0';
				RST_BLKy<='0';
				RF_Addr<="01";
				LE_ab<='0';
				SAD_tmp_RST<='0';
				Comp_EN<='0';
				OUT_LE<='0';
				CountTerm_EN<='0';
				CandCount_CE<='0';
				RF_in_RE<='1';
				INTER_DATA_VALID_SET<='0';
				INTER_DATA_VALID_RESET<='0';
				ADD3_MVin_LE_fSET<='0';
				ADD3_MVin_LE_nSET<='0';
				ADD3_MVin_LE_fRESET<='0';
				DONE<='0';
			when TREP_WAIT1 =>
				READY_RST<='0';
				RST1<='0';
				RST2<='0';
				CE_REPx<='0';-----
				CE_BLKx<='0';
				RST_BLKx<='0';
				CE_REPy<='0';
				CE_BLKy<='0';
				RST_BLKy<='0';
				RF_Addr<="01";
				LE_ab<='0';
				SAD_tmp_RST<='0';
				Comp_EN<='0';
				OUT_LE<='0';
				CountTerm_EN<='0';
				CandCount_CE<='0';
				RF_in_RE<='1';
				INTER_DATA_VALID_SET<='0';
				INTER_DATA_VALID_RESET<='0';
				ADD3_MVin_LE_fSET<='0';
				ADD3_MVin_LE_nSET<='0';
				ADD3_MVin_LE_fRESET<='0';
				DONE<='0';
			when TREP_WAIT2 | TREP_WAIT3 =>
			--Same signlas as previous state
				READY_RST<='0';
				RST1<='0';
				RST2<='0';
				CE_REPx<='0';
				CE_BLKx<='0';
				RST_BLKx<='0';
				CE_REPy<='0';
				CE_BLKy<='0';
				RST_BLKy<='0';
				RF_Addr<="01";
				LE_ab<='0';
				SAD_tmp_RST<='0';
				Comp_EN<='0';
				OUT_LE<='0';
				CountTerm_EN<='0';
				CandCount_CE<='0';
				RF_in_RE<='1';
				INTER_DATA_VALID_SET<='0';
				INTER_DATA_VALID_RESET<='0';
				ADD3_MVin_LE_fSET<='0';
				ADD3_MVin_LE_nSET<='0';
				ADD3_MVin_LE_fRESET<='0';
				DONE<='0';
			when THIRD_REP =>
				READY_RST<='0';
				RST1<='0';
				RST2<='0';
				CE_REPx<='1';----
				CE_BLKx<='0';
				RST_BLKx<='0';
				CE_REPy<='1';----
				CE_BLKy<='0';
				RST_BLKy<='0';
				RF_Addr<="01";
				LE_ab<='0';
				SAD_tmp_RST<='0';
				Comp_EN<='0';
				OUT_LE<='0';
				CountTerm_EN<='0';
				CandCount_CE<='0';
				RF_in_RE<='1';
				INTER_DATA_VALID_SET<='0';
				INTER_DATA_VALID_RESET<='0';
				ADD3_MVin_LE_fSET<='0';
				ADD3_MVin_LE_nSET<='0';
				ADD3_MVin_LE_fRESET<='0';
				DONE<='0';
			when FREP_WAIT1 | FREP_WAIT2 | FREP_WAIT3 | NB_WAIT1 | NB_WAIT2 | NB_WAIT3 =>
				READY_RST<='0';
				RST1<='0';
				RST2<='0';
				CE_REPx<='0';----
				CE_BLKx<='0';
				RST_BLKx<='0';
				CE_REPy<='0';----
				CE_BLKy<='0';
				RST_BLKy<='0';
				RF_Addr<="01";
				LE_ab<='0';
				SAD_tmp_RST<='0';
				Comp_EN<='0';
				OUT_LE<='0';
				CountTerm_EN<='0';
				CandCount_CE<='0';
				RF_in_RE<='1';
				INTER_DATA_VALID_SET<='0';
				INTER_DATA_VALID_RESET<='0';
				ADD3_MVin_LE_fSET<='0';
				ADD3_MVin_LE_nSET<='0';
				ADD3_MVin_LE_fRESET<='0';
				DONE<='0';
			when FOURTH_REP =>
				READY_RST<='0';
				RST1<='0';
				RST2<='0';
				CE_REPx<='1';----
				CE_BLKx<='0';
				RST_BLKx<='0';
				CE_REPy<='0';
				CE_BLKy<='0';
				RST_BLKy<='0';
				RF_Addr<="01";
				LE_ab<='0';
				SAD_tmp_RST<='0';
				Comp_EN<='0';
				OUT_LE<='0';
				CountTerm_EN<='0';
				CandCount_CE<='0';
				RF_in_RE<='1';
				INTER_DATA_VALID_SET<='0';
				INTER_DATA_VALID_RESET<='0';
				ADD3_MVin_LE_fSET<='0';
				ADD3_MVin_LE_nSET<='0';
				ADD3_MVin_LE_fRESET<='0';
				DONE<='0';
			when NEW_LINE =>
				READY_RST<='0';
				RST1<='0';
				RST2<='0';
				CE_REPx<='1';----
				CE_BLKx<='0';
				RST_BLKx<='1';----
				CE_REPy<='1';----
				CE_BLKy<='1';----
				RST_BLKy<='0';
				RF_Addr<="01";
				LE_ab<='0';
				SAD_tmp_RST<='0';
				Comp_EN<='0';
				OUT_LE<='0';
				CountTerm_EN<='0';
				CandCount_CE<='0';
				RF_in_RE<='1';
				INTER_DATA_VALID_SET<='0';
				INTER_DATA_VALID_RESET<='0';
				ADD3_MVin_LE_fSET<='0';
				ADD3_MVin_LE_nSET<='0';
				ADD3_MVin_LE_fRESET<='0';
				DONE<='0';
			when NEXT_BLOCK =>
				READY_RST<='0';
				RST1<='0';
				RST2<='0';
				CE_REPx<='1';----
				CE_BLKx<='1';----
				RST_BLKx<='0';
				CE_REPy<='1';----
				CE_BLKy<='0';
				RST_BLKy<='0';
				RF_Addr<="01";
				LE_ab<='0';
				SAD_tmp_RST<='0';
				Comp_EN<='0';
				OUT_LE<='0';
				CountTerm_EN<='0';
				CandCount_CE<='0';
				RF_in_RE<='1';
				INTER_DATA_VALID_SET<='0';
				INTER_DATA_VALID_RESET<='0';
				ADD3_MVin_LE_fSET<='0';
				ADD3_MVin_LE_nSET<='0';
				ADD3_MVin_LE_fRESET<='0';
				DONE<='0';
			when TERM_CANDIDATE1 =>
				READY_RST<='0';
				RST1<='0';
				RST2<='0';
				CE_REPx<='1';----
				CE_BLKx<='0';
				RST_BLKx<='1';----
				CE_REPy<='1';----
				CE_BLKy<='0';
				RST_BLKy<='1';----
				RF_Addr<="01";
				LE_ab<='1';----
				SAD_tmp_RST<='0';
				Comp_EN<='1';----
				OUT_LE<='0';
				CountTerm_EN<='0';
				CandCount_CE<='1';----
				RF_in_RE<='1';
				INTER_DATA_VALID_SET<='0';
				INTER_DATA_VALID_RESET<='1';----
				ADD3_MVin_LE_fSET<='0';
				ADD3_MVin_LE_nSET<='1';----
				ADD3_MVin_LE_fRESET<='0';
				DONE<='0';
			when SREP_WAIT1 =>
				READY_RST<='0';
				RST1<='0';
				RST2<='0';
				CE_REPx<='0';
				CE_BLKx<='0';
				RST_BLKx<='0';
				CE_REPy<='0';
				CE_BLKy<='0';
				RST_BLKy<='0';
				RF_Addr<="01";
				LE_ab<='0';----
				SAD_tmp_RST<='0';
				Comp_EN<='0';
				OUT_LE<='0';
				CountTerm_EN<='0';
				CandCount_CE<='0';
				RF_in_RE<='1';
				INTER_DATA_VALID_SET<='0';
				INTER_DATA_VALID_RESET<='0';----
				ADD3_MVin_LE_fSET<='0';
				ADD3_MVin_LE_nSET<='0';
				ADD3_MVin_LE_fRESET<='0';
				DONE<='0';
			when SREP_WAIT1_NEW_CANDIDATE =>
				READY_RST<='0';
				RST1<='0';
				RST2<='0';
				CE_REPx<='0';
				CE_BLKx<='0';
				RST_BLKx<='0';
				CE_REPy<='0';
				CE_BLKy<='0';
				RST_BLKy<='0';
				RF_Addr<="01";
				LE_ab<='0';----
				SAD_tmp_RST<='1';----
				Comp_EN<='0';
				OUT_LE<='0';
				CountTerm_EN<='0';
				CandCount_CE<='0';
				RF_in_RE<='1';
				INTER_DATA_VALID_SET<='0';
				INTER_DATA_VALID_RESET<='0';----
				ADD3_MVin_LE_fSET<='0';
				ADD3_MVin_LE_nSET<='0';
				ADD3_MVin_LE_fRESET<='0';
				DONE<='0';
			when SECOND_CANDIDATE_WAIT =>
				READY_RST<='0';
				RST1<='0';
				RST2<='0';
				CE_REPx<='0';
				CE_BLKx<='0';
				RST_BLKx<='0';
				CE_REPy<='0';
				CE_BLKy<='0';
				RST_BLKy<='0';
				RF_Addr<="01";
				LE_ab<='1';
				SAD_tmp_RST<='1';----
				Comp_EN<='0';
				OUT_LE<='0';
				CountTerm_EN<='0';
				CandCount_CE<='0';
				RF_in_RE<='1';
				INTER_DATA_VALID_SET<='0';
				INTER_DATA_VALID_RESET<='0';----
				ADD3_MVin_LE_fSET<='0';
				ADD3_MVin_LE_nSET<='0';
				ADD3_MVin_LE_fRESET<='0';
				DONE<='0';
			when TERM_LAST_CAND =>
				READY_RST<='0';
				RST1<='0';
				RST2<='0';
				CE_REPx<='1';----
				CE_BLKx<='0';
				RST_BLKx<='1';----
				CE_REPy<='1';----
				CE_BLKy<='0';
				RST_BLKy<='1';----
				RF_Addr<="01";
				LE_ab<='0';
				SAD_tmp_RST<='0';
				Comp_EN<='1';----
				OUT_LE<='0';
				CountTerm_EN<='1';----
				CandCount_CE<='0';
				RF_in_RE<='1';
				INTER_DATA_VALID_SET<='0';
				INTER_DATA_VALID_RESET<='1';----
				ADD3_MVin_LE_fSET<='0';
				ADD3_MVin_LE_nSET<='0';
				ADD3_MVin_LE_fRESET<='0';
				DONE<='0';
			when WAIT_FOR_COUNT =>
				READY_RST<='0';
				RST1<='0';
				RST2<='0';
				CE_REPx<='0';----
				CE_BLKx<='0';
				RST_BLKx<='0';----
				CE_REPy<='0';----
				CE_BLKy<='0';
				RST_BLKy<='0';----
				RF_Addr<="01";
				LE_ab<='0';
				SAD_tmp_RST<='1';----
				Comp_EN<='0';----
				OUT_LE<='0';
				CountTerm_EN<='1';----
				CandCount_CE<='0';
				RF_in_RE<='1';
				INTER_DATA_VALID_SET<='0';
				INTER_DATA_VALID_RESET<='0';
				ADD3_MVin_LE_fSET<='0';
				ADD3_MVin_LE_nSET<='0';
				ADD3_MVin_LE_fRESET<='0';
				DONE<='0';
			when READ_BEST_CAND =>
				READY_RST<='0';
				RST1<='0';
				RST2<='0';
				CE_REPx<='0';
				CE_BLKx<='0';
				RST_BLKx<='0';
				CE_REPy<='0';
				CE_BLKy<='0';
				RST_BLKy<='0';
				RF_Addr<="11";--Read from "Best Cand"
				LE_ab<='0';
				SAD_tmp_RST<='1';
				Comp_EN<='0';
				OUT_LE<='0';
				CountTerm_EN<='0';----
				CandCount_CE<='0';
				RF_in_RE<='1';
				INTER_DATA_VALID_SET<='0';
				INTER_DATA_VALID_RESET<='0';
				ADD3_MVin_LE_fSET<='0';
				ADD3_MVin_LE_nSET<='0';
				ADD3_MVin_LE_fRESET<='0';
				DONE<='0';
			when WRITE_BEST_CAND =>
				READY_RST<='0';
				RST1<='0';
				RST2<='0';
				CE_REPx<='0';
				CE_BLKx<='0';
				RST_BLKx<='0';
				CE_REPy<='0';
				CE_BLKy<='0';
				RST_BLKy<='0';
				RF_Addr<="11";--Read from "Best Cand"
				LE_ab<='0';
				SAD_tmp_RST<='1';
				Comp_EN<='0';
				OUT_LE<='1';----
				CountTerm_EN<='0';
				CandCount_CE<='0';
				RF_in_RE<='1';
				INTER_DATA_VALID_SET<='0';
				INTER_DATA_VALID_RESET<='0';
				ADD3_MVin_LE_fSET<='0';
				ADD3_MVin_LE_nSET<='0';
				ADD3_MVin_LE_fRESET<='0';
				DONE<='0';
			when EXTIMATE =>
				READY_RST<='1';----
				RST1<='0';
				RST2<='0';
				CE_REPx<='0';
				CE_BLKx<='0';
				RST_BLKx<='0';
				CE_REPy<='0';
				CE_BLKy<='0';
				RST_BLKy<='0';
				RF_Addr<="11";--Read from "Best Cand"
				LE_ab<='0';
				SAD_tmp_RST<='1';
				Comp_EN<='0';
				OUT_LE<='0';----
				CountTerm_EN<='0';
				CandCount_CE<='0';
				RF_in_RE<='1';
				INTER_DATA_VALID_SET<='0';
				INTER_DATA_VALID_RESET<='0';
				ADD3_MVin_LE_fSET<='0';
				ADD3_MVin_LE_nSET<='0';
				ADD3_MVin_LE_fRESET<='0';
				DONE<='1';
			when OTHERS =>
				READY_RST<='1';
				RST1<='1';
				RST2<='1';
				CE_REPx<='0';
				CE_BLKx<='0';
				RST_BLKx<='1';
				CE_REPy<='0';
				CE_BLKy<='0';
				RST_BLKy<='1';
				RF_Addr<="00";
				LE_ab<='0';
				SAD_tmp_RST<='1';
				Comp_EN<='0';
				OUT_LE<='0';
				CountTerm_EN<='0';
				CandCount_CE<='0';
				RF_in_RE<='0';
				INTER_DATA_VALID_SET<='0';
				INTER_DATA_VALID_RESET<='0';
				ADD3_MVin_LE_fSET<='0';
				ADD3_MVin_LE_nSET<='0';
				ADD3_MVin_LE_fRESET<='1';
				DONE<='0';
		end case;
	end process;				

end architecture;