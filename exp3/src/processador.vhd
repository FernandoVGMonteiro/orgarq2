library ieee;
use ieee.numeric_bit.ALL;

entity processador is 
port (
	InstructionOut : out bit_vector(10 downto  0) -- coloquei apenas porque precisava de uma porta ?
);
end entity;

architecture arch of processador is

component control is 
	port(
		Reg2Loc: out bit;
		Uncondbranch: out bit;
		Branch: out bit;
		MemRead: out bit;
		MemtoReg: out bit;
		ALUOp: out bit_vector(1 downto 0);
		MemWrite: out bit;
		ALUSrc: out bit;
		RegWrite: out bit;
		BNZero:   out bit;
		clk : out bit;
		Instruction: in bit_vector(31 downto 21);
		bcond : out bit;
		setflags : out bit
	);
end component;

component data_path is
	port (
	   clock : in bit;

		reset : in bit;

		reg2loc : in bit;

		uncondBranch : in bit;

		branch: in bit;

		memRead: in bit;

		memToReg: in bit;

		aluCtl: in bit_vector(1 downto 0);

		memWrite: in bit;

		aluSrc: in bit;

		regWrite: in bit;
		
		BNZero:  in bit;
		

		instruction31to21: out bit_vector(10 downto 0);

		zero: out bit;
		
		bcond : in bit;
		
		setflags : in bit
	
	);
end component;

signal 	Reg2Loc : bit;
signal	Uncondbranch:  bit;
signal	Branch: bit;
signal	MemRead:  bit;
signal	MemtoReg:  bit;
signal	ALUOp:  bit_vector(1 downto 0);
signal	MemWrite:  bit;
signal	ALUSrc:  bit;
signal	RegWrite:  bit;
signal  BNZero: bit;
signal	Instruction:  bit_vector(31 downto 21);
signal clock, reset : bit;
signal bcond, setflags :bit;

begin

control_component: control
port map(Reg2Loc, Uncondbranch, Branch, MemRead, MemtoReg, ALUOp, MemWrite,ALUSrc, RegWrite, BNZero, clock, Instruction, bcond, setflags);

dp_component: data_path
port map (clock, reset, Reg2Loc, Uncondbranch, Branch, MemRead, MemtoReg, ALUOp, memWrite, AluSrc, RegWrite, BNZero, Instruction, open, bcond, setflags);

InstructionOut <= Instruction;
end architecture;
