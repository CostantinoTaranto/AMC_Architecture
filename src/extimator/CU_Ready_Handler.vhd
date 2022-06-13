--This component handles the production of the "Ready", "Second_Ready" and "GOT" signals
--It is a separate small CU, it has no input sampling (this makes it more reactive) but this is not a problem since it is
--simpler that the "main" extimator CU

library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.AMEpkg.all;

entity CU_Ready_Handler is
	port( VALID, Ready_RST: in std_logic;
		  clk, RST: in std_logic;
		  READY, Second_Ready, GOT: out std_logic
		);
end entity;

architecture beh of CU_Ready_Handler is

	type CU_Ready_Handler_state is (ON_RESET, IDLE, FC_GOT, SC_GET, SC_GOT, WAIT_RST);

	signal PS, NS: CU_Ready_Handler_state;

begin

----PRESENT STATE REGISTER
	present_state_REG: process(clk,RST)
		begin
			if RST='1' then
				PS<=ON_RESET;
			elsif rising_edge(clk) then
				PS<=NS;
			else
				PS<=PS;
			end if;
	end process;

----NEXT STATE CALCULATION
	next_state_calc: process(VALID, Ready_RST)
	begin
		case PS is
			when ON_RESET =>
				NS<=IDLE;
			when IDLE =>
				if VALID='1' then
					NS<=FC_GOT;
				else
					NS<=IDLE;
				end if;
			when FC_GOT =>
				NS<=SC_GET;
			when SC_GET =>
				if VALID='1' then
					NS<=SC_GOT;
				else
					NS<=SC_GET;
				end if;
			when SC_GOT =>
				NS<=WAIT_RST;
			when WAIT_RST =>
				if Ready_RST='1' then
					NS<= IDLE;
				else
					NS<=WAIT_RST;
				end if;
			when OTHERS =>
				NS<=ON_RESET;
		end case;
	end process;

----OUTPUT CALCULATION
	output_calc: process(PS)
	begin
		case PS is
			when ON_RESET =>
				READY<='0';
				Second_Ready<='0';
				GOT<='0';
			when IDLE =>
				READY<='1';
				Second_Ready<='0';
				GOT<='0';
			when FC_GOT =>
				READY<='0';
				Second_Ready<='0';
				GOT<='0';
			when SC_GET =>
				READY<='1';
				Second_Ready<='0';
				GOT<='0';
			when SC_GOT =>
				READY<='0';
				Second_Ready<='1';
				GOT<='1';
			when WAIT_RST =>
				READY<='0';
				Second_Ready<='1';
				GOT<='0';
			when OTHERS =>
				READY<='0';
				Second_Ready<='0';
				GOT<='0';
		end case;
	end process;
	

end architecture beh;