--This is a counter with an asynchronous reset.
--When the counter reaches N, the flag COUNT out is set to high

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity COUNT_N is
	generic (N,TARGET: integer);
	port (CE, RST, clk: 	in std_logic;
		  COUNT_OUT:out std_logic);
end entity;

architecture beh of COUNT_N is
	signal count: std_logic_vector(N-1 downto 0);
begin

	counter: process(clk,RST)
	begin
		if RST='1' then
			count<= (others=>'0');
		elsif rising_edge(clk) and CE='1' then
			count<=std_logic_vector(unsigned(count)+1);
		else
			count<=count;
		end if;
	end process;

	--Output flag condition
	COUNT_OUT<= '1' WHEN (unsigned(count)=TARGET) else '0'; 
	
end architecture beh;
