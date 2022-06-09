library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.AMEpkg.all;

entity CU_extimator is
	port( VALID, last_block_x, last_block_y: in std_logic;
		  last_cand, Second_ready, CountTerm_OUT: in std_logic;
		  clk, CU_RST: in std_logic;
	);
end entity;

architecture beh of CU_extimator is

	type CU_extimator_state is ();
	signal PS, NS: CU_extimator_state;
	

begin

----INPUT SAMPLING

	VALID_samp: FlFl
		port map(D=>VALID,Q=>VALID_int,clk=>clk,RST=>CU_RST);
	last_block_x_samp: FlFl
		port map(D=>last_block_x,Q=>last_block_x_int,clk=>clk,RST=>CU_RST);
	last_block_y_samp: FlFl
		port map(D=>last_block_y,Q=>last_block_y_int,clk=>clk,RST=>CU_RST);
	last_cand_samp: FlFl
		port map(D=>last_cand,Q=>last_cand_int,clk=>clk,RST=>CU_RST);
	Second_ready_samp: FlFl
		port map(D=>Second_ready,Q=>Second_ready_int,clk=>clk,RST=>CU_RST);
	CountTerm_OUT_samp: FlFl
		port map(D=>CountTerm_OUT,Q=>CountTerm_OUT_int,clk=>clk,RST=>CU_RST);

----PRESENT STATE REGISTER
	present_state_REG: process(clk,CU_RST)
		begin
			if CU_RST='1' then
				PS<=ON_RESET;
			elsif rising_edge(clk) then
				PS<=NS;
			else
				PS<=PS;
			end if;
	end process

end architecture;