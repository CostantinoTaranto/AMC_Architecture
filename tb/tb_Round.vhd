library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_Round is
end entity;

architecture tb of tb_Round is

	component Round is
		generic (N: integer);
		port (round_in: in std_logic_vector (N downto 0);
			  round_out: out std_logic_vector (N-1 downto 0));
	end component;
	
	signal round_in_t:  std_logic_vector(4 downto 0);
	signal round_out_t: std_logic_vector(3 downto 0);

	constant Tc: time := 2 ns;

begin

	uut: Round
		generic map(N=>4)
		port map(round_in_t,round_out_t);

	stimuli:process
	begin
		wait for 3*Tc;
		round_in_t<="10010";
		wait for Tc;
		round_in_t<="01001";
		wait for Tc;
		round_in_t<="00001";
		wait for Tc;
		round_in_t<="10000";
		wait for Tc;
		round_in_t<="01010";
		wait for Tc;
		round_in_t<="10101";
		wait for Tc;
		round_in_t<="11111";
		wait for Tc;
		round_in_t<="00000";
		wait;
	end process;
		

end architecture tb;
