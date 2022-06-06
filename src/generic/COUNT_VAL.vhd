--This is a counter with an asynchronous reset.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity COUNT_VAL is
	generic (N: integer);
	port (CE, RST, clk: 	in std_logic;
		  COUNT: out std_logic_vector(N-1 downto 0));
end entity;

architecture beh of COUNT_VAL is
	signal count_int: std_logic_vector(N-1 downto 0);
begin

	counter: process(clk,RST)
	begin
		if RST='1' then
			count_int<= (others=>'0');
		elsif rising_edge(clk) and CE='1' then
			count_int<=std_logic_vector(unsigned(count_int)+1);
		else
			count_int<=count_int;
		end if;
	end process;

	--Counter output
	COUNT<=count_int;
	
end architecture beh;
