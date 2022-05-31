library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--The rounding operation is "round to nearest in magnitude", examples:
-- 1.5 -> 2
-- -1.5 -> -2
-- 5.3 -> 5
-- -5.3 -> -5
--We assume that the input data is in the form XXXXX.X where ".X" is the part to be discarded.

entity Round is
	generic (N: integer);
	port (round_in: in std_logic_vector (N downto 0);
		  round_out: out std_logic_vector (N-1 downto 0));
end entity;

architecture struct of Round is

	--To add the (LSB-1)th digit, it is necessary to extend it in this signal
	signal lsb_1_ext, round_up, round_down: std_logic_vector(N-1 downto 0);

begin

	lsb_1_ext(N-1 downto 1)<= (others=>'0');
	lsb_1_ext(0)<= round_in(0);	

	round_up <=  std_logic_vector(signed(round_in(N downto 1))+signed(lsb_1_ext));
	round_down<= std_logic_vector(signed(round_in(N downto 1))-signed(lsb_1_ext));

	--Depending on the number sign, it is rounded in a different way
	round_out<= round_up when round_in(N)='0' else round_down;

end architecture struct;
