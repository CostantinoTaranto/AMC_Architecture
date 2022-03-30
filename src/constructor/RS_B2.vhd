library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RS_B2 is
	generic ( N: integer);
	port ( RS_in: in std_logic_vector( N-1 downto 0);
		   cmd:   in std_logic_vector( 1 downto 0);
		   RS_out:out std_logic_vector( N-1 downto 0));
end entity;

architecture rtl of RS_B2 is
	signal RS_out_tmp: std_logic_vector( N-1 downto 0);
begin

	shift_op: process(RS_in,cmd)
			  	variable cmd_int: integer;
			  begin
				cmd_int := to_integer(unsigned(cmd));
				RS_out_tmp <= std_logic_vector(shift_right(unsigned(RS_in),cmd_int));
			  end process;

end architecture rtl;
