library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

library work;
use work.AMEpkg.all;

entity tb_extimator_netlist_expanded is
end entity;

architecture tb of tb_extimator_netlist_expanded is

		component extimator_expanded_netlist_wrapper is
			port( VALID_VTM, VALID_CONST: in std_logic;	--The "Valid" signal can be supplied by the constructor or the VTM alternatively
				  MV0_in, MV1_in, MV2_in: in motion_vector(1 downto 0);--0:h, 1:v
				  CurCU_h, CurCU_w: in std_logic_vector(6 downto 0);
				  sixPar: in std_logic;
				  clk, CU_RST: in std_logic;
				  RefPel, CurPel: in slv_8(3 downto 0);
				  RADDR_RefCu_x, RADDR_RefCu_y: out std_logic_vector(12 downto 0);
				  RADDR_CurCu_x, RADDR_CurCu_y: out std_logic_vector(5 downto 0);
				  MEM_RE: out std_logic; --Memory Read Enable
				  extimator_READY, GOT: out std_logic;
				  MV0_out, MV1_out, MV2_out: out motion_vector(1 downto 0); --Extimation result
				  DONE: out std_logic;
				  
			);
	end component;

	component constructor is
		port( MV0,MV1,MV2: in motion_vector(1 downto 0); --0:h,1:v
			  CU_h, CU_W: in std_logic_vector(6 downto 0);
			  START, GOT, clk, CU_RST: in std_logic;
			  READY, DONE: out std_logic;
			  MVP0,MVP1,MVP2: out motion_vector(1 downto 0); --MV Prediction
			  --For the output checker
			  cComp_EN_int: out std_logic;
			  D_Cur_int: out std_logic_vector(27 downto 0)
			);
	end component;

	component DATA_MEMORY is
		port( clk, RST, RE: in std_logic;
			  RADDR_CurCu_x, RADDR_CurCu_y: in std_logic_vector(5 downto 0);
			  RADDR_RefCu_x, RADDR_RefCu_y: in std_logic_vector(12 downto 0);
			  Curframe_OUT: out slv_8(3 downto 0);
			  Refframe_OUT: out slv_8(3 downto 0));
	end component;
	
	component output_checker is
		port( cComp_EN, cDONE, eComp_EN, eDONE, sixPar, clk, END_SIM: in std_logic;
			  constructed: in std_logic;
			  MVP0, MVP1, MVP2: in motion_vector(1 downto 0);
			  MV0_out, MV1_out, MV2_out: in motion_vector(1 downto 0);
			  CurSAD: in std_logic_vector(17 downto 0);
			  D_Cur: in std_logic_vector(27 downto 0)
			  );
	end component;

	signal cMV0_in_t, cMV1_in_t, cMV2_in_t: motion_vector(1 downto 0);
	signal eMV0_in_t, eMV1_in_t, eMV2_in_t: motion_vector(1 downto 0);
	signal CU_h_t, CU_w_t: std_logic_vector(6 downto 0);
	signal sixPar_t, clk, RST_t, START_t, cREADY_t, VALID_t, eIN_SEL_t: std_logic;
	signal RefPel_int, CurPel_int: slv_8(3 downto 0);
	signal RADDR_RefCu_x_int, RADDR_RefCu_y_int: std_logic_vector(12 downto 0);
	signal RADDR_CurCu_x_int, RADDR_CurCu_y_int: std_logic_vector(5 downto 0);
	signal MEM_RE_int: std_logic;
	signal eREADY_t: std_logic;
	signal MV0_out_t, MV1_out_t, MV2_out_t: motion_vector(1 downto 0);

	type integer_array is array (natural range <>) of integer;
	signal candidate_MV0_h, candidate_MV0_v: integer_array(0 to 2);
	signal candidate_MV1_h, candidate_MV1_v: integer_array(0 to 1);
	signal candidate_MV2_h, candidate_MV2_v: integer_array(0 to 1);
	signal eMV0_in_r, eMV1_in_r, eMV2_in_r: integer_array(0 to 1);
	signal eMV0_in_r2, eMV1_in_r2, eMV2_in_r2: integer_array(0 to 1); --Second VTM canditate (to be used when constructed_r=0)
	
	--For the output checker
	signal cComp_EN_int, cDONE_int, eComp_EN_int, eDONE_int: std_logic;
	signal MVP0_int, MVP1_int, MVP2_int: motion_vector(1 downto 0);
	signal CurSAD_int: std_logic_vector(17 downto 0);
	signal D_Cur_int: std_logic_vector(27 downto 0);
	signal END_SIM: std_logic;
	signal constructed_int: std_logic;
	
	--Expanded part
	signal last_block_x, last_block_y: std_logic;
	signal last_cand, Second_ready, CountTerm_OUT: std_logic;
	signal INTER_DATA_VALID_SET, INTER_DATA_VALID_RESET: std_logic;
	signal ADD3_MVin_LE_fSET, ADD3_MVin_LE_nSET, ADD3_MVin_LE_fRESET: std_logic;
	signal LE_ab, SAD_tmp_RST, Comp_EN, OUT_LE, CountTerm_EN, CandCount_CE, RF_in_RE: std_logic;
	signal BestCand: std_logic;
	signal MULT1_VALID, ADD3_VALID, incrY: std_logic;
	signal ADD3_MVin_LE: std_logic;
	signal eCU_PS, eCU_NS: std_logic_vector(4 downto 0);
	signal ADD3_0_in0, ADD3_0_in1, ADD3_0_in2 : std_logic_vector(17 downto 0);
	signal ADD3_1_in0, ADD3_1_in1, ADD3_1_in2 : std_logic_vector(17 downto 0);
	signal ADD3_0_out, ADD3_1_out : std_logic_vector(19 downto 0);
	signal ExtRF_out0_h, ExtRF_out0_v : std_logic_vector(10 downto 0);
	signal ExtRF_out1_h, ExtRF_out1_v : std_logic_vector(10 downto 0);
	signal ExtRF_out2_h, ExtRF_out2_v : std_logic_vector(10 downto 0);

	-- Extimator-construction connection
	signal cMVP0, cMVP1, cMVP2 : motion_vector(1 downto 0);
	signal VALID_CONST_int, GOT_int : std_logic;
	signal eMV0_in_int, eMV1_in_int, eMV2_in_int : motion_vector(1 downto 0);

	constant Tc: time := 3 ns; 

