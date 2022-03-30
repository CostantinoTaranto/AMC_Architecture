library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity comparator is
	generic ( N: integer);
	port	( in_pos, in_neg:	in std_logic_vector(N-1 downto 0);
			  isGreater:		out std_logic);
end entity;

architecture rtl of comparator is
begin
	isGreater <= 1 when (unsigned(in_pos) > unsigned(in_neg)) else 0; 

end architecture rtl;
