library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.AMEpkg.all;

entity MVin_pipe is
	generic (N: integer);	--The number of stages, tunable in case of error/changes
	port ( MV: in motion_vector(2 downto 0); --MV0, MV1, MV2
		   clk: in std_logic;
		   RST1, RST2: in std_logic; --RST1 is for the first 2 registers, RST2 for the others
		   LE1, LE2, LE3: in std_logic; --LE1 for the first 2 registers, LE3 for the last one, LE2 for the middle ones
		   MVP: out motion_vector (2 downto 0) --The predictions
		);
end entity;

architecture structural of MVin_pipe is

	signal MV0_int, MV1_int, MV2_int: motion_vector (N downto 0);

begin

	MV0_int(0)<=MV(0);
	MV1_int(0)<=MV(1);
	MV2_int(0)<=MV(2);

	--First and Second (registers)
	FaS_generate0: for I in 1 to 2 generate	
		FaS_registers0: MV_RF
			port map(MV_in=>MV0_int(I-1), clk=>clk, RST=>RST1, LE=>LE1, MV_out=>MV0_int(I));
	end generate;
	FaS_generate1: for I in 1 to 2 generate	
		FaS_registers1: MV_RF
			port map(MV_in=>MV1_int(I-1), clk=>clk, RST=>RST1, LE=>LE1, MV_out=>MV1_int(I));
	end generate;
	FaS_generate2: for I in 1 to 2 generate	
		FaS_registers2: MV_RF
			port map(MV_in=>MV2_int(I-1), clk=>clk, RST=>RST1, LE=>LE1, MV_out=>MV2_int(I));
	end generate;

	--Middle (registers)
	Middle_generate0: for I in 3 to N-1 generate	
		Middle_registers0: MV_RF
			port map(MV_in=>MV0_int(I-1), clk=>clk, RST=>RST2, LE=>LE2, MV_out=>MV0_int(I));
	end generate;
	Middle_generate1: for I in 3 to N-1 generate	
		Middle_registers1: MV_RF
			port map(MV_in=>MV1_int(I-1), clk=>clk, RST=>RST2, LE=>LE2, MV_out=>MV1_int(I));
	end generate;
	Middle_generate2: for I in 3 to N-1 generate	
		Middle_registers2: MV_RF
			port map(MV_in=>MV2_int(I-1), clk=>clk, RST=>RST2, LE=>LE2, MV_out=>MV2_int(I));
	end generate;

	Last_register0: MV_RF
		port map(MV_in=>MV0_int(N-1), clk=>clk, RST=>RST2, LE=>LE3, MV_out=>MV0_int(N));
	Last_register1: MV_RF
		port map(MV_in=>MV1_int(N-1), clk=>clk, RST=>RST2, LE=>LE3, MV_out=>MV1_int(N));
	Last_register2: MV_RF
		port map(MV_in=>MV2_int(N-1), clk=>clk, RST=>RST2, LE=>LE3, MV_out=>MV2_int(N));

	MVP(0)<=MV0_int(N);
	MVP(1)<=MV1_int(N);
	MVP(2)<=MV2_int(N);

end architecture structural;
