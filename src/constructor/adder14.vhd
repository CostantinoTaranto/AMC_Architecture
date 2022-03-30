library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity adder14 is
	port	( op1, op2:	in std_logic_vector(13 downto 0);
			  sum:		out std_logic_vector(14 downto 0));
end entity;

architecture rtl of adder14 is
begin
	sum <= std_logic_vector(signed(op1)+signed(op2));

end architecture rtl;
