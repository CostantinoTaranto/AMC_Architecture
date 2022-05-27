library IEEE;
use IEEE.std_logic_1164.all;

entity D_min_REG is
	port (D: in std_logic_vector (27 downto 0);
		  RST, clk, LE: in std_logic;
		  Q: out std_logic_vector (27 downto 0));
end entity;

architecture beh of D_min_REG is
	signal Q_int: std_logic_vector (27 downto 0);
begin

	sampling: process(clk, RST)
	begin
		if RST='1' then
			Q_int(27)<= '1';
			Q_int(26 downto 0)<= (others => '0');
		elsif rising_edge(clk) AND LE='1' then
			Q_int<= D;
		else
			Q_int<=Q_int;
		end if;
	end process;

Q<=Q_int;

end architecture beh;
