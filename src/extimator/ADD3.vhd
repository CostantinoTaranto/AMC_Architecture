library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.AMEpkg.all;

entity ADD3 is
	generic (N: integer);
	port( op1,op2,op3: in std_logic_vector (N-1 downto 0);
		  VALID, RST, clk: in std_logic;
		  sum: out std_logic_vector (N+1 downto 0)
		);
end entity;

architecture beh of ADD3 is

	signal count, op_sel: std_logic;
	signal add1_int, add2_int, add_out_samp: std_logic_vector(N+1 downto 0);
	signal add_out: std_logic_vector (N+2 downto 0);

begin

	counter: process(clk,RST)
	begin
		if RST='1' then
			count<= '0';
		elsif rising_edge(clk) and VALID='1' then
			count<= NOT count;
		else
			count<=count;
		end if;
	end process;

	--Adder input selection
	op_sel<=count;
	add1_int(N-1 downto 0)<= op1 when op_sel='0' else op3;
	add1_int(N+1 downto N)<= (others => add1_int(N-1));
	add2_int(N-1 downto 0)<= op2 when op_sel='0' else add_out_samp(N-1 downto 0);
	add2_int(N+1 downto N)<= (others => add2_int(N-1)) when op_sel='0' else add_out_samp(N+1 downto N);

	--Adder
	partial_adder: adder
		generic map(N=>N+2)
		port map(add1_int,add2_int,add_out);

	--Adder feedback register
	add_out_sampling: REG_N
		generic map(N=>N+2)
		port map(D=>add_out(N+1 downto 0),Q=>add_out_samp,clk=>clk,RST=>RST);
	
	--Output register

	output_register: REG_N_LE
		generic map(N=> N+2)
		port map(D=>add_out(N+1 downto 0),Q=>sum,clk=>clk,RST=>RST,LE=>count);

	

end architecture beh;

