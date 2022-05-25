library IEEE;
use IEEE.std_logic_1164.all;

entity signed_Lshifter is
	generic (N_in, N_out: integer);
	port	(SH_in:	 in  std_logic_vector (N_in-1 downto 0);
			 clk, SH_EN, LE, RST: in std_logic;
			 SH_out: out std_logic_vector (N_out-1 downto 0)
			 );
end entity;

architecture beh of signed_Lshifter is
	signal SH_out_int: std_logic_vector(N_out-1 downto 0);
begin
	shifting: process(clk,SH_EN)
	begin
		--Asynchronous reset
		if (RST='1') then
			SH_out<= (others => '0');
		elsif rising_edge(clk) then
			if LE='1' AND SH_EN='1' then
				SH_out_int(N_out-1 downto N_in+1)<= (others => SH_in(N_in-1));
				SH_out_int(N_in downto 1)<=SH_in(N_in-1 downto 0);
				SH_out_int(0)<='0';
			elsif LE='1'then
				SH_out_int(N_in-1 downto 0)<=SH_in;
				SH_out_int(N_out-1 downto N_in)<= (others => SH_in(N_in-1));
			else
				SH_out_int<=SH_out_int;
			end if;
		end if;
	end process;

SH_out<=SH_out_int;

end architecture beh;

