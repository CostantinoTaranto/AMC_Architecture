library IEEE;
use IEEE.std_logic_1164.all;

entity FlFl_LE is
	port (D, RST, clk, LE: in std_logic;
		  Q: out std_logic);
end entity;

architecture beh of FlFl_LE is
	signal Q_int: std_logic;
begin

	sampling: process(clk, RST)
	begin
		if RST='1' then
			Q_int<= '0';
		elsif rising_edge(clk) AND LE='1' then
			Q_int<= D;
		else
			Q_int<=Q_int;
		end if;
	end process;

Q<=Q_int;

end architecture beh;
