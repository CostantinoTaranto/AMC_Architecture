library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.AMEpkg.all;

entity CU_constructor is
	port ( START, GOT, CNT_compEN_OUT, CNT_STOPcompEN_OUT: in std_logic;
		   clk, CU_RST: in std_logic;
		   RST, RSH_LE, cmd_SH_EN, READY, DONE, CE_compEN, CE_STOPcompEN, compEN: out std_logic);
end entity;

architecture beh of CU_constructor is

	type CU_constructor_state is (ON_RESET, IDLE, CONSTRUCT, WF_SH, STOP_SHIFT, COMPARE, STOP_COMPARE, COMPLETE);
	signal PS, NS : CU_constructor_state;	--Present State, Next State

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
				PS<=ON_RESET;
			elsif rising_edge(clk) then
				PS<=NS;
			else
				PS<=PS;
			end if;
	end process;

----NEXT STATE CALCULATION
	next_state_calc: process(PS,START_int,GOT_int,CNT_compEN_OUT_int, CNT_STOPcompEN_OUT_int)
	begin
		case PS is
			when ON_RESET =>
				NS<=IDLE;
			when IDLE =>
				if START_int='1' then
					NS<=CONSTRUCT;
				else
					NS<=IDLE;
				end if;
			when CONSTRUCT =>
				NS<=WF_SH;
			when WF_SH =>
				NS<=STOP_SHIFT;
			when STOP_SHIFT =>
				if CNT_compEN_OUT_int='1' then
					NS<=COMPARE;
				else
					NS<=STOP_SHIFT;
				end if;
			when COMPARE =>
				if CNT_STOPcompEN_OUT_int='1' then
					NS<=STOP_COMPARE;
				else
					NS<=COMPARE;
				end if;
			when STOP_COMPARE =>
				NS<=COMPLETE;			
			when COMPLETE =>
				if GOT_int='1' then
					NS<=IDLE;
				else
					NS<=COMPLETE;
				end if;	
			when OTHERS =>
				NS<=ON_RESET;
		end case;
	end process;

----OUTPUT CALCULATION
	output_calulation: process (PS)
	begin
		case PS is
			when ON_RESET =>
				RST<='1';
				READY<='0';
				RSH_LE<='0';
				cmd_SH_en<='0';
				CE_compEN<='0';
				CE_STOPcompEN<='0';
				compEN<='0';
				DONE<='0';
			when IDLE =>
				RST<='1';
				READY<='1';
				RSH_LE<='1';
				cmd_SH_en<='0';
				CE_compEN<='0';
				CE_STOPcompEN<='0';
				compEN<='0';
				DONE<='0';
			when CONSTRUCT =>
				RST<='0';
				READY<='0';
				RSH_LE<='0';
				cmd_SH_en<='1';
				CE_compEN<='0';
				CE_STOPcompEN<='0';
				compEN<='0';
				DONE<='0';
			when WF_SH =>
				RST<='0';
				READY<='0';
				RSH_LE<='0';
				cmd_SH_en<='1';
				CE_compEN<='0';
				CE_STOPcompEN<='0';
				compEN<='0';
				DONE<='0';
			when STOP_SHIFT =>
				RST<='0';
				READY<='0';
				RSH_LE<='0';
				cmd_SH_en<='0';
				CE_compEN<='1';
				CE_STOPcompEN<='0';
				compEN<='0';
				DONE<='0';
			when COMPARE =>
				RST<='0';
				READY<='0';
				RSH_LE<='0';
				cmd_SH_en<='0';
				CE_compEN<='0';
				CE_STOPcompEN<='1';
				compEN<='1';
				DONE<='0';
			when STOP_COMPARE =>
				RST<='0';
				READY<='0';
				RSH_LE<='0';
				cmd_SH_en<='0';
				CE_compEN<='0';
				CE_STOPcompEN<='0';
				compEN<='0';
				DONE<='0';
			when COMPLETE =>
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

end architecture beh;

	

	
