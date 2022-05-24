library IEEE;
use IEEE.std_logic_1164.all;

entity LR_SH2 is
	port ( shift_dir: in std_logic;
		   shift_amt: in std_logic_vector(1 downto 0);
		   MV1_MV0: in std_logic_vector(11 downto 0);
		   RST, clk: in std_logic;
		   diff_mult: out std_logic_vector(13 downto 0)
			);
end entity;

architecture rtl of LR_SH2 is

	signal shift_dir_int : std_logic_vector(3 downto 0);
	signal shift_amt_int: std_logic_vector(1 downto 0);
	signal R_SH2_LE, L_SH2_LE: std_logic;
	signal SH_en, SH_en2: std_logic;
	signal MV1_MV0_d1R, MV1_MV0_d2R: std_logic_vector(11 downto 0);
	signal MV1_MV0_d1L: std_logic_vector(12 downto 0);
	signal MV1_MV0_d2L, MV1_MV0_d2R_ext: std_logic_vector(13 downto 0);
	component FF is
		port (D, RST, clk: in std_logic;
			  Q: out std_logic);
	end component;
	component signed_shifter is
		generic (N: integer);
		port	(SH_in:	 in  std_logic_vector (N-1 downto 0);
				 clk, SH_EN, LE, RST: in std_logic;
				 SH_out: out std_logic_vector (N-1 downto 0)
				 );
	end component;
	component sign_extender is
	generic ( N_in, N_out: integer);
	port	( toExtend: in std_logic_vector( N_in-1 downto 0);
			  extended: out std_logic_vector( N_out-1 downto 0));
	end component;
	component signed_Lshifter is
		generic (N_in, N_out: integer);
		port	(SH_in:	 in  std_logic_vector (N_in-1 downto 0);
				 clk, SH_EN, LE, RST: in std_logic;
				 SH_out: out std_logic_vector (N_out-1 downto 0)
				 );
	end component;

	component REG_N is
		generic (N: integer);
		port (D: in std_logic_vector (N-1 downto 0);
			  RST, clk: in std_logic;
			  Q: out std_logic_vector (N-1 downto 0));
	end component;


begin
	
	shift_dir_int(0)<=shift_dir;
	shift_dir_sample: for I in 1 to 3 generate
		FF_X: FF
			port map (D=>shift_dir_int(I-1),RST=>'0',clk=>clk,Q=>shift_dir_int(I));
	end generate shift_dir_sample;

	--Left and Right shifters enable
	R_SH2_LE<= NOT shift_dir_int(1);
	L_SH2_LE<=     shift_dir_int(1);

	--Shift Enable generation
	shift_amt_sample: REG_N
		generic map(N=>2)
		port map (D=>shift_amt,RST=>RST,clk=>clk, Q=>shift_amt_int);

	SH_en<=shift_amt_int(1) OR shift_amt_int(0);
	SH_en2_sampling: FF
		port map(D=>shift_amt_int(1),RST=>RST,clk=>clk, Q=>SH_en2);

	--Right shift
	RSH_first: signed_shifter
		generic map(N=>12)
		port map(SH_in=>MV1_MV0,clk=>clk,SH_EN=>SH_en,LE=>R_SH2_LE,RST=>RST,SH_out=>MV1_MV0_d1R);
	RSH_second: signed_shifter
		generic map(N=>12)
		port map(SH_in=>MV1_MV0_d1R,clk=>clk,SH_EN=>SH_en2,LE=>'1',RST=>RST,SH_out=>MV1_MV0_d2R);
	RSH_extend: sign_extender
		generic map(N_in=>12,N_out=>14)
		port map(toExtend=>MV1_MV0_d2R,extended=>MV1_MV0_d2R_ext);

	--Left shift
	LSH_first: signed_Lshifter
		generic map(N_in=>12,N_out=>13)
		port map(SH_in=>MV1_MV0,clk=>clk,SH_EN=>SH_en,LE=>L_SH2_LE,RST=>RST,SH_out=>MV1_MV0_d1L);
	LSH_second: signed_Lshifter
		generic map(N_in=>13,N_out=>14)
		port map(SH_in=>MV1_MV0_d1L,clk=>clk,SH_EN=>SH_en2,LE=>'1',RST=>RST,SH_out=>MV1_MV0_d2L);

	--Output choice
	diff_mult<=MV1_MV0_d2L WHEN (shift_dir_int(3)='1') ELSE MV1_MV0_d2R_ext;

end architecture rtl;
