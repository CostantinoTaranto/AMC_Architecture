library IEEE;
use IEEE.std_logic_1164.all;

entity if_UA is
	port ( MV_in: in std_logic_vector (10 downto 0);
		   UA_flag: out std_logic);
end entity;

architecture beh of if_UA is
begin

	UA_flag<= '1' WHEN (MV_in="10000000000") ELSE '0';

end architecture rtl;
