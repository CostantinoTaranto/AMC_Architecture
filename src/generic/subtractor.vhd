library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity subtractor is
	generic ( N: integer);
	port 	( minuend, subtrahend:	in std_logic_vector(N-1 downto 0);
		  subtraction:		out std_logic_vector(N downto 0));
end entity;

architecture rtl of subtractor is

	signal minuend_ext, subtrahend_ext: std_logic_vector(N downto 0);

begin

	minuend_ext 	<= minuend(N-1) 	& minuend;
	subtrahend_ext	<= subtrahend(N-1)	& subtrahend;
	subtraction <= std_logic_vector(signed(minuend_ext)-signed(subtrahend_ext));

end architecture rtl;
