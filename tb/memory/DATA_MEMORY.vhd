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

	constant frame_w : integer := 416;
	constant frame_h : integer := 240;
	constant x0 : integer := 208;
	constant y0 : integer := 160;
	type integer_array is array (natural range <>) of integer;
	type dm_array is array (0 to (frame_w*frame_h-1)) of std_logic_vector(7 downto 0);
	
	signal dm_cur, dm_ref: dm_array;
	signal Curframe_OUT_int : slv_8(3 downto 0);
	signal Refframe_OUT_int : slv_8(3 downto 0);


	
	--Address Calculation Curframe
	signal DM_ADDR: std_logic_vector(31 downto 0);
	signal x0_sig, y0_sig: std_logic_vector(31 downto 0);--Starting pixels address of the Current CU
	signal x0_contrib, y0_contrib: std_logic_vector(31 downto 0);
	signal frame_w_sig: std_logic_vector(31 downto 0);
	signal y0_product_tmp: std_logic_vector(63 downto 0);
	signal y0_product: std_logic_vector(31 downto 0);
	--Address Calculation Refframe
	signal DM_ADDR_ref: std_logic_vector(31 downto 0);
	signal x0_sig_ref, y0_sig_ref: std_logic_vector(31 downto 0);--Starting pixels address of the Current CU
	signal x0_contrib_ref, y0_contrib_ref: std_logic_vector(31 downto 0);
	signal frame_w_sig_ref: std_logic_vector(31 downto 0);
	signal y0_product_tmp_ref: std_logic_vector(63 downto 0);
	signal y0_product_ref: std_logic_vector(31 downto 0);

begin

----------CURRENT FRAME

