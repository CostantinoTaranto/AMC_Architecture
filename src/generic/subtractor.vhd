library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity subtractor is
	generic ( N: integer);
	port 	( minuend, subtrahend:	in std_logic_vector(N-1 downto 0);
		  subtraction:		out std_logic_vector(N downto 0));
end entity;

architecture rtl of subtractor is
begin
	subtraction <= std_logic_vector(signed(minuend)-signed(subtrahend));

end architecture rtl;
