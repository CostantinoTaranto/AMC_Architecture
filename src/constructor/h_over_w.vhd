library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity h_over_w is
	port ( h,w:   in std_logic_vector  (1 downto 0);
		   clk, RSH_LE, cmd_SH_EN: in std_logic;
		   SH_cmd:out std_logic_vector (2 downto 0));
end entity;

architecture rtl of h_over_w is
	signal shift_dir_int: std_logic_vector(3 downto 0);
	signal RSH_SH_en: std_logic;
	signal RSH_in, cmd, cmd_RSH_out, shift_amt: std_logic_vector (1 downto 0);

	component unsigned_shifter is
		generic (N: integer);
		port	(SH_in:	 in  std_logic_vector (N-1 downto 0);
				 clk, SH_EN, LE, RST: in std_logic;
				 SH_out: out std_logic_vector (N-1 downto 0)
				 );
	end component;

	component FF is
		port (D, RST, clk: in std_logic;
			  Q: out std_logic);
	end component;

begin
	--Comparator & Delay
	shift_dir_int(0) <=  '1' when (unsigned(h)>unsigned(w)) else '0';
	DELAY_GEN: for I in 1 to 3 generate
		FF_X: FF
			port map (D=>shift_dir_int(I-1),RST=>'0',clk=>clk,Q=>shift_dir_int(I));
	end generate DELAY_GEN;
	
	--Muxes
	RSH_in<= h when (shift_dir_int(0)='1') else w;
	cmd<=	 w when (shift_dir_int(0)='1') else h;
	--Shifter
	cmd_RSH: unsigned_shifter
		generic map (N => 2)
		port map(cmd,clk, cmd_SH_en, RSH_LE, '0' ,cmd_RSH_out);
	RSH_SH_en<=cmd_RSH_out(0) OR cmd_RSH_out(1);
	RSH: unsigned_shifter
		generic map (N => 2)
		port map (SH_in=>RSH_in,clk=>clk,SH_EN=>RSH_SH_en,LE=>RSH_LE,RST=>'0',SH_out=>shift_amt);
	--Concatenation
	SH_cmd<=shift_dir_int(3) & shift_amt;
		
end architecture rtl;
