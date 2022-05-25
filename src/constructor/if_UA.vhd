library IEEE;
use IEEE.std_logic_1164.all;

entity if_UA is
	port ( MV_in_h, MV_in_v: in std_logic_vector (10 downto 0);
		   UA_flag: out std_logic);
end entity;

architecture beh of if_UA is
	signal UA1, UA2: std_logic;

begin

	UA1<= '1' WHEN (MV_in_h="10000000000") ELSE '0';
	UA2<= '1' WHEN (MV_in_v="10000000000") ELSE '0';

	UA_flag<= UA1 OR UA2;

end architecture beh;
