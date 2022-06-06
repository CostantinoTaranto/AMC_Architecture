library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity abs_unit is
	generic ( N: integer);
	port	( abs_in:	in std_logic_vector(N-1 downto 0);
			  abs_out:		out std_logic_vector(N-2 downto 0));
end entity;

architecture rtl of abs_unit is

	signal abs_out_pos, abs_out_neg: std_logic_vector(N-2 downto 0);

begin

	abs_out_pos<= abs_in(N-2 downto 0);
	abs_out_neg<= std_logic_vector(unsigned(not(abs_in(N-2 downto 0))) + 1);
	abs_out <= abs_out_neg WHEN abs_in(N-1)='1' ELSE abs_out_pos;

end architecture rtl;
