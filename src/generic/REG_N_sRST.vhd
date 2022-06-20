--N bit register with synchronous reset

library IEEE;
use IEEE.std_logic_1164.all;

entity REG_N_sRST is
	generic (N: integer);
	port (D: in std_logic_vector (N-1 downto 0);
		  sRST, clk: in std_logic;
		  Q: out std_logic_vector (N-1 downto 0));
end entity;

architecture beh of REG_N_sRST is
	signal Q_int: std_logic_vector (N-1 downto 0);
begin

	sampling: process(clk, sRST)
	begin
		if rising_edge(clk) then
			if sRST='1' then
				Q_int<= (others => '0');
			else
				Q_int<= D;
			end if;		
		--else
			--Q_int<=Q_int;
		end if;
	end process;

Q<=Q_int;

end architecture beh;
