library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.AMEpkg.all;

entity CU_constructor_netlist is
	port ( START, GOT, CNT_compEN_OUT, CNT_STOPcompEN_OUT: in std_logic;
		   clk, CU_RST: in std_logic;
		   RST, RSH_LE, cmd_SH_EN, READY, DONE, CE_compEN, CE_STOPcompEN, compEN: out std_logic;
		   PS_out, NS_out: out std_logic_vector(2 downto 0));
end entity;

architecture beh of CU_constructor_netlist is

	--type CU_constructor_state is (ON_RESET, IDLE, CONSTRUCT, WF_SH, STOP_SHIFT, COMPARE, STOP_COMPARE, COMPLETE);
	--type CU_constructor_state is ("000",    "001", "010",     "011",  "100",     "101",     "110",      "111");
	signal PS, NS : std_logic_vector(2 downto 0);	--Present State, Next State

	signal START_int, GOT_int, CNT_compEN_OUT_int, CNT_STOPcompEN_OUT_int: std_logic;

begin

----INPUT SAMPLING

	START_sampling: FlFl
		port map(D=>START,Q=>START_int,clk=>clk,RST=>CU_RST);
	GOT_sampling: FlFl
		port map(D=>GOT,Q=>GOT_int,clk=>clk,RST=>CU_RST);
	CNT_compEN_OUT_sampling: FlFl
		port map(D=>CNT_compEN_OUT,Q=>CNT_compEN_OUT_int,clk=>clk,RST=>CU_RST);
	CNT_STOPcompEN_OUT_sampling: FlFl
		port map(D=>CNT_STOPcompEN_OUT,Q=>CNT_STOPcompEN_OUT_int,clk=>clk,RST=>CU_RST);

----PRESENT STATE REGISTER
	present_state_REG: process(clk,CU_RST)
		begin
			if CU_RST='1' then
				PS<="000";
			elsif rising_edge(clk) then
				PS<=NS;
			--else
				--PS<=PS;
			end if;
	end process;

----NEXT STATE CALCULATION
	next_state_calc: process(PS,START_int,GOT_int,CNT_compEN_OUT_int, CNT_STOPcompEN_OUT_int)
	begin
		case PS is
			when "000" =>
				NS<="001";
			when "001" =>
				if START_int='1' then
					NS<="010";
				else
					NS<="001";
				end if;
			when "010" =>
				NS<="011";
			when "011" =>
				NS<="100";
			when "100" =>
				if CNT_compEN_OUT_int='1' then
					NS<="101";
				else
					NS<="100";
				end if;
			when "101" =>
				if CNT_STOPcompEN_OUT_int='1' then
					NS<="110";
				else
					NS<="101";
				end if;
			when "110" =>
				NS<="111";			
			when "111" =>
				if GOT_int='1' then
					NS<="001";
				else
					NS<="111";
				end if;	
			when OTHERS =>
				NS<="000";
		end case;
	end process;

----OUTPUT CALCULATION
	output_calulation: process (PS)
	begin
		case PS is
			when "000" =>
				RST<='1';
				READY<='0';
				RSH_LE<='0';
				cmd_SH_en<='0';
				CE_compEN<='0';
				CE_STOPcompEN<='0';
				compEN<='0';
				DONE<='0';
			when "001" =>
				RST<='1';
				READY<='1';
				RSH_LE<='1';
				cmd_SH_en<='0';
				CE_compEN<='0';
				CE_STOPcompEN<='0';
				compEN<='0';
				DONE<='0';
			when "010" =>
				RST<='0';
				READY<='0';
				RSH_LE<='0';
				cmd_SH_en<='1';
				CE_compEN<='0';
				CE_STOPcompEN<='0';
				compEN<='0';
				DONE<='0';
			when "011" =>
				RST<='0';
				READY<='0';
				RSH_LE<='0';
				cmd_SH_en<='1';
				CE_compEN<='0';
				CE_STOPcompEN<='0';
				compEN<='0';
				DONE<='0';
			when "100" =>
				RST<='0';
				READY<='0';
				RSH_LE<='0';
				cmd_SH_en<='0';
				CE_compEN<='1';
				CE_STOPcompEN<='0';
				compEN<='0';
				DONE<='0';
			when "101" =>
				RST<='0';
				READY<='0';
				RSH_LE<='0';
				cmd_SH_en<='0';
				CE_compEN<='0';
				CE_STOPcompEN<='1';
				compEN<='1';
				DONE<='0';
			when "110" =>
				RST<='0';
				READY<='0';
				RSH_LE<='0';
				cmd_SH_en<='0';
				CE_compEN<='0';
				CE_STOPcompEN<='0';
				compEN<='0';
				DONE<='0';
			when "111" =>
				RST<='0';
				READY<='0';
				RSH_LE<='0';
				cmd_SH_en<='0';
				CE_compEN<='0';
				CE_STOPcompEN<='0';
				compEN<='0';
				DONE<='1';
			when OTHERS =>
				RST<='1';
				READY<='0';
				RSH_LE<='0';
				cmd_SH_en<='0';
				CE_compEN<='0';
				CE_STOPcompEN<='0';
				compEN<='0';
				DONE<='0';
		end case;
	end process;				

	--Output connection for debugging
	PS_out<=PS;
	NS_out<=NS;

end architecture beh;

	

	
