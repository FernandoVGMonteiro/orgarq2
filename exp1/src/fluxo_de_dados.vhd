library ieee;
--use ieee.std_logic_1164.ALL;
use ieee.numeric_bit.ALL;

entity data_path is
	port (
	   clock : in bit;

		reset : in bit;

		reg2loc : in bit;

		uncondBranch : in bit;

		branch: in bit;

		memRead: in bit;

		memToReg: in bit;

		aluCtl: in bit_vector(3 downto 0);

		memWrite: in bit;

		aluSrc: in bit;

		regWrite: in bit;

		instruction31to21: out bit_vector(10 downto 0);

		zero: out bit
	
	);
end entity;

architecture arch of data_path is

component alu is
  port (
    A, B : in  signed(63 downto 0); -- inputs
    F    : out bit_vector(63 downto 0); -- output
    S    : in  bit_vector (3 downto 0); -- op selection
    Z    : out bit -- zero flag
    );
end component;

component mux2to1 is
	generic(ws: natural := 4); -- word size
	port(
		s:    in  bit; -- selection: 0=a, 1=b
		a, b: in	bit_vector(ws-1 downto 0); -- inputs
		o:  	out	bit_vector(ws-1 downto 0)  -- output
	);
end component;

component dualregfile is 
	port (
		ReadRegister1 : in bit_vector (4 downto 0);
		ReadRegister2 : in bit_vector (4 downto 0);
		WriteRegister : in bit_vector (4 downto 0);
		WriteData     : in bit_vector (63 downto 0);
		Clock         : in bit;
		RegWrite      : in bit;
		ReadData1     : out bit_vector (63 downto 0);
		ReadData2     : out bit_vector (63 downto 0)
	
	);
end component;

component shiftleft2 is
	generic(
		ws: natural := 64); -- word size
	port(
		i: in	 bit_vector(ws-1 downto 0); -- input
		o: out bit_vector(ws-1 downto 0)  -- output
	);
end component;

component signExtend is
	-- Size of output is expected to be greater than input
	generic(
	  ws_in:  natural := 32; -- input word size
		ws_out: natural := 64); -- output word size
	port(
		i: in	 bit_vector(ws_in-1  downto 0); -- input
		o: out bit_vector(ws_out-1 downto 0)  -- output
	);
end component;

component rom is
  generic (
    addressSize : natural := 64;
    wordSize    : natural := 32;
    mifFileName : string  := "rom.dat"
  );
  port (
    addr : in  bit_vector(addressSize-1 downto 0);
    data : out bit_vector(wordSize-1 downto 0)
  );
end component;

component reg is
	generic(wordSize: natural :=4);
	port(
		clock:    in 	bit; --! entrada de clock
		reset:	  in 	bit; --! clear assíncrono
		load:     in 	bit; --! write enable (carga paralela)
		d:   			in	bit_vector(wordSize-1 downto 0); --! entrada
		q:  			out	bit_vector(wordSize-1 downto 0) --! saída
	);
end component;

component ram is
  generic (
    addressSize : natural := 64;
    wordSize    : natural := 32
  );
  port (
    ck, wr : in  bit;
    addr   : in  bit_vector(addressSize-1 downto 0);
    data_i : in  bit_vector(wordSize-1 downto 0);
    data_o : out bit_vector(wordSize-1 downto 0)
  );
end component;

signal pc_in, pc_out, soma_4, add_2_out, read_data1: bit_vector(63 downto 0);
signal read_data2, alu_in, alu_out, memory_data, write_data: bit_vector(63 downto 0);
signal instr: bit_vector(31 downto 0);
signal mux_instr_reg_out: bit_vector(4 downto 0);
signal instr_extend, shiftleft2_out : bit_vector(63 downto 0);
signal zero_ula :bit;
signal branch_signal :bit;

begin

branch_signal <= ((zero_ula and Branch) or Uncondbranch);

add_component: alu
port map (signed(pc_out), x"0000000000000004", soma_4, "0010", open);
instruction_memory_component: rom
port map (pc_out, instr);

mux_instr_reg_component: mux2to1
generic map (5)
port map (Reg2Loc, instr(20 downto 16), instr(4 downto 0), mux_instr_reg_out);

sign_extend_component: signExtend
port map (instr, instr_extend);

shiftleft2_component: shiftleft2
port map (instr_extend, shiftleft2_out);

add_component_2: alu
port map (signed(pc_out), signed(shiftleft2_out), add_2_out, "0010", open);

mux_add1_add2_component: mux2to1
generic map (64)
port map (branch_signal, soma_4, add_2_out, pc_in);

mux_reg_alu_component: mux2to1
generic map (64)
port map (ALUSrc, read_data2, instr_extend, alu_in);

alu_component: alu
port map (signed(read_data1), signed(alu_in), alu_out, aluCtl, zero_ula);

data_memory_component: ram
generic map (64, 64)
port map (clock, memWrite, alu_out, read_data2, memory_data);

mux_memory_reg: mux2to1
generic map (64)
port map (memToReg,  alu_out, memory_data, write_data);

pc_component: reg
generic map (64)
port map (clock, reset, '1', pc_in, pc_out);

instruction31to21 <= instr(31 downto 21);
zero <= zero_ula;

dual_reg_file: dualregfile
port map (instr(9 downto 5), mux_instr_reg_out, instr(4 downto 0), write_data, clock, RegWrite, read_data1, read_data2);

end architecture;