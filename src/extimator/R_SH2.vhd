library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.AMEpkg.all;

entity R_SH2 is
	generic(N: integer);
	port( SH_in: in std_logic_vector(N-1 downto 0);
		  clk, LE, RST: in std_logic;
		  shift_amt: std_logic_vector(1 downto 0);
		  SH_out: out std_logic_vector(N-1 downto 0));
end entity;

architecture struct of R_SH2 is
	signal SH_in_int : std_logic_vector (N-1 downto 0);
	signal SH_en1, SH_en2: std_logic;
begin

	--First shifter
	SH_en1<=shift_amt(0) OR shift_amt(1); 
	first_shifter: signed_shifter
		generic map(N=>N)
		port map(SH_in=>SH_in,clk=>clk,SH_EN=>SH_en1,LE=>LE,RST=>RST,SH_out=>SH_in_int);

	--Second shifter
	SH_en2_gen: FlFl
		port map(D=>shift_amt(1),Q=>SH_en2,clk=>clk,RST=>RST);
	second_shifter: signed_shifter
		generic map(N=>N)
		port map(SH_in=>SH_in_int,clk=>clk,SH_EN=>SH_en2,LE=>LE,RST=>RST,SH_out=>SH_out);

end architecture struct;
