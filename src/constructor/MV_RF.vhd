library IEEE;
use IEEE.std_logic_1164.all;

entity MV_RF is
	port( MV_in:  in  std_logic_vector(10 downto 0);	
		  clk, RST, LE: std_logic;
		  MV_out: out std_logic_vector(10 downto 0)	--Same
		);
end entity;

architecture beh of MV_RF is
	signal MV_out_int: std_logic_vector(10 downto 0);
begin

	MV_sampling: process(clk,RST)
	begin
		--Asynchronous reset
		if (RST='1') then
			MV_out_int<= "00000000000";
		elsif rising_edge(clk) AND LE='1' then
			MV_out_int<=MV_in;
		--else
			--MV_out_int<=MV_out_int;
		end if;
	end process;

MV_out<=MV_out_int;

end architecture beh;
