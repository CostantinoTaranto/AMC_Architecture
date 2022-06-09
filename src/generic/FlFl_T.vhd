--This is a toggle flip flop with an asynchronous reset.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity FlFl_T is
	port (T, RST, clk: 	in std_logic;
		  Q: out std_logic);
end entity;

architecture beh of FlFl_T is
	signal Q_int: std_logic;
begin

	counter: process(clk,RST)
	begin
		if RST='1' then
			Q_int<= '0';
		elsif rising_edge(clk) and T='1' then
			Q_int<= NOT Q_int;
		else
			Q_int<=Q_int;
		end if;
	end process;

	Q<=Q_int;
	
end architecture beh;
