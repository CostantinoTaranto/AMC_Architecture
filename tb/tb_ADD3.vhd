library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.AMEpkg.all;

entity tb_ADD3 is
end entity;

architecture tb of tb_ADD3 is

	component ADD3 is
		generic (N: integer);
		port( op1,op2,op3: in std_logic_vector (N-1 downto 0);
			  VALID, RST, clk: in std_logic;
			  sum: out std_logic_vector (N+1 downto 0)
			);
	end component;
	
	signal op1_t, op2_t, op3_t: std_logic_vector(16 downto 0);
	signal VALID_t, RST_t: std_logic; 
	signal sum_t: std_logic_vector(18 downto 0);

	--clock
	signal clk: std_logic;
	constant Tc: time := 2 ns;

begin

	uut: ADD3
		generic map(N=>17)
		port map(op1_t,op2_t,op3_t,VALID_t,RST_t,clk,sum_t);

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
		RST_t<='1';
		wait for Tc;
		RST_t<='0';		
		wait for 5*Tc;
		VALID_t<='1';
		op1_t	<=std_logic_vector(to_signed(142,op1_t'length));
		op2_t	<=std_logic_vector(to_signed(-241,op2_t'length));
		op3_t	<=std_logic_vector(to_signed(-141,op2_t'length));
		wait for 2*Tc;
		op1_t	<=std_logic_vector(to_signed(120,op1_t'length));
		op2_t	<=std_logic_vector(to_signed(118,op2_t'length));
		op3_t	<=std_logic_vector(to_signed(31,op2_t'length));
		wait for 2*Tc;
		op1_t	<=std_logic_vector(to_signed(742,op1_t'length));
		op2_t	<=std_logic_vector(to_signed(-1448,op2_t'length));
		op3_t	<=std_logic_vector(to_signed(1,op2_t'length));
		wait for 2*Tc;
		VALID_t<='0';
		wait for 5*Tc;
		VALID_t<='1';
		op1_t	<=std_logic_vector(to_signed(-42,op1_t'length));
		op2_t	<=std_logic_vector(to_signed(913,op2_t'length));
		op3_t	<=std_logic_vector(to_signed(0,op2_t'length));
		wait for 2*Tc;
		op1_t	<=std_logic_vector(to_signed(3,op1_t'length));
		op2_t	<=std_logic_vector(to_signed(3,op2_t'length));
		op3_t	<=std_logic_vector(to_signed(-154,op2_t'length));
		wait for 2*Tc;
		VALID_t<='0';
		wait;
	end process;
		

end architecture tb;
