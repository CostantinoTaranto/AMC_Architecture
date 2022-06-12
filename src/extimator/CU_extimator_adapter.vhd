--This component has simply the aim of skewing the commands with the proper timing
--to feed the DP with the correct signals

library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.AMEpkg.all;

entity CU_extimator_adapter is
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
		  MULT1_VALID, ADD3_VALID, incrY: out std_logic;
		  ADD3_MVin_LE: out std_logic;
		  RF_Addr_DP, LE_ab_DP, SAD_tmp_RST_DP, Comp_EN_DP: out std_logic
	);
end entity;

architecture beh of CU_extimator_adapter is

----MULT1_VALID, ADD3_VALID, incrY 
	constant INTER_DATA_VALID_COMMAND_DELAY_DIFF : integer := 2; --This is the delay difference between the set and reset signal
	signal INTER_DATA_VALID_RESET_int: std_logic_vector(INTER_DATA_VALID_COMMAND_DELAY_DIFF downto 0);
	signal INTER_DATA_VALID: std_logic;
	
	constant MULT1_DELAY: integer :=2; --This is the delay w.r.to INTER_DATA_VALID
	signal MULT1_VALID_int: std_logic_vector(MULT1_DELAY downto 0);
	
	constant ADD3_DELAY: integer := 5; --This is the delay w.r.to MULT1
	signal ADD3_VALID_int: std_logic_vector(ADD3_DELAY downto 0);
	
	constant incrY_DELAY: integer := 3; --This is the delay w.r.to ADD3
	signal incrY_int: std_logic_vector(incrY_DELAY downto 0);
	
----ADD3_MVin_LE
	constant nSET_DELAY: integer := 9; --The number of clock cycles after which the signal is observed
	signal ADD3_MVin_LE_nSET_int : std_logic_vector(nSET_DELAY downto 0);
	signal ADD3_MVin_LE_int: std_logic;

----LE_ab
	constant LE_ab_DELAY: integer := 4;
	signal LE_ab_int: std_logic_vector(LE_ab_DELAY downto 0);
	
----SAD_tmp_RST
	constant SAD_tmp_RST_DELAY: integer := 17;
	signal SAD_tmp_RST_int: std_logic_vector(SAD_tmp_RST_DELAY downto 0);

----Comp_EN
	constant Comp_EN_DELAY: integer := 19;
	signal Comp_EN_int: std_logic_vector(Comp_EN_DELAY downto 0);
	
begin

----MULT1_VALID, ADD3_VALID, incrY 
	INTER_DATA_VALID_RESET_int(0)<=INTER_DATA_VALID_RESET;
	INTER_DATA_VALID_RESET_delay_GEN: for I in 1 to INTER_DATA_VALID_COMMAND_DELAY_DIFF generate
		INTER_DATA_VALID_RESET_delay: FlFl
			port map(D=>INTER_DATA_VALID_RESET_int(I-1),Q=>INTER_DATA_VALID_RESET_int(I),clk=>clk,RST=>RST);
	end generate;

	inter_data_valid_register: process(clk, RST)
	begin
		if RST='1' then
			INTER_DATA_VALID<='0';
		elsif rising_edge(clk) then
			if INTER_DATA_VALID_SET='1' then
				INTER_DATA_VALID<='1';
			elsif INTER_DATA_VALID_RESET_int(INTER_DATA_VALID_COMMAND_DELAY_DIFF)='1' then
				INTER_DATA_VALID<='0';
			else
				INTER_DATA_VALID<=INTER_DATA_VALID;
			end if;
		else
			INTER_DATA_VALID<=INTER_DATA_VALID;
		end if;
	end process;
	
	MULT1_VALID_int(0)<=INTER_DATA_VALID;
	MULT1_VALID_gen: for I in 1 to MULT1_DELAY generate
		MULT1_VALID_delay: FlFl
			port map(D=>MULT1_VALID_int(I-1),Q=>MULT1_VALID_int(I),clk=>clk,RST=>RST);
	end generate;
	MULT1_VALID<=MULT1_VALID_int(MULT1_DELAY);
	
	ADD3_VALID_int(0)<=MULT1_VALID_int(MULT1_DELAY);
	ADD3_VALID_gen: for I in 1 to ADD3_DELAY generate
		ADD3_VALID_delay: FlFl
			port map(D=>ADD3_VALID_int(I-1),Q=>ADD3_VALID_int(I),clk=>clk,RST=>RST);
	end generate;
	ADD3_VALID<=ADD3_VALID_int(ADD3_DELAY);
	
	incrY_int(0)<=ADD3_VALID_int(ADD3_DELAY);
	incrY_gen: for I in 1 to incrY_DELAY generate
		incrY_delay: FlFl
			port map(D=>incrY_int(I-1),Q=>incrY_int(I),clk=>clk,RST=>RST);
	end generate;
	incrY<=incrY_int(incrY_DELAY);