begin

	uut: extimator_expanded_netlist_wrapper
			port map( VALID_VTM=>VALID_t, VALID_CONST=>VALID_CONST_int, MV0_in=>eMV0_in_int, MV1_in=>eMV1_in_int, MV2_in=>eMV2_in_int,
				  CurCU_h=>=>CU_h_t, CurCU_w=>=>CU_h_t,
				  sixPar=>sixPar_t,
				  clk=>clk, CU_RST=>RST_t,
				  RefPel=>RefPel_int, CurPel=>CurPel,
				  RADDR_RefCu_x=>RADDR_RefCu_x_int, RADDR_RefCu_y=>RADDR_RefCu_y_int,
				  RADDR_CurCu_x=>RADDR_CurCu_x_int, RADDR_CurCu_y=>RADDR_CurCu_y_int,
				  MEM_RE=>MEM_RE_int,
				  extimator_READY=>eREADY_t, GOT=>GOT_int,
				  MV0_out=>MV0_out_t, MV1_out=>MV1_out_t, MV2_out=>MV2_out_t,
				  DONE=>eDONE_int,
				--For the output checker
				  eComp_EN=>eComp_EN_int,
				  CurSAD=>CurSAD_int,
				  --Expanded part
				  last_block_x=>last_block_x, last_block_y=>last_block_y,
				  last_cand=>last_cand, Second_ready=>Second_ready, CountTerm_OUT=>CountTerm_OUT,
				  INTER_DATA_VALID_SET=>INTER_DATA_VALID_SET, INTER_DATA_VALID_RESET=>INTER_DATA_VALID_RESET,
				  ADD3_MVin_LE_fSET=>ADD3_MVin_LE_fSET, ADD3_MVin_LE_nSET=>ADD3_MVin_LE_nSET, ADD3_MVin_LE_fRESET=>ADD3_MVin_LE_fRESET,
				  LE_ab=>LE_ab, SAD_tmp_RST=>SAD_tmp_RST, Comp_EN=>Comp_EN, OUT_LE=>OUT_LE, CountTerm_EN=>CountTerm_EN, CandCount_CE=>CandCount_CE, RF_in_RE=>RF_in_RE,
				  BestCand=>BestCand,
				  MULT1_VALID=>MULT1_VALID, ADD3_VALID=>ADD3_VALID, incrY=>incrY,
				  ADD3_MVin_LE=>ADD3_MVin_LE,
				  eCU_PS=>eCU_PS, eCU_NS=>eCU_NS
				  --For the output checker
				  eComp_EN: out std_logic;
				  CurSAD: out std_logic_vector(17 downto 0);
				  --Expanded part
				  last_block_x, last_block_y: out std_logic;
				  last_cand, Second_ready, CountTerm_OUT: out std_logic;
				  INTER_DATA_VALID_SET, INTER_DATA_VALID_RESET: out std_logic;
				  ADD3_MVin_LE_fSET, ADD3_MVin_LE_nSET, ADD3_MVin_LE_fRESET: out std_logic;
				  LE_ab, SAD_tmp_RST, Comp_EN, OUT_LE, CountTerm_EN, CandCount_CE, RF_in_RE: out std_logic;
				  BestCand: out std_logic;
				  MULT1_VALID, ADD3_VALID, incrY: out std_logic;
				  ADD3_MVin_LE: out std_logic;
				  eCU_PS, eCU_NS: out std_logic_vector(4 downto 0)
			);

	constructor_dummy: constructor
		port map( MV0=>cMV0_in_t,MV1=>cMV1_in_t,MV2=>cMV2_in_t,
					  CU_h=>CU_h_t, CU_W=>CU_w_t,
					  START=>START_t, GOT=>GOT_int, clk=>clk, CU_RST=>RST_t: in std_logic;
					  READY=>cREADY_t, DONE=>VALID_CONST_int: out std_logic;
					  MVP0=>cMVP0,MVP1=>cMVP1,MVP2=>cMVP2,
					  cComp_EN=>cComp_EN_int,
					  D_Cur=>D_Cur_int
					);

	eMV0_in_int<= eMV0_in_t when eIN_SEL_t='0' else cMVP0;
	eMV1_in_int<= eMV1_in_t when eIN_SEL_t='0' else cMVP1;
	eMV2_in_int<= eMV2_in_t when eIN_SEL_t='0' else cMVP2;
		

	uut_mem: DATA_MEMORY
		port map(clk, RST_t, MEM_RE_int, RADDR_CurCu_x_int, RADDR_CurCu_y_int, RADDR_RefCu_x_int, RADDR_RefCu_y_int, CurPel_int, RefPel_int);
	
	output_check: output_checker
		port map( cComp_EN_int, cDONE_int, eComp_EN_int, eDONE_int, sixPar_t, clk, END_SIM, constructed_int ,MVP0_int, MVP1_int, MVP2_int,
			  MV0_out_t, MV1_out_t, MV2_out_t, CurSAD_int, D_Cur_int );

	clock_gen: process
	begin
		clk<='0';
		wait for Tc/2;
		clk<='1';
		wait for Tc/2;
	end process;

	stimuli: process
		file fp_param: text open read_mode is "../tb/VTM_inputs/VTM_inputs.txt";
		variable row : line;
		variable row_data_read : integer;
		variable CU_w_r, CU_h_r, constructed_r, sixPar_r:integer;	-- "_r" stands for "read (from file VTM_inputs.txt)"
	begin
	------PARAMETER LOADING
		--First row: CU_w CU_h
		readline(fp_param,row);
		read(row,row_data_read);
		CU_w_r:=row_data_read;
		read(row,row_data_read);
		CU_h_r:=row_data_read;
		--Second row: constructed sixPar
		readline(fp_param,row);
		read(row,row_data_read);
		constructed_r:=row_data_read;
		read(row,row_data_read);
		sixPar_r:=row_data_read;
		--Third row: VTM candidate 0
		readline(fp_param,row);
		read(row,row_data_read);
		eMV0_in_r(0)<=row_data_read;
		read(row,row_data_read);
		eMV0_in_r(1)<=row_data_read;
		readline(fp_param,row);
		read(row,row_data_read);
		eMV1_in_r(0)<=row_data_read;
		read(row,row_data_read);
		eMV1_in_r(1)<=row_data_read;
		if sixPar_r=1 then	--if sixPar='1' there is also the third eMV2 to take into account
			readline(fp_param,row);
			read(row,row_data_read);
			eMV2_in_r(0)<=row_data_read;
			read(row,row_data_read);
			eMV2_in_r(1)<=row_data_read;
		end if;
		if constructed_r=0 then	--If there are no constructed candidates, load the second eMV2
			readline(fp_param,row);
			read(row,row_data_read);
			eMV0_in_r2(0)<=row_data_read;
			read(row,row_data_read);
			eMV0_in_r2(1)<=row_data_read;
			readline(fp_param,row);
			read(row,row_data_read);
			eMV1_in_r2(0)<=row_data_read;
			read(row,row_data_read);
			eMV1_in_r2(1)<=row_data_read;
			if sixPar_r=1 then	--if sixPar='1' there is also the third eMV2 to take into account
				readline(fp_param,row);
				read(row,row_data_read);
				eMV2_in_r2(0)<=row_data_read;
				read(row,row_data_read);
				eMV2_in_r2(1)<=row_data_read;
			end if;
		else --If the constructor needs to be used, load the constructed candidates
			for I in 0 to 2 loop
				readline(fp_param,row);
				read(row,row_data_read);
				candidate_MV0_h(I)<=row_data_read;
				read(row,row_data_read);
				candidate_MV0_v(I)<=row_data_read;
			end loop;
			for I in 0 to 1 loop
				readline(fp_param,row);
				read(row,row_data_read);
				candidate_MV1_h(I)<=row_data_read;
				read(row,row_data_read);
				candidate_MV1_v(I)<=row_data_read;
			end loop;
			for I in 0 to 1 loop
				readline(fp_param,row);
				read(row,row_data_read);
				candidate_MV2_h(I)<=row_data_read;
				read(row,row_data_read);
				candidate_MV2_v(I)<=row_data_read;
			end loop;
		end if;
		
	------Input stimuli
		--Alba dei tempi
		END_SIM<='0';
		if constructed_r=0 then
			constructed_int<='0';
		else
			constructed_int<='1';
		end if;
		CU_w_t<=std_logic_vector(to_unsigned(0,CU_w_t'length));
		CU_h_t<=std_logic_vector(to_unsigned(0,CU_h_t'length));
		RST_t<='0';
		START_t<='0';
		VALID_t<='0';
		eIN_SEL_t<='0';--VTM input
		eMV0_in_t(0)<=std_logic_vector(to_signed(0,eMV0_in_t(0)'length));
		eMV0_in_t(1)<=std_logic_vector(to_signed(0,eMV0_in_t(1)'length));
		eMV1_in_t(0)<=std_logic_vector(to_signed(0,eMV1_in_t(0)'length));
		eMV1_in_t(1)<=std_logic_vector(to_signed(0,eMV1_in_t(1)'length));
		eMV2_in_t(0)<=std_logic_vector(to_signed(0,eMV2_in_t(0)'length));
		eMV2_in_t(1)<=std_logic_vector(to_signed(0,eMV2_in_t(1)'length));
		cMV0_in_t(0)<=std_logic_vector(to_signed(0,cMV0_in_t(0)'length));
		cMV0_in_t(1)<=std_logic_vector(to_signed(0,cMV0_in_t(1)'length));
		cMV1_in_t(0)<=std_logic_vector(to_signed(0,cMV1_in_t(0)'length));
		cMV1_in_t(1)<=std_logic_vector(to_signed(0,cMV1_in_t(1)'length));
		cMV2_in_t(0)<=std_logic_vector(to_signed(0,cMV2_in_t(0)'length));
		cMV2_in_t(1)<=std_logic_vector(to_signed(0,cMV2_in_t(1)'length));
		wait for Tc;
		--Primo maledetto colpo
		RST_t<='1';
		wait for Tc;
		RST_t<='0';
		wait for Tc;
		CU_w_t<=std_logic_vector(to_unsigned(CU_w_r,CU_w_t'length));
		CU_h_t<=std_logic_vector(to_unsigned(CU_h_r,CU_h_t'length));
		if sixPar_r=0 then
			sixPar_t<='0';
		else
			sixPar_t<='1';
		end if;
		VALID_t<='1';
		eIN_SEL_t<='0';--VTM input
		eMV0_in_t(0)<=std_logic_vector(to_signed(eMV0_in_r(0),eMV0_in_t(0)'length));
		eMV0_in_t(1)<=std_logic_vector(to_signed(eMV0_in_r(1),eMV0_in_t(1)'length));
		eMV1_in_t(0)<=std_logic_vector(to_signed(eMV1_in_r(0),eMV1_in_t(0)'length));
		eMV1_in_t(1)<=std_logic_vector(to_signed(eMV1_in_r(1),eMV1_in_t(1)'length));
		if sixPar_r=1 then
			eMV2_in_t(0)<=std_logic_vector(to_signed(eMV2_in_r(0),eMV2_in_t(0)'length));
			eMV2_in_t(1)<=std_logic_vector(to_signed(eMV2_in_r(1),eMV2_in_t(1)'length));
		end if;
		if constructed_r=1 then --When the constructor needs to be used
			START_t<='1';
			for I in 0 to 2 loop		
				cMV0_in_t(0)<=std_logic_vector(to_signed(candidate_MV0_h(I),cMV0_in_t(0)'length));
				cMV0_in_t(1)<=std_logic_vector(to_signed(candidate_MV0_v(I),cMV0_in_t(1)'length));
				for J in 0 to 1 loop
					cMV1_in_t(0)<=std_logic_vector(to_signed(candidate_MV1_h(J),cMV1_in_t(0)'length));
					cMV1_in_t(1)<=std_logic_vector(to_signed(candidate_MV1_v(J),cMV1_in_t(1)'length));
					for K in 0 to 1 loop
						cMV2_in_t(0)<=std_logic_vector(to_signed(candidate_MV2_h(K),cMV2_in_t(0)'length));
						cMV2_in_t(1)<=std_logic_vector(to_signed(candidate_MV2_v(K),cMV2_in_t(1)'length));
						wait for Tc;
						START_t<='0';
						VALID_t<='0';
					end loop;
				end loop;
			end loop;
			wait for Tc;
			eIN_SEL_t<='1'; --Constructor input
		else --when both candidates are from VTM
			START_t<='0';
			wait for Tc;
			VALID_t<='0';
			wait for Tc;
			VALID_t<='1';
			eMV0_in_t(0)<=std_logic_vector(to_signed(eMV0_in_r2(0),eMV0_in_t(0)'length));
			eMV0_in_t(1)<=std_logic_vector(to_signed(eMV0_in_r2(1),eMV0_in_t(1)'length));
			eMV1_in_t(0)<=std_logic_vector(to_signed(eMV1_in_r2(0),eMV1_in_t(0)'length));
			eMV1_in_t(1)<=std_logic_vector(to_signed(eMV1_in_r2(1),eMV1_in_t(1)'length));
			if sixPar_r=1 then
				eMV2_in_t(0)<=std_logic_vector(to_signed(eMV2_in_r2(0),eMV2_in_t(0)'length));
				eMV2_in_t(1)<=std_logic_vector(to_signed(eMV2_in_r2(1),eMV2_in_t(1)'length));
			end if;
			wait for Tc;
			VALID_t<='0';
		end if;
		wait until rising_edge(eDONE_int);
		wait for 2*Tc;
		END_SIM<='1';
		wait;
	end process;

end architecture tb;