----Curframe loading
	Curframe_loading: process
	file fp_cur : text open read_mode is "../tb/memory_data/Curframe.txt";
	variable row : line;
	variable row_data_read : integer_array(0 to frame_w-1);
	variable row_counter : integer :=0;
	begin
	for J in 0 to (frame_h-1) loop
		--load the row from the file in the line type
		if not(endfile(fp_cur)) then
			readline(fp_cur,row);
			row_counter := row_counter+1;
		end if;
		--load each value of the row in memory
		for I in 0 to (frame_w-1) loop
			read(row,row_data_read(I));
			dm_cur(J*frame_w+I)<=std_logic_vector(to_unsigned(row_data_read(I),dm_cur(0)'length));
		end loop;
	end loop;
	wait;
	end process;
	
	x0_sig<= std_logic_vector(to_unsigned(x0,x0_sig'length));
	x0_contrib<= std_logic_vector(unsigned(RADDR_CurCu_x)+unsigned(x0_sig));
	y0_sig<= std_logic_vector(to_unsigned(y0,y0_sig'length));
	y0_contrib<= std_logic_vector(unsigned(RADDR_CurCu_y)+unsigned(y0_sig));
	
	frame_w_sig<=std_logic_vector(to_unsigned(frame_w,frame_w_sig'length));
	y0_product_tmp<= std_logic_vector(unsigned(frame_w_sig)*unsigned(y0_contrib));
	y0_product<=y0_product_tmp(31 downto 0);
	
	DM_ADDR<=std_logic_vector(unsigned(y0_product)+unsigned(x0_contrib));
	
----Reading process
	PROCESS(clk, RST, DM_ADDR)
	BEGIN
		IF RST='1' THEN
			Curframe_OUT_int(0) <= dm_cur(0);
			Curframe_OUT_int(1) <= dm_cur(1);
			Curframe_OUT_int(2) <= dm_cur(2);
			Curframe_OUT_int(3) <= dm_cur(3);
		ELSIF(clk'EVENT AND clk = '1') AND (RE = '1') THEN
			if unsigned(DM_ADDR)>=0 AND unsigned(DM_ADDR)<=(frame_w*frame_h-1) THEN
			Curframe_OUT_int(0) <= dm_cur(to_integer(unsigned(DM_ADDR)));
			Curframe_OUT_int(1) <= dm_cur(to_integer(unsigned(DM_ADDR)+1));
			Curframe_OUT_int(2) <= dm_cur(to_integer(unsigned(DM_ADDR)+2));
			Curframe_OUT_int(3) <= dm_cur(to_integer(unsigned(DM_ADDR)+3));
			else
				Curframe_OUT_int(0) <= Curframe_OUT_int(0);
				Curframe_OUT_int(1) <= Curframe_OUT_int(1);
				Curframe_OUT_int(2) <= Curframe_OUT_int(2);
				Curframe_OUT_int(3) <= Curframe_OUT_int(3);
			end if;	
		ELSE
			Curframe_OUT_int(0) <= Curframe_OUT_int(0);
			Curframe_OUT_int(1) <= Curframe_OUT_int(1);
			Curframe_OUT_int(2) <= Curframe_OUT_int(2);
			Curframe_OUT_int(3) <= Curframe_OUT_int(3);
		END IF;
	END PROCESS;
	
	Curframe_OUT<=Curframe_OUT_int;

----------REFERENCE FRAME

----Refframe loading
	Refframe_loading: process
	file fp_ref : text open read_mode is "../tb/memory_data/Refframe.txt";
	variable row : line;
	variable row_data_read : integer_array(0 to frame_w-1);
	variable row_counter : integer :=0;
	begin
	for J in 0 to (frame_h-1) loop
		--load the row from the file in the line type
		if not(endfile(fp_ref)) then
			readline(fp_ref,row);
			row_counter := row_counter+1;
		end if;
		--load each value of the row in memory
		for I in 0 to (frame_w-1) loop
			read(row,row_data_read(I));
			dm_ref(J*frame_w+I)<=std_logic_vector(to_unsigned(row_data_read(I),dm_ref(0)'length));
		end loop;
	end loop;
	wait;
	end process;
	
	x0_sig_ref<= std_logic_vector(to_signed(x0,x0_sig_ref'length));
	x0_contrib_ref<= std_logic_vector(signed(RADDR_RefCu_x)+signed(x0_sig_ref));
	y0_sig_ref<= std_logic_vector(to_signed(y0,y0_sig_ref'length));
	y0_contrib_ref<= std_logic_vector(signed(RADDR_RefCu_y)+signed(y0_sig_ref));
	
	frame_w_sig_ref<=std_logic_vector(to_signed(frame_w,frame_w_sig_ref'length));
	y0_product_tmp_ref<= std_logic_vector(signed(frame_w_sig_ref)*signed(y0_contrib_ref));
	y0_product_ref<=y0_product_tmp_ref(31 downto 0);
	
	DM_ADDR_ref<=std_logic_vector(signed(y0_product_ref)+signed(x0_contrib_ref));

----Reading process Refframe
	PROCESS(clk, RST, DM_ADDR_ref)
	BEGIN
		IF RST='1' THEN
			Refframe_OUT_int(0) <= dm_ref(0);
			Refframe_OUT_int(1) <= dm_ref(1);
			Refframe_OUT_int(2) <= dm_ref(2);
			Refframe_OUT_int(3) <= dm_ref(3);
		ELSIF(clk'EVENT AND clk = '1') AND (RE = '1') THEN
			if unsigned(DM_ADDR_ref)>=0 AND unsigned(DM_ADDR_ref)<=(frame_w*frame_h-1) THEN
			Refframe_OUT_int(0) <= dm_ref(to_integer(unsigned(DM_ADDR_ref)));
			Refframe_OUT_int(1) <= dm_ref(to_integer(unsigned(DM_ADDR_ref)+1));
			Refframe_OUT_int(2) <= dm_ref(to_integer(unsigned(DM_ADDR_ref)+2));
			Refframe_OUT_int(3) <= dm_ref(to_integer(unsigned(DM_ADDR_ref)+3));
			else
				Refframe_OUT_int(0) <= Refframe_OUT_int(0);
				Refframe_OUT_int(1) <= Refframe_OUT_int(1);
				Refframe_OUT_int(2) <= Refframe_OUT_int(2);
				Refframe_OUT_int(3) <= Refframe_OUT_int(3);
			end if;	
		ELSE
			Refframe_OUT_int(0) <= Refframe_OUT_int(0);
			Refframe_OUT_int(1) <= Refframe_OUT_int(1);
			Refframe_OUT_int(2) <= Refframe_OUT_int(2);
			Refframe_OUT_int(3) <= Refframe_OUT_int(3);
		END IF;
	END PROCESS;
	
	Refframe_OUT<=Refframe_OUT_int;

end architecture beh;
