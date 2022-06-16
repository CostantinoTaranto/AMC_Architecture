library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.AMEpkg.all;

entity tb_AME_Architecture is
end entity;

architecture tb of tb_AME_Architecture is

	component AME_Architecture is
		port ( cMV0_in, cMV1_in, cMV2_in: in motion_vector(1 downto 0);--Constructor motion vectors (0:h, 1:v)
			   START: in std_logic; --constructor's "START"
			   CU_h, CU_w: in std_logic_vector(6 downto 0);
			   clk, RST: in std_logic;
			   cREADY: out std_logic; --constructor's READY
			   VALID: in std_logic; --extimator's VALID
			   eMV0_in, eMV1_in, eMV2_in: in motion_vector(1 downto 0);--Extimator motion vectors (0:h, 1:v)
			   sixPar : in std_logic;
			   eIN_SEL : in std_logic; --extimator input selector: 0: from VTM, 1: form constructor
			   RefPel, CurPel: in slv_8(3 downto 0);
			   RADDR_RefCu_x, RADDR_RefCu_y: out std_logic_vector(12 downto 0);
			   RADDR_CurCu_x, RADDR_CurCu_y: out std_logic_vector(5 downto 0);
			   MEM_RE: out std_logic; --Memory Read Enable
			   eREADY: out std_logic; --extimator's READY
			   MV0_out, MV1_out, MV2_out: out motion_vector(1 downto 0) --Extimation result
			);
	end component;

	component DATA_MEMORY_ex28 is
		port( clk, RST, RE: in std_logic;
			  RADDR_CurCu_x, RADDR_CurCu_y: in std_logic_vector(5 downto 0);
			  RADDR_RefCu_x, RADDR_RefCu_y: in std_logic_vector(12 downto 0);
			  Curframe_OUT: out slv_8(3 downto 0);
			  Refframe_OUT: out slv_8(3 downto 0));
	end component;

	signal cMV0_in_t, cMV1_in_t, cMV2_in_t: motion_vector(1 downto 0);
	signal eMV0_in_t, eMV1_in_t, eMV2_in_t: motion_vector(1 downto 0);
	signal CU_h_t, CU_w_t: std_logic_vector(6 downto 0);
	signal sixPar_t, clk, RST_t, START_t, cREADY_t, VALID_t, eIN_SEL_t: std_logic;
	signal RefPel_int, CurPel_int: slv_8(3 downto 0);
	signal RADDR_RefCu_x_int, RADDR_RefCu_y_int: std_logic_vector(12 downto 0);
	signal RADDR_CurCu_x_int, RADDR_CurCu_y_int: std_logic_vector(5 downto 0);
	signal MEM_RE_int: std_logic;
	signal eREADY_t: std_logic;
	signal MV0_out_t, MV1_out_t, MV2_out_t: motion_vector(1 downto 0);

	type integer_array is array (natural range <>) of integer;
	signal candidate_MV0_h, candidate_MV0_v: integer_array(0 to 2);
	signal candidate_MV1_h, candidate_MV1_v: integer_array(0 to 1);
	signal candidate_MV2_h, candidate_MV2_v: integer_array(0 to 1);
	
	constant Tc: time := 2 ns;

begin

	uut: AME_Architecture
		port map( cMV0_in_t, cMV1_in_t, cMV2_in_t, START_t, CU_h_t, CU_w_t, clk, RST_t, cREADY_t, VALID_t, eMV0_in_t, eMV1_in_t, eMV2_in_t, sixPar_t, eIN_SEL_t,
				  RefPel_int, CurPel_int, RADDR_RefCu_x_int, RADDR_RefCu_y_int, RADDR_CurCu_x_int, RADDR_CurCu_y_int, MEM_RE_int, eREADY_t, MV0_out_t, MV1_out_t, MV2_out_t);
	
	uut_mem: DATA_MEMORY_ex28
		port map(clk, RST_t, MEM_RE_int, RADDR_CurCu_x_int, RADDR_CurCu_y_int, RADDR_RefCu_x_int, RADDR_RefCu_y_int, CurPel_int, RefPel_int);

	clock_gen: process
	begin
		clk<='0';
		wait for Tc/2;
		clk<='1';
		wait for Tc/2;
	end process;
	
	candidate_MV0_h(0)<=88;
	candidate_MV0_h(1)<=88;
	candidate_MV0_h(2)<=102;
	candidate_MV0_v(0)<=-24;
	candidate_MV0_v(1)<=-24;
	candidate_MV0_v(2)<=-12;
	
	candidate_MV1_h(0)<=103;
	candidate_MV1_h(1)<=112;
	candidate_MV1_v(0)<=-9;
	candidate_MV1_v(1)<=16;
	
	candidate_MV2_h(0)<=88;
	candidate_MV2_h(1)<=88;
	candidate_MV2_v(0)<=-24;
	candidate_MV2_v(1)<=-24;
	
	stimuli: process
	begin
		wait for Tc;
		RST_t<='1';
		wait for Tc;
		RST_t<='0';
		wait for Tc;
		START_t<='1';
		CU_h_t<=std_logic_vector(to_signed(16,CU_h_t'length));
		CU_w_t<=std_logic_vector(to_signed(16,CU_w_t'length));
		sixPar_t<='0';
		VALID_t<='1';
		eIN_SEL_t<='0';--VTM input
		eMV0_in_t(0)<=std_logic_vector(to_signed(104,eMV0_in_t(0)'length));
		eMV0_in_t(1)<=std_logic_vector(to_signed(-4,eMV0_in_t(1)'length));
		eMV1_in_t(0)<=std_logic_vector(to_signed(108,eMV1_in_t(0)'length));
		eMV1_in_t(1)<=std_logic_vector(to_signed(0,eMV1_in_t(1)'length));
		for I in 0 to 2 loop		
			cMV0_in_t(0)<=std_logic_vector(to_signed(candidate_MV0_h(I),cMV0_in_t(0)'length));
			cMV0_in_t(1)<=std_logic_vector(to_signed(candidate_MV0_v(I),cMV0_in_t(1)'length));
			for J in 0 to 1 loop
				cMV1_in_t(0)<=std_logic_vector(to_signed(candidate_MV1_h(J),cMV1_in_t(0)'length));
				cMV1_in_t(1)<=std_logic_vector(to_signed(candidate_MV1_v(J),cMV1_in_t(1)'length));
				for K in 0 to 1 loop
					cMV2_in_t(0)<=std_logic_vector(to_signed(candidate_MV2_h(K),cMV2_in_t(0)'length));
					cMV2_in_t(1)<=std_logic_vector(to_signed(candidate_MV2_v(K),cMV2_in_t(1)'length));
					wait for Tc;
				end loop;
			end loop;
			START_t<='0';
			VALID_t<='0';
		end loop;
		wait for Tc;
		eIN_SEL_t<='1'; --Constructor input
		wait;
	end process;

end architecture tb;