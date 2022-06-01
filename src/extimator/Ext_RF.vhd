--In this register file, reading and writing are performed snchronously,
--the synchrounous reading operation is simply obtained by sampling the RF_Addr which
--is involved in the reading process
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.AMEpkg.all;

entity Ext_RF is
	port( RF_Addr: in std_logic;
		  MV0_in,MV1_in,MV2_in: in motion_vector(1 downto 0); --0:h, 1:v
		  clk, WE, RE, RST: in std_logic;
		  MV0_out,MV1_out,MV2_out: out motion_vector(1 downto 0)
		);
end entity;

architecture beh of Ext_RF is

	signal MV0_v, MV0_h, MV1_v, MV1_h, MV2_v, MV2_h: motion_vector(1 downto 0);
	signal RF_Addr_samp, RE_samp: std_Logic;

begin

	writing: process(clk,RST)
	begin
		if RST='1' then
			MV0_h<= (others=>"00000000000");
			MV0_v<= (others=>"00000000000");
			MV1_h<= (others=>"00000000000");
			MV1_v<= (others=>"00000000000");
			MV2_h<= (others=>"00000000000");
			MV2_v<= (others=>"00000000000");
		elsif rising_edge(clk) AND WE='1' then
			case RF_Addr is
				when '0' =>
					--Write on 0, store on 1
					MV0_h(0)<=MV0_in(0);
					MV0_v(0)<=MV0_in(1);
					MV1_h(0)<=MV1_in(0);
					MV1_v(0)<=MV1_in(1);
					MV2_h(0)<=MV2_in(0);
					MV2_v(0)<=MV2_in(1);
					MV0_h(1)<=MV0_h(1);
					MV0_v(1)<=MV0_v(1);
					MV1_h(1)<=MV1_h(1);
					MV1_v(1)<=MV1_v(1);
					MV2_h(1)<=MV2_h(1);
					MV2_v(1)<=MV2_v(1);
				when '1' =>
					--Write on 1, store on 0
					MV0_h(1)<=MV0_in(0);
					MV0_v(1)<=MV0_in(1);
					MV1_h(1)<=MV1_in(0);
					MV1_v(1)<=MV1_in(1);
					MV2_h(1)<=MV2_in(0);
					MV2_v(1)<=MV2_in(1);
					MV0_h(0)<=MV0_h(0);
					MV0_v(0)<=MV0_v(0);
					MV1_h(0)<=MV1_h(0);
					MV1_v(0)<=MV1_v(0);
					MV2_h(0)<=MV2_h(0);
					MV2_v(0)<=MV2_v(0);
				when OTHERS=>
					--Store all the positions
					MV0_h(0)<=MV0_h(0);
					MV0_v(0)<=MV0_v(0);
					MV1_h(0)<=MV1_h(0);
					MV1_v(0)<=MV1_v(0);
					MV2_h(0)<=MV2_h(0);
					MV2_v(0)<=MV2_v(0);
					MV0_h(1)<=MV0_h(1);
					MV0_v(1)<=MV0_v(1);
					MV1_h(1)<=MV1_h(1);
					MV1_v(1)<=MV1_v(1);
					MV2_h(1)<=MV2_h(1);
					MV2_v(1)<=MV2_v(1);
			end case;
		else
			--Store all the positions
					MV0_h(0)<=MV0_h(0);
					MV0_v(0)<=MV0_v(0);
					MV1_h(0)<=MV1_h(0);
					MV1_v(0)<=MV1_v(0);
					MV2_h(0)<=MV2_h(0);
					MV2_v(0)<=MV2_v(0);
					MV0_h(1)<=MV0_h(1);
					MV0_v(1)<=MV0_v(1);
					MV1_h(1)<=MV1_h(1);
					MV1_v(1)<=MV1_v(1);
					MV2_h(1)<=MV2_h(1);
					MV2_v(1)<=MV2_v(1);
		end if;		
	end process;


------Writing process

	RF_Addr_sampling: FlFl_LE
		port map(D=>RF_Addr,Q=>RF_Addr_samp,clk=>clk,RST=>RST,LE=>RE);

	reading: process(RF_Addr_samp)
	begin
		case RF_Addr_samp is
			when '0' =>
				MV0_out(0)<=MV0_h(0);
				MV0_out(1)<=MV0_v(0);
				MV1_out(0)<=MV1_h(0);
				MV1_out(1)<=MV1_v(0);
				MV2_out(0)<=MV2_h(0);
				MV2_out(1)<=MV2_v(0);
			when '1' =>
				MV0_out(0)<=MV0_h(1);
				MV0_out(1)<=MV0_v(1);
				MV1_out(0)<=MV1_h(1);
				MV1_out(1)<=MV1_v(1);
				MV2_out(0)<=MV2_h(1);
				MV2_out(1)<=MV2_v(1);
			when OTHERS=>
				MV0_out(0)<=MV0_h(0);
				MV0_out(1)<=MV0_v(0);
				MV1_out(0)<=MV1_h(0);
				MV1_out(1)<=MV1_v(0);
				MV2_out(0)<=MV2_h(0);
				MV2_out(1)<=MV2_v(0);
		end case;
	end process;


end architecture beh;
