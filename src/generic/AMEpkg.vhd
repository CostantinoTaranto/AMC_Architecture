library IEEE;
use IEEE.std_logic_1164.all;

package AMEpkg is
-----TYPES
	type motion_vector is array (natural range <>) of std_logic_vector(10 downto 0);

-----COMPONENTS
	component subtractor is
	generic ( N: integer);
	port 	( minuend, subtrahend:	in std_logic_vector(N-1 downto 0);
		  subtraction:		out std_logic_vector(N downto 0));
	end component;

	component sign_extender is
		generic ( N_in, N_out: integer);
		port	( toExtend: in std_logic_vector( N_in-1 downto 0);
				  extended: out std_logic_vector( N_out-1 downto 0));
	end component;

	component h_over_w is
	port ( h,w:   in std_logic_vector (1 downto 0);
		   SH_cmd:out std_logic_vector (2 downto 0));
	end component;

	component LS_RS_B2 is
	port ( SH_in: in  std_logic_vector(11 downto 0);
		   SH_cmd:in  std_logic_vector(2  downto 0); 
		   SH_out:out std_logic_vector(13 downto 0));
	end component;

	component adder is
		generic ( N: integer);
		port	( op1, op2:	in std_logic_vector(N-1 downto 0);
				  sum:		out std_logic_vector(N downto 0));
	end component;

	component multiplier is
		generic ( N: integer);
		port 	( op1, op2:	in std_logic_vector(N-1 downto 0);
			  product:		out std_logic_vector((2*N)-1 downto 0));
	end component;

	component comparator is
		generic ( N: integer);
		port	( in_pos, in_neg:	in std_logic_vector(N-1 downto 0);
				  isGreater:		out std_logic);
	end component;

end package;

package body AMEpkg is
end package body;
