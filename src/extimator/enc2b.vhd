--This encoder computes the number 16x16 blocks in a CU (for w or h)
--by looking at the 2 MSBs of w or h
library IEEE;
use IEEE.std_logic_1164.all;

entity enc2b is
	port ( enc_in: 	in std_logic_vector ( 1 downto 0);
		   enc_out: out std_logic_vector ( 1 downto 0)
		);
end entity;

architecture structural of enc2b is
begin

	enc_out(1)<= enc_in(1);
	enc_out(0)<= enc_in(0) xor enc_in(1);

end architecture structural;
