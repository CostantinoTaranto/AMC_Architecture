library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sign_extender is
	generic ( N_in, N_out: integer);
	port	( toExtend: std_logic_vector( N_in-1 downto 0);
			  extended: std_logic_vector( N_out-1 downto 0));
end entity;

architecture rtl of sign_extender is
	signal extension : std_logic_vector( N_out-N_in-1 downto 0);
begin

	extension <= (others => toExtend(N_in-1));
	extended  <= extension & toExtend;						

end architecture rtl;

