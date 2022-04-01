library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity adder is
	generic ( N: integer);
	port	( op1, op2:	in std_logic_vector(N-1 downto 0);
			  sum:		out std_logic_vector(N downto 0));
end entity;

architecture rtl of adder is

	signal op1_ext, op2_ext: std_logic_vector(N downto 0);

begin

	op1_ext<= op1(N-1) & op1;
	op2_ext<= op2(N-1) & op2;
	sum <= std_logic_vector(signed(op1_ext)+signed(op2_ext));

end architecture rtl;
