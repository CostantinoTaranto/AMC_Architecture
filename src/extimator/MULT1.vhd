library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.AMEpkg.all;

entity MULT1 is
	generic ( N: integer);
	port 	( op1, op2:	in std_logic_vector(N-1 downto 0);
			  VALID, RST,clk : in std_logic; --For the internal signals and sequential components
		  	  product:		out std_logic_vector((2*N)-1 downto 0));
end entity;

architecture beh of MULT1 is

	signal count_int, MSBs, is_signed: std_logic_vector(1 downto 0);
	signal hit_int, result_LE, int_LE, int_shEN, product_int_rst: std_logic;
	signal SUM_rst: std_logic_vector(2 downto 0);
	signal op1_int, op2_int: std_logic_vector(N/2 downto 0);
	signal mult_int, add1, add2: std_logic_vector(N+1 downto 0);
	signal add_out: std_logic_vector(N+2 downto 0);	--The ouput of an adder with two inputs on 14 bits is on 15 bits. The MSB will be discarded in the DP
	signal product_int: std_logic_vector(2*N+1 downto 0);
	signal product_tmp: std_logic_vector((2*N)-1 downto 0);

begin

------MSBs and is_signed generation
	ctrl_sign_gen: COUNT_VAL_N
		generic map(N=>2,TARGET=>3)
		port map(CE=>VALID,RST=>RST,clk=>clk,COUNT=>count_int,HIT=>hit_int);
	
	--MSBs informs if the packet of bits to be multiplied incudes the MSBs (1) or the LSBs (0)
	MSBs<=count_int;
	--is_signed informs if the current packet of bits must be considered signed or not
	is_signed<=count_int;

------Input selection
	--Extract half the number of bits
	op1_int(N/2-1 downto 0) <= op1(N/2-1 downto 0) WHEN MSBs(0)='0' ELSE op1(N-1 downto N/2);
	--If the number is to be considered signed, perform sign extension, otherwise just pad with a zero
	op1_int(N/2)<= op1_int(N/2-1) WHEN is_signed(0)='1' ELSE '0';
	op2_int(N/2-1 downto 0) <= op2(N/2-1 downto 0) WHEN MSBs(1)='0' ELSE op2(N-1 downto N/2);
	op2_int(N/2)<= op2_int(N/2-1) WHEN is_signed(1)='1' ELSE '0';

------Perform multiplication
	mult_int <= std_logic_vector(signed(op1_int)*signed(op2_int));
	
-----Multiplier output sampling
	add1_sampling: REG_N
		generic map(N=>N+2)
		port map(D=>mult_int,Q=>add1,RST=>RST,clk=>clk);

------Partial products sum
	pp_sum: adder
		generic map(N=>N+2)
		port map(op1=>add1,op2=>add2,sum=>add_out);

------Intermiediate register load
	--Internal load enable, for the "intermediate_reg" register
	int_LE_FF: FlFl
		port map(D=>VALID, Q=>int_LE,clk=>clk, RST=>RST);
	--Reset signal for the internal register
	SUM_rst(0)<=hit_int;
	SUM_rst_delay: for I in 1 to 2 GENERATE
		SUM_RST_FFX: FlFl
			port map(D=>SUM_rst(I-1),Q=>SUM_rst(I),clk=>clk,RST=>RST);
	end generate;

	product_int_rst<=RST OR  SUM_rst(1);
	--Shift Enable for the internal register
	int_shEN<=count_int(0);

	inermediate_reg: process(clk,product_int_rst,int_shEN,int_LE)
		begin
			--Synchronous reset (Mandatory, otherwise the register would be reset for two clock
			--cycles). Quando il clock batte il reset è ancora alto e quindi il registro resta resettato
			--per due cicli di clock
			if rising_edge(clk) AND product_int_rst='1' then
				product_int<= ( others=>'0');
			elsif rising_edge(clk) AND int_shEN='1' THEN
				product_int(N/2-1 downto 0)<=product_int(N-1 downto N/2);
				product_int(3*N/2+1 downto N/2)<=add_out(N+1 downto 0);
				product_int(2*N+1 downto 3*N/2+2)<=(others =>add_out(N+1));
			elsif rising_edge(clk) AND int_LE='1' THEN
				product_int(N-1 downto 0)<=product_int(N-1 downto 0);
				product_int(2*N+1 downto N)<=add_out(N+1 downto 0);
			else
				product_int<=product_int;
			end if;
	end process;
	add2<=product_int(2*N+1 downto N);

------Output register loading
	result_LE_FF: FlFl
		port map(D=>hit_int,Q=>result_LE,clk=>clk,RST=>RST);
	product_tmp<= add_out(N-1 downto 0) & product_int(N-1 downto 0);
	output_reg: REG_N_LE
		generic map(N=>2*N)
		port map(D=>product_tmp,Q=>product,RST=>RST,clk=>clk,LE=>result_LE); 


end architecture beh;
