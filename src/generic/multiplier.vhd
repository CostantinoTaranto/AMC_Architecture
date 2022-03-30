library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity multiplier is
	generic ( N: integer);
	port 	( op1, op2:	in std_logic_vector(N-1 downto 0);
		  product:		out std_logic_vector((2*N)-1 downto 0));
end entity;

architecture rtl of multiplier is
begin
	product <= std_logic_vector(signed(op1)*signed(op2));

end architecture rtl;
