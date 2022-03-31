library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_LS_RS_B2 is
end entity;

architecture tb of tb_LS_RS_B2 is

	component LS_RS_B2 is
	port ( SH_in: in  std_logic_vector(11 downto 0);
		   SH_cmd:in  std_logic_vector(2  downto 0); 
		   SH_out:out std_logic_vector(13 downto 0));
	end component;

	signal SH_in_t:  std_logic_vector(11 downto 0);
	signal SH_cmd_t: std_logic_vector(2  downto 0); 
	signal SH_out_t: std_logic_vector(13 downto 0); 

begin

	uut: LS_RS_B2
		port map(SH_in_t, SH_cmd_t, SH_out_t);

	stimuli:process
	begin
		wait for 4 ns;
		SH_in_t <="100110110001";
		SH_cmd_t<="010";
		wait for 2 ns;
		SH_in_t <="000110110001";
		SH_cmd_t<="110";
		wait for 2 ns;
		SH_in_t <="000110110001";
		SH_cmd_t<="001";
		wait for 2 ns;
		SH_in_t <="000110110001";
		SH_cmd_t<="110";
		wait for 2 ns;
		SH_in_t <="100110100001";
		SH_cmd_t<="100";
		wait for 2 ns;
		SH_in_t <="000110110001";
		SH_cmd_t<="000";
		wait for 2 ns;
		SH_in_t <="100110110001";
		SH_cmd_t<="010";
		wait for 2 ns;
		SH_in_t <="100110110001";
		SH_cmd_t<="101";
		wait;
	end process;
		

end architecture tb;