----ADD3_MVin_LE
	ADD3_MVin_LE_nSET_int(0)<=ADD3_MVin_LE_nSET;
	ADD3_MVin_LE_nSET_delay_gen: for I in 1 to nSET_DELAY generate
		ADD3_MVin_LE_nSET_delay: FlFl
			port map(D=>ADD3_MVin_LE_nSET_int(I-1),Q=>ADD3_MVin_LE_nSET_int(I),clk=>clk,RST=>RST);
	end generate;

	ADD3_MVin_LE_register: process(RST,ADD3_MVin_LE_fSET, ADD3_MVin_LE_nSET, ADD3_MVin_LE_fRESET)
	begin
		if ADD3_MVin_LE_fRESET='1' then
			ADD3_MVin_LE_int<='0';
		elsif ADD3_MVin_LE_fSET='1' OR ADD3_MVin_LE_nSET_int(nSET_DELAY)='1'  then
			ADD3_MVin_LE_int<='1';
		else
			ADD3_MVin_LE_int<=ADD3_MVin_LE_int;
		end if;
	end process;
	ADD3_MVin_LE<=ADD3_MVin_LE_int;

----RF_Addr
	RF_Addr_decoding: process(RF_Addr_CU,BestCand)
	begin
		case RF_Addr_CU is
			when "00" =>
				RF_Addr_DP<='0';
			when "01" =>
				RF_Addr_DP<='1';
			when "11" =>
				RF_Addr_DP<=BestCand;
			when OTHERS =>
				RF_Addr_DP<='0';
		end case;
	end process;

----LE_ab
	LE_ab_int(0)<=LE_ab_CU;
	LE_ab_delay_gen: for I in 1 to LE_ab_DELAY generate
		LE_ab_delay: FlFl
			port map(D=>LE_ab_int(I),Q=>LE_ab_int(I+1),clk=>clk,RST=>RST);
	end generate;
	LE_ab_DP<=LE_ab_int(LE_ab_DELAY);

----SAD_tmp_RST
	SAD_tmp_RST_int(0)<=SAD_tmp_RST_CU;
	SAD_tmp_RST_gen: for I in 1 to SAD_tmp_RST_DELAY generate
		SAD_tmp_RST_delay: FlFl
			port map(D=>SAD_tmp_RST_int(I),Q=>SAD_tmp_RST_int(I+1),clk=>clk,RST=>RST);
	end generate;
	SAD_tmp_RST_DP<=SAD_tmp_RST_int(SAD_tmp_RST_DELAY);

----Comp_EN
	Comp_EN_int(0)<=Comp_EN_CU;
	Comp_EN_gen: for I in 1 to Comp_EN_DELAY generate
		Comp_EN_delay: FlFl
			port map(D=>Comp_EN_int(I),Q=>Comp_EN_int(I+1),clk=>clk,RST=>RST);
	end generate;
	Comp_EN_DP<=Comp_EN_int(Comp_EN_DELAY);

	
end architecture beh;