-- Counter with synchronous RST and CE
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cnt_RSTs_CEs is
	generic ( N: integer);
	port 	(	clk, CE, RST: in std_logic;
				count: out std_logic_vector (N-1 downto 0)
			);
end entity; 

architecture beh of cnt_RSTs_CEs is
	signal count_tmp: std_logic_vector(N-1 downto 0);
begin

	counting: process(clk,CE,RST)
	begin
		if rising_edge(clk) then
			if RST='1' then
				count_tmp<=(others => '0');
			elsif CE='1' then
				count_tmp<=std_logic_vector(unsigned(count_tmp)+1);
			end if;
		end if;
	end process;

count<=count_tmp;

end architecture beh;	
