library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity unsigned_subtractor is
	generic ( N: integer);
	port 	( minuend, subtrahend:	in std_logic_vector(N-1 downto 0);
		  subtraction:		out std_logic_vector(N downto 0));
end entity;

architecture rtl of unsigned_subtractor is

	signal minuend_ext, subtrahend_ext: std_logic_vector(N downto 0);

begin

	minuend_ext 	<= '0'	& minuend;
	subtrahend_ext	<= '0'	& subtrahend;
	subtraction <= std_logic_vector(signed(minuend_ext)-signed(subtrahend_ext));

end architecture rtl;
