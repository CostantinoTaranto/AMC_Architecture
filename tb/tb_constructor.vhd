library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.AMEpkg.all;

entity tb_constructor is
end entity;

architecture tb of tb_constructor is

	component constructor is
		port ( MV0,MV1,MV2: in motion_vector(0 to 1); --0:h,1:v
			   CU_h,CU_w:	in std_logic_vector(6 downto 0);
			   comp_out:	out std_logic);--For the time being, we will check only the results of the comparison
	end component;

	signal MV0_t,MV1_t,MV2_t:	motion_vector(0 to 1);
	signal CU_h_t,CU_w_t:		std_logic_vector(6 downto 0); 
	signal comp_out_t:			std_logic; 

begin

	uut: constructor
		port map(MV0_t,MV1_t,MV2_t, CU_h_t,CU_w_t, comp_out_t);

	stimuli:process
	begin
		wait for 2 ns;
		--Example 1, candidate 1:(1,1,1)
		CU_h_t	<=std_logic_vector(to_signed(32,CU_h_t'length));
		CU_w_t	<=std_logic_vector(to_signed(32,CU_h_t'length));
		MV0_t(0)<=std_logic_vector(to_signed(   71,MV0_t(0)'length));
		MV0_t(1)<=std_logic_vector(to_signed(    1,MV0_t(0)'length));
		MV1_t(0)<=std_logic_vector(to_signed(   73,MV0_t(0)'length));
		MV1_t(1)<=std_logic_vector(to_signed(   -2,MV0_t(0)'length));
		MV2_t(0)<=std_logic_vector(to_signed(   71,MV0_t(0)'length));
		MV2_t(1)<=std_logic_vector(to_signed(    1,MV0_t(0)'length));
		wait for 2 ns;
		--Example 6, candidate 1:(1,1,1)
		CU_h_t	<=std_logic_vector(to_signed(32,CU_h_t'length));
		CU_w_t	<=std_logic_vector(to_signed(16,CU_h_t'length));
		MV0_t(0)<=std_logic_vector(to_signed(  -56,MV0_t(0)'length));
		MV0_t(1)<=std_logic_vector(to_signed(   88,MV0_t(0)'length));
		MV1_t(0)<=std_logic_vector(to_signed(  -96,MV0_t(0)'length));
		MV1_t(1)<=std_logic_vector(to_signed(   48,MV0_t(0)'length));
		MV2_t(0)<=std_logic_vector(to_signed(   16,MV0_t(0)'length));
		MV2_t(1)<=std_logic_vector(to_signed(    0,MV0_t(0)'length));
		wait for 2 ns;
		--Example 6, candidate 2:(2,1,1)
		CU_h_t	<=std_logic_vector(to_signed(32,CU_h_t'length));
		CU_w_t	<=std_logic_vector(to_signed(16,CU_h_t'length));
		MV0_t(0)<=std_logic_vector(to_signed(  -88,MV0_t(0)'length));
		MV0_t(1)<=std_logic_vector(to_signed(  128,MV0_t(0)'length));
		MV1_t(0)<=std_logic_vector(to_signed(  -96,MV0_t(0)'length));
		MV1_t(1)<=std_logic_vector(to_signed(   48,MV0_t(0)'length));
		MV2_t(0)<=std_logic_vector(to_signed(   16,MV0_t(0)'length));
		MV2_t(1)<=std_logic_vector(to_signed(    0,MV0_t(0)'length));
		wait;
	end process;
		

end architecture tb;
