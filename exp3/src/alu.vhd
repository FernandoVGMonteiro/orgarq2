--------------------------------------------------------------------------------
--! @file alu.vhd
--! @brief 64-bit ALU
--! @author Bruno Albertini (balbertini@usp.br)
--! @date 20180807
--------------------------------------------------------------------------------

library ieee;
use ieee.numeric_bit.all;

-- @brief ALU is signed and uses 2-complement
entity alu is
  port (
    A, B : in  signed(63 downto 0); -- inputs
    F    : out bit_vector(63 downto 0); -- output
    S    : in  bit_vector (3 downto 0); -- op selection
	Over : out bit; --overflow flag
	Negative : out bit; --negative flag
	Carry : out bit; --carry flag
    Z    : out bit -- zero flag
    );
end entity alu;

-- @brief Fully functional architecture
architecture functional of alu is
  signal aluout, altb: signed(63 downto 0) := (others=>'0');
  signal aluout_carry: signed(64 downto 0) := (others=>'0');
  signal in1_extended, in2_extended: signed(64 downto 0) := (others=>'0');
begin
  in1_extended <= signed('0' & bit_vector(A));
  in2_extended <= signed('0' & bit_vector(B));
  with S select aluout_carry <=
    (in1_extended and in2_extended) when "0000", -- AND
   (in1_extended or  in2_extended) when "0001", -- OR
    in1_extended +   in2_extended when "0010", -- ADD
    in1_extended -   in2_extended when "0110", -- SUB
    in1_extended    when "0111", -- copy A
   (in1_extended nor in2_extended) when "1100", -- NOR
    (others=>'0') when others;
  -- Generating A<B?1:0
  altb(63 downto 1) <= (others=>'0');
  altb(0) <= '1' when (A<B) else '0';
  aluout <= aluout_carry(63 downto 0);
  -- Generating zero flag
  Z <= '1' when (aluout=0) else '0';
  Negative <= '1' when (aluout<0) else '0';
  Carry <= bit(aluout_carry(64));
  Over <= bit(aluout_carry(64)); --rever
  -- Copying temporary signal to output
  F <= bit_vector(aluout_carry(63 downto 0));
end architecture functional;