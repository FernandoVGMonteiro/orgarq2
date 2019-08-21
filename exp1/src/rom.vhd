-- http://myfpgablog.blogspot.com/2011/12/memory-initialization-methods.html
library ieee;
--use ieee.std_logic_1164.ALL;
use ieee.numeric_bit.ALL;
--use std.textio.all;

entity rom is
  generic (
    addressSize : natural := 64;
    wordSize    : natural := 32;
    mifFileName : string  := "rom.dat"
  );
  port (
    addr : in  bit_vector(addressSize-1 downto 0);
    data : out bit_vector(wordSize-1 downto 0)
  );
end rom;

architecture romhardcodded of rom is
type rom_data is array (0 to 4) of bit_vector ( wordSize - 1 downto 0 );
constant rom : rom_data := (
	x"00000000",  -- F
	x"00000001",  -- E
	x"00000002",  -- D
	x"00000003",  -- C
	x"00000007"); -- 0
begin
    data <= rom(to_integer(unsigned(addr)));
end architecture romhardcodded;
--architecture vendorfree of rom is
--  constant depth : natural := 2**10;
--  type mem_type is array (0 to depth-1) of bit_vector(wordSize-1 downto 0);

--  impure function init_mem(mif_file_name : in string) return mem_type is
--      file     mif_file : text open read_mode is mif_file_name;
--      variable mif_line : line;
--      variable temp_bv  : bit_vector(wordSize-1 downto 0);
--      variable temp_mem : mem_type;
--  begin
--      for i in mem_type'range loop
--          readline(mif_file, mif_line);
--	  --report "mif_line = " & mif_line severity note;	
--          read(mif_line, temp_bv);
--	  --report "The value of 'temp_bv' is" &integer'image(temp_bv); 
--          temp_mem(i) := temp_bv;
--      end loop;
--      return temp_mem;
--  end;
--  constant mem : mem_type := init_mem(mifFileName);
--begin
--  data <= mem(to_integer(unsigned(to_stdlogicvector(addr))));
--end vendorfree;
