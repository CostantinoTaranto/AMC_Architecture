--Why the need of an unsigned adder?
--Because the extension operation on the addends is performed without sign
--here, notice that just a '0' is inserted in op(1,2)_ext

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity unsigned_adder is
	generic ( N: integer);
	port	( op1, op2:	in std_logic_vector(N-1 downto 0);
			  sum:		out std_logic_vector(N downto 0));
end entity;

architecture rtl of unsigned_adder is

	signal op1_ext, op2_ext: std_logic_vector(N downto 0);

begin

	op1_ext<= '0' & op1;
	op2_ext<= '0' & op2;
	sum <= std_logic_vector(unsigned(op1_ext)+unsigned(op2_ext));

end architecture rtl;
