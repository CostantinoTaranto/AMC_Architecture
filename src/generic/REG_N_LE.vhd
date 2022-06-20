library IEEE;
use IEEE.std_logic_1164.all;

entity REG_N_LE is
	generic (N: integer);
	port( D:  in  std_logic_vector(N-1 downto 0);	
		  clk, RST, LE: std_logic;
		  Q: out std_logic_vector(N-1 downto 0)
		);
end entity;

architecture beh of REG_N_LE is
	signal Q_int: std_logic_vector(N-1 downto 0);
begin

	sampling: process(clk,RST)
	begin
		--Asynchronous reset
		if (RST='1') then
			Q_int<= (others => '0');
		elsif rising_edge(clk) AND LE='1' then
			Q_int<=D;
		--else
			--Q_int<=Q_int;
		end if;
	end process;

Q<=Q_int;

end architecture beh;
