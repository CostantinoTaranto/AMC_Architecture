library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

library work;
use work.AMEpkg.all;

entity output_checker is
	port( cComp_EN, cDONE, eComp_EN, eDONE, sixPar, clk, END_SIM: in std_logic;
		  constructed: in std_logic;
		  MVP0, MVP1, MVP2: in motion_vector(1 downto 0);
		  MV0_out, MV1_out, MV2_out: in motion_vector(1 downto 0);
		  CurSAD: in std_logic_vector(17 downto 0);
		  D_Cur: in std_logic_vector(27 downto 0)
		  );
end entity;

architecture beh of output_checker is

	
begin

	output_results_check: process(clk)
		file res_fp : text open WRITE_MODE is "C:\Users\costa\Desktop\5.2\Tesi\git\AME_Architecture\tb\results\results.txt";
		variable line_out : line;
		
		file correctOutConstr_fp : text open READ_MODE is "C:\Users\costa\Desktop\5.2\Tesi\git\AME_Architecture\tb\constructor_out\constructor_out.txt";
		variable cline: line;--cosntructor line
		variable cvalue: integer;
		file correctOutExtim_fp : text open READ_MODE is "C:\Users\costa\Desktop\5.2\Tesi\git\AME_Architecture\tb\extimator_out\extimator_out.txt";
		variable eline: line;--extimator line
		variable evalue: integer;
		
		variable D_Cur_num: integer :=0;
		variable cDONE_num: integer :=0;
		variable CurSAD_num: integer :=0;
		variable eDONE_num: integer :=0;
		variable END_SIM_written: integer :=0;
		
		variable write_first_line_out, error : std_logic := '0';
		
	begin
		if rising_edge(clk) then
			if write_first_line_out = '0' then 
				write(line_out, string'("EXPECTED OUTPUT, OUTPUT, TEST RESULT"));
				writeline(res_fp, line_out);
				write_first_line_out := '1';
			end if;

			if constructed='1' then 
				if cComp_EN='1' then
					if D_Cur_num=0 then
						readline(correctOutConstr_fp, cline);
					end if;
					read(cline, cvalue);
					write(line_out, cvalue);
					write(line_out, string'(","));
					write(line_out, to_integer(unsigned(D_Cur)));
					write(line_out, string'(","));
					D_Cur_num:=D_Cur_num+1;
					if to_integer(unsigned(D_Cur))=cvalue then
						write(line_out,string'("OK"));
					else
						write(line_out,string'("NO"));
						error :='1';
					end if;
					writeline(res_fp,line_out);
				end if;
				
				if cDONE='1' then
					if cDONE_num=0 then
						readline(correctOutConstr_fp, cline);
						for I in 0 to 1 loop
							read(cline, cvalue);
							write(line_out, cvalue);
							write(line_out, string'(","));
							write(line_out, to_integer(signed(MVP0(I))));
							write(line_out, string'(","));
							if to_integer(signed(MVP0(I)))=cvalue then
								write(line_out,string'("OK"));
							else
								write(line_out,string'("NO"));
								error :='1';
							end if;
							writeline(res_fp,line_out);
						end loop;
						readline(correctOutConstr_fp, cline);
						for I in 0 to 1 loop
							read(cline, cvalue);
							write(line_out, cvalue);
							write(line_out, string'(","));
							write(line_out, to_integer(signed(MVP1(I))));
							write(line_out, string'(","));
							if to_integer(signed(MVP1(I)))=cvalue then
								write(line_out,string'("OK"));
							else
								write(line_out,string'("NO"));
								error :='1';
							end if;
							writeline(res_fp,line_out);
						end loop;
						readline(correctOutConstr_fp, cline);
						for I in 0 to 1 loop
							read(cline, cvalue);
							write(line_out, cvalue);
							write(line_out, string'(","));
							write(line_out, to_integer(signed(MVP2(I))));
							write(line_out, string'(","));
							if to_integer(signed(MVP2(I)))=cvalue then
								write(line_out,string'("OK"));
							else
								write(line_out,string'("NO"));
								error :='1';
							end if;
							writeline(res_fp,line_out);
						end loop;
						cDONE_num:=cDONE_num+1;
					end if;
				end if;
			end if;
			
			if eComp_EN='1' then
				if CurSAD_num=0 then
					readline(correctOutExtim_fp, eline);
					CurSAD_num:=CurSAD_num+1;
				end if;
				read(eline,evalue);
				write(line_out, evalue);
				write(line_out, string'(","));
				write(line_out, to_integer(unsigned(CurSAD)));
				write(line_out, string'(","));
				if to_integer(unsigned(CurSAD))=evalue then
					write(line_out,string'("OK"));
				else
					write(line_out,string'("NO"));
					error :='1';
				end if;
				writeline(res_fp,line_out);
			end if;
			
			if eDONE='1' then
				if eDONE_num=0 then
					readline(correctOutExtim_fp, eline);
					for I in 0 to 1 loop
						read(eline, evalue);
						write(line_out, evalue);
						write(line_out, string'(","));
						write(line_out, to_integer(signed(MV0_out(I))));
						write(line_out, string'(","));
						if to_integer(signed(MV0_out(I)))=evalue then
							write(line_out,string'("OK"));
						else
							write(line_out,string'("NO"));
							error :='1';
						end if;
						writeline(res_fp,line_out);
					end loop;
					readline(correctOutExtim_fp, eline);
					for I in 0 to 1 loop
						read(eline, evalue);
						write(line_out, evalue);
						write(line_out, string'(","));
						write(line_out, to_integer(signed(MV1_out(I))));
						write(line_out, string'(","));
						if to_integer(signed(MV1_out(I)))=evalue then
							write(line_out,string'("OK"));
						else
							write(line_out,string'("NO"));
							error :='1';
						end if;
						writeline(res_fp,line_out);
					end loop;
					if sixPar='1' then
						readline(correctOutExtim_fp, eline);
						for I in 0 to 1 loop
							read(eline, evalue);
							write(line_out, evalue);
							write(line_out, string'(","));
							write(line_out, to_integer(signed(MV1_out(I))));
							write(line_out, string'(","));
							if to_integer(signed(MV2_out(I)))=evalue then
								write(line_out,string'("OK"));
							else
								write(line_out,string'("NO"));
								error :='1';
							end if;
							writeline(res_fp,line_out);
						end loop;
					end if;
					eDONE_num:=eDONE_num+1;
				end if;
			end if;
			
			if END_SIM = '1' THEN
				if END_SIM_written=0 then
					if error='0' then
						write(line_out, string'("SIMULATION ENDED SUCCESSFULLY"));
						writeline(res_fp, line_out);
					else
						write(line_out, string'("ERROR, WRONG RESULT PRODUCED"));
						writeline(res_fp, line_out);
					end if;
					END_SIM_written:=1;
				end if;
				wait;
			end if;
		end if;	
	end process;

end architecture beh;