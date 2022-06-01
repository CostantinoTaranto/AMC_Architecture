library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_firstPelPos is
end entity;

architecture tb of tb_firstPelPos is

	component firstPelPos is
	port ( CE_REPx, CE_BLKx, RST_BLKx, clk, RST: in std_logic;
		   CE_REPy, CE_BLKy, RST_BLKy : in std_logic;
		   CU_w, CU_h: in std_logic_vector(1 downto 0);
		   last_block_x, last_block_y:  out std_logic;
		   x0, y0: out std_logic_vector( 5 downto 0)	
		  );
	end component;
	
	signal CE_REPx_t, CE_BLKx_t, RST_BLKx_t, clk, RST_t: std_logic;
	signal CE_REPy_t, CE_BLKy_t, RST_BLKy_t : std_logic;
	signal CU_w_t, CU_h_t: std_logic_vector(1 downto 0);
	signal last_block_x_t, last_block_y_t:  std_logic;
	signal x0_t, y0_t: std_logic_vector( 5 downto 0);

	constant Tc: time := 2 ns;

begin

	uut: firstPelPos
		port map(CE_REPx_t, CE_BLKx_t, RST_BLKx_t, clk, RST_t, CE_REPy_t, CE_BLKy_t, RST_BLKy_t, CU_w_t, CU_h_t, last_block_x_t, last_block_y_t, x0_t, y0_t);

	clock_gen: process
	begin
		clk<='0';
		wait for Tc/2;
		clk<='1';
		wait for Tc/2;
	end process;
		
	stimuli:process
	begin
		RST_t<='0';
		wait for 2*Tc;
		RST_t<='1';
		wait for Tc;
		RST_t<='0';
		CU_w_t<="00";	--16x16 CU
		CU_h_t<="00";
		CE_REPx_t<='0';
		CE_BLKx_t<='0';
		RST_BLKx_t<='0';
		CE_REPy_t<='0';
		CE_BLKy_t<='0';
		RST_BLKy_t<='0';
		wait for 3*Tc;
		CE_REPx_t<='1';
		wait for Tc;
		CE_REPx_t<='0';
		wait for 3*Tc;
		CE_REPx_t<='1';
		CE_REPy_t<='1';
		wait for Tc;
		CE_REPx_t<='0';
		CE_REPy_t<='0';
		wait for 3*Tc;
		CE_REPx_t<='1';
		wait for Tc;
		CE_REPx_t<='0';
		wait for 3*Tc;
		CE_REPx_t<='1';
		CE_REPy_t<='1';
		RST_BLKx_t<='1';
		RST_BLKy_t<='1';
		wait for Tc;
		RST_t<='0';
		CU_w_t<="00";
		CU_h_t<="00";
		CE_REPx_t<='0';
		CE_BLKx_t<='0';
		RST_BLKx_t<='0';
		CE_REPy_t<='0';
		CE_BLKy_t<='0';
		RST_BLKy_t<='0';	
		wait;
	end process;
		

end architecture tb;
