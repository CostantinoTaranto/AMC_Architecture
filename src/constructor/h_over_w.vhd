library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity h_over_w is
	port ( h,w:   in std_logic_vector  (1 downto 0);
		   SH_cmd:out std_logic_vector (2 downto 0));
end entity;

architecture rtl of h_over_w is
	signal shift_dir: std_logic;
	signal RSH_in, cmd, shift_amt: std_logic_vector (1 downto 0);

	component RS_B2_unsigned is
	generic ( N: integer);
	port ( RS_in: in std_logic_vector( N-1 downto 0);
		   cmd:   in std_logic_vector( 1 downto 0);
		   RS_out:out std_logic_vector( N-1 downto 0));
	end component;

begin
	--Comparator
	shift_dir <=  '1' when (unsigned(h)>unsigned(w)) else '0';
	--Muxes
	RSH_in<= h when (shift_dir='1') else w;
	cmd<=	 w when (shift_dir='1') else h;
	--Shifter
	shifter: RS_B2_unsigned
		generic map (N => 2)
		port map(RSH_in, cmd, shift_amt);
	--Concatenation
	SH_cmd<=shift_dir & shift_amt;
		
end architecture rtl;
	
