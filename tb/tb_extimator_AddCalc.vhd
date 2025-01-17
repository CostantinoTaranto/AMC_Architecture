library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.AMEpkg.all;

entity tb_extimator_AddCalc is
end entity;

architecture tb of tb_extimator_AddCalc is

	component extimator_AddCalc is
		port( VALID_VTM, VALID_CONST: in std_logic;	--The "Valid" signal can be supplied by the constructor or the VTM alternatively
			  MV0_in, MV1_in, MV2_in: in motion_vector(1 downto 0);--0:h, 1:v
			  CurCU_h, CurCU_w: in std_logic_vector(6 downto 0);
			  sixPar: in std_logic;
			  clk, CU_RST: in std_logic;
			  RADDR_RefCu_x, RADDR_RefCu_y: out std_logic_vector(12 downto 0);
			  RADDR_CurCu_x, RADDR_CurCu_y: out std_logic_vector(5 downto 0);
			  MEM_RE: out std_logic;
			  extimator_READY: out std_logic
		);
	end component;

	component DATA_MEMORY_ex26 is
		port( clk, RST, RE: in std_logic;
			  RADDR_CurCu_x, RADDR_CurCu_y: in std_logic_vector(5 downto 0);
			  RADDR_RefCu_x, RADDR_RefCu_y: in std_logic_vector(12 downto 0);
			  Curframe_OUT: out slv_8(3 downto 0);
			  Refframe_OUT: out slv_8(3 downto 0));
	end component;

	signal VALID_VTM_t, VALID_CONST_t: std_logic;
	signal MV0_in_t, MV1_in_t, MV2_in_t: motion_vector(1 downto 0);--0:h, 1:v
	signal CurCU_h_t, CurCU_w_t: std_logic_vector(6 downto 0);
	signal sixPar_t, clk, CU_RST_t: std_logic;
	signal RADDR_RefCu_x_t, RADDR_RefCu_y_t: std_logic_vector(12 downto 0);
	signal RADDR_CurCu_x_t, RADDR_CurCu_y_t: std_logic_vector(5 downto 0);
	signal MEM_RE_int: std_logic;
	signal extimator_READY_t: std_logic;
	
	signal CurPel_t, RefPel_t : slv_8(3 downto 0);
	
	constant Tc: time := 2 ns;

begin

	uut: extimator_AddCalc
		port map(VALID_VTM_t, VALID_CONST_t, MV0_in_t, MV1_in_t, MV2_in_t, CurCU_h_t, CurCU_w_t,
			  sixPar_t, clk, CU_RST_t, RADDR_RefCu_x_t, RADDR_RefCu_y_t, RADDR_CurCu_x_t, RADDR_CurCu_y_t, MEM_RE_int, extimator_READY_t);
	
	uut_mem: DATA_MEMORY_ex26
		port map(clk, CU_RST_t, MEM_RE_int, RADDR_CurCu_x_t, RADDR_CurCu_y_t, RADDR_RefCu_x_t, RADDR_RefCu_y_t, CurPel_t, RefPel_t);

	clock_gen: process
	begin
		clk<='0';
		wait for Tc/2;
		clk<='1';
		wait for Tc/2;
	end process;
	
	stimuli: process
	begin
		wait for Tc;
		CU_RST_t<='1';
		wait for Tc;
		CU_RST_t<='0';
		wait for Tc;
		VALID_VTM_t<='1';
		CurCU_h_t<=std_logic_vector(to_signed(16,CurCU_h_t'length));
		CurCU_w_t<=std_logic_vector(to_signed(16,CurCU_w_t'length));
		sixPar_t<='0';
		MV0_in_t(0)<=std_logic_vector(to_signed(37,MV0_in_t(0)'length));
		MV0_in_t(1)<=std_logic_vector(to_signed(-6,MV0_in_t(1)'length));
		MV1_in_t(0)<=std_logic_vector(to_signed(23,MV1_in_t(0)'length));
		MV1_in_t(1)<=std_logic_vector(to_signed(12,MV1_in_t(1)'length));
		wait for Tc;
		VALID_VTM_t<='0';
		wait for Tc;
		VALID_VTM_t<='1';
		MV0_in_t(0)<=std_logic_vector(to_signed(28,MV0_in_t(0)'length));
		MV0_in_t(1)<=std_logic_vector(to_signed(-4,MV0_in_t(1)'length));
		MV1_in_t(0)<=std_logic_vector(to_signed(28,MV1_in_t(0)'length));
		MV1_in_t(1)<=std_logic_vector(to_signed(-4,MV1_in_t(1)'length));
		wait for Tc;
		VALID_VTM_t<='0';
		wait;
	end process;

end architecture tb;