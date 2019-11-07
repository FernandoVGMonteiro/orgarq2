library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
use std.textio.all;

entity ram is
  generic (
    addressSize : natural := 64;
    wordSize    : natural := 64;
    byteSize    : natural := 8
  );
  port (
    ck, wr : in  bit;
    addr   : in  bit_vector(addressSize-1 downto 0);
    data_i : in  bit_vector(wordSize-1 downto 0);
    data_o : out bit_vector(wordSize-1 downto 0);
    NumBytes : in bit_vector(1 downto 0);
    hit     : out bit
  );
end ram;

architecture vendorfree of ram is
  constant depth : natural := 2**10;
  type mem_type is array (0 to depth-1) of bit_vector(byteSize-1 downto 0);
  signal mem : mem_type;
begin
  wrt: process(ck)
  begin
    if (ck='1' and ck'event) then
      if (wr='1') then
        case NumBytes is 
            when "00" =>--64 bits
                mem(to_integer(unsigned(to_stdlogicvector(addr))))     <= data_i(7 downto 0);
                mem(to_integer(unsigned(to_stdlogicvector(addr))) +1 ) <= data_i(15 downto 8);
                mem(to_integer(unsigned(to_stdlogicvector(addr))) +2 ) <= data_i(23 downto 16);
                mem(to_integer(unsigned(to_stdlogicvector(addr))) +3 ) <= data_i(31 downto 24);
                mem(to_integer(unsigned(to_stdlogicvector(addr))) +4 ) <= data_i(39 downto 32);
                mem(to_integer(unsigned(to_stdlogicvector(addr))) +5 ) <= data_i(47 downto 40);
                mem(to_integer(unsigned(to_stdlogicvector(addr))) +6 ) <= data_i(55 downto 48);
                mem(to_integer(unsigned(to_stdlogicvector(addr))) +7 ) <= data_i(63 downto 56);
            when "01" =>  -- 32 bits
                mem(to_integer(unsigned(to_stdlogicvector(addr))))     <= data_i(7 downto 0);
                mem(to_integer(unsigned(to_stdlogicvector(addr))) +1 ) <= data_i(15 downto 8);
                mem(to_integer(unsigned(to_stdlogicvector(addr))) +2 ) <= data_i(23 downto 16);
                mem(to_integer(unsigned(to_stdlogicvector(addr))) +3 ) <= data_i(31 downto 24);
            when "10" => -- 16 bits 
                mem(to_integer(unsigned(to_stdlogicvector(addr))))     <= data_i(7 downto 0);
                mem(to_integer(unsigned(to_stdlogicvector(addr))) +1 ) <= data_i(15 downto 8);
            when "11" => -- 8bits 
                mem(to_integer(unsigned(to_stdlogicvector(addr)))) <= data_i(7 downto 0);
        end case;
      end if;
    end if;
  end process;
  hit <= '1';
  data_o <= mem(to_integer(unsigned(to_stdlogicvector(addr))) +7 ) & mem(to_integer(unsigned(to_stdlogicvector(addr))) +6) & mem(to_integer(unsigned(to_stdlogicvector(addr))) +5) & mem(to_integer(unsigned(to_stdlogicvector(addr))) +4) & mem(to_integer(unsigned(to_stdlogicvector(addr))) +3) & mem(to_integer(unsigned(to_stdlogicvector(addr))) +2) & mem(to_integer(unsigned(to_stdlogicvector(addr))) +1) & mem(to_integer(unsigned(to_stdlogicvector(addr)))) when unsigned(to_stdlogicvector(addr(63 downto 2))) < 1024
  else x"0000000000000000"; --
end vendorfree;
