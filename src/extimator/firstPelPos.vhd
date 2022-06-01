--This block computes both components of the position of the first pixel in a block
--for a CU of a given size
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity firstPelPos is
	port ( CE_REPx, CE_BLKx, RST_BLKx, clk, RST: in std_logic;
		   CE_REPy, CE_BLKy, RST_BLKy : in std_logic;
		   CU_w, CU_h: in std_logic_vector(1 downto 0);
		   last_block_x, last_block_y:  out std_logic;
		   x0, y0: out std_logic_vector( 5 downto 0)	
		  );
end entity;

architecture structural of firstPelPos is

	component firstPelPos_comp is
	port ( CE_REP, CE_BLK, RST_BLK, clk, RST: in std_logic;
		   CU_dim: in std_logic_vector(1 downto 0);
		   last_block: out std_logic;
		   comp0: out std_logic_vector( 5 downto 0)	--"component0" (can be x or y)
		  );
	end component;

begin

	firstPelPos_x: firstPelPos_comp
		port map (CE_REPx, CE_BLKx, RST_BLKx, clk, RST, CU_w, last_block_x, x0);

	firstPelPos_y: firstPelPos_comp
		port map (CE_REPy, CE_BLKy, RST_BLKy, clk, RST, CU_h, last_block_y, y0);

end architecture structural;
