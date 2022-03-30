library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--Differently from the RS_B2, the LS_B2 keeps all the
--digits after the shift
entity LS_B2 is
	generic ( N: integer);
	port ( LS_in: in std_logic_vector( N-1 downto 0);
		   cmd:   in std_logic_vector( 1 downto 0);
		   LS_out:out std_logic_vector( N+1 downto 0));
end entity;

architecture rtl of LS_B2 is
	signal LS_out_tmp: std_logic_vector( N+1 downto 0);
begin

	shift_op: process(LS_in,cmd)
			  	variable cmd_int: integer;
			  begin
				cmd_int := to_integer(unsigned(cmd));
				LS_out_tmp <= std_logic_vector(shift_left(signed(LS_in),cmd_int));
			  end process;

LS_out<=LS_out_tmp;

end architecture rtl;
