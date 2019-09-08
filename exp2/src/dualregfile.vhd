-------------------------------------------------------------------------------
--
-- Title       : DualRegFile32
-- Design      : projeto_descricao_estrutural
-- Author      : Mateus Vendramini
-- Company     : University of Sao Paulo
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\MateusVendramini\projects\mips\f_mips\projeto_descricao_estrutural\src\DualRegFile32.vhd
-- Generated   : Fri Jun 28 21:20:25 2019
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {DualRegFile32} architecture {DualRegFile32}}

library IEEE;
--use IEEE.std_logic_1164.all;
use ieee.numeric_bit.all;

entity dualregfile is
	 port(
		 --Ent1 : in STD_LOGIC_VECTOR(20 downto 16);
		 --WriteRegister : in STD_LOGIC_VECTOR(4 downto 0);
		 --Ent2 : in STD_LOGIC_VECTOR(4 downto 0);
		 --WriteDataBack : in STD_LOGIC_VECTOR(31 downto 0); 
		 --clkmemreg : in std_logic;
		 --RegWriteWBInt : in std_logic;
		 --RegA : out STD_LOGIC_VECTOR(31 downto 0);
		 --RegB : out STD_LOGIC_VECTOR(31 downto 0)
		ReadRegister1 : in bit_vector (4 downto 0);
		ReadRegister2 : in bit_vector (4 downto 0);
		WriteRegister : in bit_vector (4 downto 0);
		WriteData     : in bit_vector (63 downto 0);
		Clock         : in bit;
		RegWrite      : in bit;
		ReadData1     : out bit_vector (63 downto 0);
		ReadData2     : out bit_vector (63 downto 0)
	     );
end dualregfile;

--}} End of automatically maintained section

architecture DualRegFile64 of dualregfile is	 

---- Architecture declarations -----
type ram_type is array (0 to 2**5 - 1)
        of bit_vector (64 - 1 downto 0);
signal ram: ram_type := (others => (others => '0'));


---- Signal declarations used on the diagram ----

signal enda_reg : bit_vector(5 - 1 downto 0);
signal endb_reg : bit_vector(5 - 1 downto 0);
signal endw_reg : bit_vector(5 - 1 downto 0);
begin
	
RegisterMemory :
process (Clock)
begin
	 if (Clock'event and Clock = '1') then
        if (RegWrite = '1' and to_integer(unsigned(WriteRegister)) /= 31) then
           ram(to_integer(unsigned(WriteRegister))) <= WriteData;-- after Twrite;
      end if;
        --enda_reg <= ReadRegister1;
        --endb_reg <= ReadRegister2;
     end if;
end process RegisterMemory;
	 -- le na borda de descida
		 ---- User Signal Assignments ----
		ReadData1 <= ram(to_integer(unsigned
								(ReadRegister1))); --after Tread;
		ReadData2 <= ram(to_integer(unsigned
								(ReadRegister2))); --after Tread;




end DualRegFile64;
