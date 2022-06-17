library ieee;
use ieee.std_logic_1164.all;
USE IEEE.NUMERIC_STD.ALL;
use std.textio.all;

library work;
use work.AMEpkg.all;

entity DATA_MEMORY is
	port( clk, RST, RE: in std_logic;
		  RADDR_CurCu_x, RADDR_CurCu_y: in std_logic_vector(5 downto 0);
		  RADDR_RefCu_x, RADDR_RefCu_y: in std_logic_vector(12 downto 0);
		  Curframe_OUT: out slv_8(3 downto 0);
		  Refframe_OUT: out slv_8(3 downto 0));
end entity;

architecture beh of DATA_MEMORY is

