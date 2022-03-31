library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity LS_RS_B2 is
	port ( SH_in: in  std_logic_vector(11 downto 0);
		   SH_cmd:in  std_logic_vector(2  downto 0); 
		   SH_out:out std_logic_vector(13 downto 0));
end entity;

architecture structural of LS_RS_B2 is

	component LS_B2 is
	generic ( N: integer);
	port ( LS_in: in std_logic_vector( N-1 downto 0);
		   cmd:   in std_logic_vector( 1 downto 0);
		   LS_out:out std_logic_vector( N-1 downto 0));
	end component;

	component RS_B2 is
	generic ( N: integer);
	port ( RS_in: in std_logic_vector( N-1 downto 0);
		   cmd:   in std_logic_vector( 1 downto 0);
		   RS_out:out std_logic_vector( N-1 downto 0));
	end component;

	component sign_extender is
	generic ( N_in, N_out: integer);
	port	( toExtend: in std_logic_vector( N_in-1 downto 0);
			  extended: out std_logic_vector( N_out-1 downto 0));
	end component;
	
	signal RS_out_short: std_logic_vector(11 downto 0);
	signal SH_in_ext,LS_out_tmp,RS_out_tmp: std_logic_vector( 13 downto 0);

begin

	--In the left shifter we keep all the 14 digits, this is why we
	--extend the input before the shift
	left_shifter_extender: sign_extender
		generic map(N_in=> 12, N_out=> 14)
		port map (SH_in,SH_in_ext);

	left_shifter: LS_B2
		generic map (N=> 14)
		port map (SH_in_ext,SH_cmd(1 downto 0),LS_out_tmp);

	--In the right shifter the shifted digits must be discarded,
	--this is why we need to extend the result
	right_shifter: RS_B2
		generic map (N=> 12)
		port map (SH_in,SH_cmd(1 downto 0),RS_out_short);

	right_shifter_extender: sign_extender
		generic map(N_in=> 12, N_out=> 14)
		port map (RS_out_short,RS_out_tmp);

	--Output mux
	SH_out<= LS_out_tmp when (SH_cmd(2)='1') else RS_out_tmp;

end architecture structural;
