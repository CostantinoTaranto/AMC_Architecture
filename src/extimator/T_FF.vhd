library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity T_FF is
	port( T: in std_logic;
		  clk, RST: in std_logic;
		  Q: out std_logic);
end T_FF;
 
architecture Behavioral of T_FF is
	signal tmp: std_logic;
begin

	counter: process(clk,RST)
	begin
		if RST='1' then
			tmp<= '0';
		elsif rising_edge(clk) and T='1' then
			tmp<= NOT tmp;
		else
			tmp<=tmp;
		end if;
	end process;

	Q <= tmp;

end Behavioral;
