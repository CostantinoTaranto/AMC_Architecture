library IEEE;
use IEEE.std_logic_1164.all;

entity signed_shifter is
	generic (N: integer);
	port	(SH_in:	 in  std_logic_vector (N-1 downto 0);
			 clk, SH_EN, LE, RST: in std_logic;
			 SH_out: out std_logic_vector (N-1 downto 0)
			 );
end entity;

architecture beh of signed_shifter is
	signal SH_out_int: std_logic_vector(N-1 downto 0);
begin
	shifting: process(clk,SH_EN)
	begin
		--Asynchronous reset
		if (RST='1') then
			SH_out_int<= (others => '0');
		elsif rising_edge(clk) then
			if LE='1' AND SH_EN='1' then
				SH_out_int(N-2 downto 0)<=SH_in(N-1 downto 1);
				SH_out_int(N-1)<=SH_in(N-1);
			elsif LE='1'then
				SH_out_int<=SH_in;
			else
				SH_out_int<=SH_out_int;
			end if;
			
		end if;
	end process;

SH_out<=SH_out_int;

end architecture beh;

