--This block computes one component of the position of the first pixel in a block
--for a CU of a given size ("dim" could be "w" or "h")
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity firstPelPos_comp is
	port ( CE_REP, CE_BLK, RST_BLK, clk: in std_logic;
		   CU_dim: in std_logic_vector(1 downto 0);
		   last_block: out std_logic;
		   comp0: out std_logic_vector( 5 downto 0)	--"component0" (can be x or y)
		  );
end entity;

architecture struct of firstPelPos_comp is

	component cnt_RSTs_CEs is
	generic ( N: integer);
	port 	(	clk, CE, RST: in std_logic;
				count: out std_logic_vector (N-1 downto 0)
			);
	end component;

	component T_FF is
	port( T: in std_logic;
		  clk: in std_logic;
		  Q: out std_logic);
	end component;

	component enc2b is
	port ( enc_in: 	in std_logic_vector ( 1 downto 0);
		   enc_out: out std_logic_vector ( 1 downto 0)
		);
	end component;

	signal LSBs: std_logic_vector(3 downto 0);
	signal LSBs_ctrl, comp_out: std_logic;
	signal MSBs, block_num: std_logic_vector(1 downto 0);

begin

	CurRep: T_FF
		port map(CE_REP ,clk, LSBs_ctrl );

	LSBs<= "1100" when LSBS_ctrl='1' else "0000";

	CurBlock: cnt_RSTs_CEs
		generic map(N=>2)
		port map(clk, CE_BLK, RST_BLK, MSBs);

	comp0<= MSBs & LSBs;

	encoder: enc2b
		port map(CU_dim, block_num);

	comparator: process(MSBs, block_num)
		begin
			if MSBs=block_num then
				comp_out<='1';
			else
				comp_out<='0';
			end if;
	end process;

	last_block<=comp_out;
	

end architecture struct;
