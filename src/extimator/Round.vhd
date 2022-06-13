library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--The rounding operation is "round to nearest in magnitude", examples:
-- 1.5 -> 2
-- -1.5 -> -2
-- 5.3 -> 5
-- -5.3 -> -5

entity Round is
	port (round_in: in std_logic_vector (19 downto 0);
		  round_out: out std_logic_vector (11 downto 0));
end entity;

architecture struct of Round is

	signal input_sign, high_frac_part, at_least_another_one : std_logic;
	signal lsb_ext: std_logic_vector(11 downto 0);
	signal round_up, truncate: std_logic_vector(11 downto 0);

begin

	input_sign<=round_in(19);
	
	at_least_another_one <= round_in(6) OR round_in(5) OR round_in(4) OR round_in(3) OR round_in(2) OR round_in(1) OR round_in(0);
	high_frac_part<= round_in(7) AND at_least_another_one;

	lsb_ext(11 downto 1)<= (others=>'0');
	lsb_ext(0)<= round_in(7);	

	round_up <=  std_logic_vector(signed(round_in(19 downto 8))+signed(lsb_ext));
	truncate <=  round_in(19 downto 8);

	--Depending on the number sign, it is rounded in a different way
	round_out<= round_up when (input_sign='0' OR high_frac_part='1') else truncate;

end architecture struct;
