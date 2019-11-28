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
    data : out bit_vector(wordSize-1 downto 0);
    hit  : out bit
  );
end rom;

architecture romhardcodded of rom is
type rom_data is array (0 to 19) of bit_vector ( wordSize - 1 downto 0 );
constant rom : rom_data := (
    x"B4000040", --add
    x"b4000040", --addi
    x"B1000000", --addis
    x"55800000", --adds
    x"8A000000", --and
    x"92000000", --and
    x"F2000000", --and
    x"EA000000", --and
    x"CA000000", --eor
    x"D2000000", --eor
    x"D3600000", --lsl
    x"D3400000", --lsr
    x"F2800000", --movk
    x"D2800000", --movz
    x"AA000000", --orr
    x"B2000000", --orr
    x"CB000000", --sub
    x"D1000000", --sub
    x"F1000000", --sub
    x"EB000000"  --sub
--	x"8B000020",  -- F add X0 = X1 + X0 00
--	x"00000000",
--	x"00000000",
--	x"00000000",
--	x"00000000",
--	x"b4000040", --CBZ to i+1           04
--	x"00000000",
--	x"00000000",
--	x"00000000",
--	x"00000000",
--	x"91000C00",  -- E addi x0 = x0 + 3
--	x"00000000",
--	x"00000000",
--	x"00000000",
--	x"00000000",
--	x"F9000FE0",  -- sw mem(sp +24 ) <= x0
--	x"00000000",
--	x"00000000",
--	x"00000000",
--	x"00000000",
--	x"00000000",
--	x"F94017E1", -- x1 <= mem(sp + 40) 
--	x"00000000",
--	x"00000000",
--	x"00000000",
--	x"00000000",
--	x"b5000040", --CBNZ to i+1 
--	x"8B000020",  -- F add X0 = X1 + X0 C
--	x"8B000020"  -- F add X0 = X1 + X0
--	--
--	--x"B1000C00",  -- D addis x0 = x0 + 3 set flags
--	--x"AB000020",  -- C add x0 = x1 + x0 set flags
--	--x"8A000020",  -- and
--	--x"B4000020", -- se x0 = 0 pula pra pc + 4
--	--
--	--
	--x"" x"8B000020",  -- F add X0 = X1 + X0
	--x"",
);
begin
    data <= rom(to_integer(unsigned(addr(31 downto 2))));
    hit <= '1'; --always hit
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
