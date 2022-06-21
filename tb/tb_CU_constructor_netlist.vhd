library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.AMEpkg.all;

entity tb_CU_constructor_netlist is
end entity;

architecture tb of tb_CU_constructor_netlist is

	component CU_constructor_netlist is
		port ( START, GOT, CNT_compEN_OUT, CNT_STOPcompEN_OUT: in std_logic;
			   clk, CU_RST: in std_logic;
			   RST, RSH_LE, cmd_SH_EN, READY, DONE, CE_compEN, CE_STOPcompEN, compEN: out std_logic;
			   PS_out, NS_out: out std_logic_vector(2 downto 0));
	end component;
	
	signal START_t, GOT_t, CNT_compEN_OUT_t, CNT_STOPcompEN_OUT_t: std_logic;
	signal CU_RST_t: std_logic;
	signal RST_out, RSH_LE_out, cmd_SH_EN_out, READY_out, DONE_out, CE_compEN_out, CE_STOPcompEN_out, compEN_out: std_logic;
	signal PS_out_t, NS_out_t: std_logic_vector(2 downto 0);

	--clock
	signal clk: std_logic;
	constant Tc: time := 12 ns;

begin

	uut: CU_constructor_netlist 
		port map ( START_t, GOT_t, CNT_compEN_OUT_t, CNT_STOPcompEN_OUT_t,
			   clk, CU_RST_t,
			   RST_out, RSH_LE_out, cmd_SH_EN_out, READY_out, DONE_out, CE_compEN_out, CE_STOPcompEN_out, compEN_out,
			   PS_out_t, NS_out_t);

	clock_gen: process
	begin
		clk<='0';
		wait for Tc/2;
		clk<='1';
		wait for Tc/2;
	end process;

	stimuli:process
	begin
		wait for 3*Tc;
		CU_RST_t<='1';
		wait for Tc;
		START_t<='1';
		CNT_compEN_OUT_t<='0';
		CNT_STOPcompEN_OUT_t<='0';
		GOT_t<='0';
		wait for 5*Tc;
		CU_RST_t<='0';		
		wait for Tc;
		START_t<='0';
		wait for 5*Tc;
		CNT_compEN_OUT_t<='1';
		wait for Tc;
		CNT_compEN_OUT_t<='0';
		wait for 20*Tc;
		CNT_STOPcompEN_OUT_t<='1';
		wait for Tc;
		CNT_STOPcompEN_OUT_t<='0';
		wait for 5*Tc;
		GOT_t<='1';
		wait for Tc;
		Got_t<='0';
		wait;
	end process;
		

end architecture tb;
