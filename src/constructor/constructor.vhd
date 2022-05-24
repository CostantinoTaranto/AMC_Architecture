library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.AMEpkg.all;

entity constructor is
	port ( MV0,MV1,MV2: in motion_vector(0 to 1); --0:h,1:v
		   RST, RSH_LE, cmd_SH_en : in std_logic;
		   CU_h,CU_w:	in std_logic_vector(6 downto 0);
		   CE_final: in std_logic;
		   CE_final_OUT: out std_logic;
		   MVP0,MVP1,MVP2: out motion_vector(0 to 1)); --0:h,1:v
end entity;

architecture structural of constructor is

	signal mv1v_mv0v, mv1h_mv0h: std_logic_vector(11 downto 0);
	signal SH_cmd_int: std_logic_vector(2 downto 0);
	signal diff_mult_v, diff_mult_h, MV0_h_ext, MV0_v_ext : std_logic_vector(13 downto 0); --Output of LS_RS_B2 and extended MVs
	signal MV2p_h, MV2p_v, MV2_h_ext, MV2_v_ext: std_logic_vector(14 downto 0);
	signal D_h   ,D_v:    std_logic_vector(15 downto 0);
	signal D_h_cut   ,D_v_cut:    std_logic_vector(14 downto 0);
	signal D_h_sq,D_v_sq: std_logic_vector(29 downto 0);
	signal D_h_sq_cut,D_v_sq_cut: std_logic_vector(26 downto 0);
	signal D_sq: std_logic_vector(27 downto 0);
	signal D_sq_min: std_logic_vector(27 downto 0);

begin

----Left branch

	L_sub1: subtractor
		generic map(N=>11)
		port map(MV1(1),MV0(1),mv1v_mv0v);

	L_MV0_h_ext: sign_extender
		generic map(N_in=>11, N_out=>14)
		port map(MV0(0),MV0_h_ext);

	hOw: h_over_w
		port map(CU_h(6 downto 5),CU_w(6 downto 5),SH_cmd_int);

	L_LRB: LS_RS_B2
		port map(mv1v_mv0v,SH_cmd_int,diff_mult_v);

	L_sub2: subtractor
		generic map(N=>14)
		port map(MV0_h_ext,diff_mult_v,MV2p_h);

	L_MV2_h_ext: sign_extender
		generic map(N_in=>11, N_out=>15)
		port map(MV2(0),MV2_h_ext);

	L_subD: subtractor
		generic map(N=>15)
		port map(MV2p_h,MV2_h_ext,D_h);

	D_h_cut<=D_h(14 downto 0);

	L_squarer: multiplier
		generic map(N=>15)
		port map(D_h_cut,D_h_cut,D_h_sq);

	D_h_sq_cut<=D_h_sq(26 downto 0);	---positive value

----Right branch

	R_sub1: subtractor
		generic map(N=>11)
		port map(MV1(0),MV0(0),mv1h_mv0h);

	R_MV0_v_ext: sign_extender
		generic map(N_in=>11, N_out=>14)
		port map(MV0(1),MV0_v_ext);

	R_LRB: LS_RS_B2
		port map(mv1h_mv0h,SH_cmd_int,diff_mult_h);

	R_sum: adder
		generic map(N=>14)
		port map(diff_mult_h,MV0_v_ext,MV2p_v);

	R_MV2_v_ext: sign_extender
		generic map(N_in=>11, N_out=>15)
		port map(MV2(1),MV2_v_ext);

	R_subD: subtractor
		generic map(N=>15)
		port map(MV2p_v,MV2_v_ext,D_v);

	D_v_cut<=D_v(14 downto 0);

	R_squarer: multiplier
		generic map(N=>15)
		port map(D_v_cut,D_v_cut,D_v_sq);

	D_v_sq_cut<=D_v_sq(26 downto 0);	---positive value


----Final adder and comparator
	D_adder: adder
		generic map(N=>27)
		port map(D_h_sq_cut,D_v_sq_cut,D_sq);

	D_sq_min<=(others => '1');

	final_comp: comparator
		generic map(N=>28)
		port map(D_sq_min,D_sq,comp_out);

end architecture structural;
