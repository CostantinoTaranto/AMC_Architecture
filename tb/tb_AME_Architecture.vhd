library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

library work;
use work.AMEpkg.all;

entity tb_AME_Architecture is
end entity;

architecture tb of tb_AME_Architecture is

	component AME_Architecture is
		port ( cMV0_in, cMV1_in, cMV2_in: in motion_vector(1 downto 0);--Constructor motion vectors (0:h, 1:v)
			   START: in std_logic; --constructor's "START"
			   CU_h, CU_w: in std_logic_vector(6 downto 0);
			   clk, RST: in std_logic;
			   cREADY: out std_logic; --constructor's READY
			   VALID: in std_logic; --extimator's VALID
			   eMV0_in, eMV1_in, eMV2_in: in motion_vector(1 downto 0);--Extimator motion vectors (0:h, 1:v)
			   sixPar : in std_logic;
			   eIN_SEL : in std_logic; --extimator input selector: 0: from VTM, 1: form constructor
			   RefPel, CurPel: in slv_8(3 downto 0);
			   RADDR_RefCu_x, RADDR_RefCu_y: out std_logic_vector(12 downto 0);
			   RADDR_CurCu_x, RADDR_CurCu_y: out std_logic_vector(5 downto 0);
			   MEM_RE: out std_logic; --Memory Read Enable
			   eREADY: out std_logic; --extimator's READY
			   eDONE: out std_logic;  --extimator's DONE
			   MV0_out, MV1_out, MV2_out: out motion_vector(1 downto 0); --Extimation result
			   --For the output checker
			   cComp_EN, cDONE, eComp_EN: out std_logic;
			   MVP0, MVP1, MVP2: out motion_vector(1 downto 0);
			   CurSAD: out std_logic_vector(17 downto 0);
			   D_Cur: out std_logic_vector(27 downto 0)
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

	constant Tc: time := 2 ns;

begin

	uut: AME_Architecture
		port map( cMV0_in_t, cMV1_in_t, cMV2_in_t, START_t, CU_h_t, CU_w_t, clk, RST_t, cREADY_t, VALID_t, eMV0_in_t, eMV1_in_t, eMV2_in_t, sixPar_t, eIN_SEL_t,
				  RefPel_int, CurPel_int, RADDR_RefCu_x_int, RADDR_RefCu_y_int, RADDR_CurCu_x_int, RADDR_CurCu_y_int, MEM_RE_int, eREADY_t, eDONE_int , MV0_out_t, MV1_out_t, MV2_out_t, cComp_EN_int, cDONE_int, eComp_EN_int,
			      MVP0_int, MVP1_int, MVP2_int, CurSAD_int, D_Cur_int);

	
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
		wait for Tc;
	------Input stimuli
		END_SIM<='0';
		if constructed_r=0 then
			constructed_int<='0';
		else
			constructed_int<='1';
		end if;
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
					end loop;
				end loop;
				START_t<='0';
				VALID_t<='0';
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
