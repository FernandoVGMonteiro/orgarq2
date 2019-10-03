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

		aluCtl: in bit_vector(1 downto 0);

		memWrite: in bit;

		aluSrc: in bit;

		regWrite: in bit;
		
		BNZero: in bit;

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

component alu_control is
  port (
    ALUCtrl: in bit_vector (1 downto 0);
    func: in bit_vector (5 downto 0);
    ALUOp: out bit_vector (3 downto 0)
);

end component;
signal pc_in, pc_out, soma_4, add_2_out, read_data1: bit_vector(63 downto 0);
signal read_data2, alu_in, alu_out, memory_data, write_data: bit_vector(63 downto 0);
signal instr_if, instr_id: bit_vector(31 downto 0);
signal mux_instr_reg_out: bit_vector(4 downto 0);
signal instr_extend,instr_extend_ex, shiftleft2_out : bit_vector(63 downto 0);
signal zero_ula :bit;
signal branch_signal :bit_vector(0 downto 0);
signal ALUOp : bit_vector(3 downto 0);
signal muxA, muxB :bit_vector(0 downto 0);

-- pipeline register signals
signal if_id_in, if_id_out : bit_vector (95 downto 0);
signal id_ex_in, id_ex_out : bit_vector (286 downto 0);
signal ex_mem_in, ex_mem_out: bit_vector (209 downto 0);
signal mem_wb_in, mem_wb_out : bit_vector(139 downto 0);


--debug variables for execute
signal ALUCtrl_debug : bit_vector(1 downto 0);
signal instr_debug : bit_vector (5 downto 0);
signal regwrite_debug, mem_write_debug, mem2reg_debug : bit;
signal regdst_debug :bit_vector (4 downto 0);
signal write_data_debug, mem_adress_debug : bit_vector (63 downto 0);
signal readdata2_debug, memwritedata_debug : bit_vector (63 downto 0);
signal registerr1_debug, registerr2_debug : bit_vector (4 downto 0);
begin

-- INSTRUCTION FETCH STAGE



add_component: alu
port map (signed(pc_out), x"0000000000000004", soma_4, "0010", open);

instruction_memory_component: rom
port map (pc_out, instr_if);

pc_component: reg
generic map (64)
port map (clock, reset, '1', pc_in, pc_out);

mux_add1_add2_component: mux2to1
generic map (64)
port map (branch_signal(0), soma_4, ex_mem_out(197 downto 134), pc_in); -- trocar por ex_mem

if_id_in <= pc_out & instr_if;
IFID_component: reg
generic map (96)
port map (clock, reset, '1', if_id_in, if_id_out);

--*********************************
-- INSTRUCTION DECODE
--*********************************
instr_id <= if_id_out(31 downto 0);

mux_instr_reg_component: mux2to1
generic map (5)
port map (Reg2Loc, instr_id(20 downto 16), instr_id(4 downto 0), mux_instr_reg_out);

sign_extend_component: signExtend
port map (instr_id, instr_extend);

write_data_debug <= write_data;
regwrite_debug <= mem_wb_out(133);
regdst_debug <= mem_wb_out(139 downto 135);
registerr1_debug <= instr_id(9 downto 5);
registerr2_debug  <= mux_instr_reg_out;
dual_reg_file: dualregfile
port map (instr_id(9 downto 5), mux_instr_reg_out, mem_wb_out(139 downto 135), write_data, clock, mem_wb_out(133), read_data1, read_data2);
--         	[286-282]		281           280        279     278          277           276     275     [274-273] 272       [271-208]                [207-144]    [143-80]     [79-16]             [15-5]                 [4-0]
id_ex_in <= instr_id(4 downto 0)&	MemtoReg & RegWrite & MemRead & MemWrite & Uncondbranch & Branch & BNZero & ALUCtl & ALUSrc & if_id_out(95 downto 32) & read_data1 & read_data2 & instr_extend &instr_id(31 downto 21) & instr_id(4 downto 0);

IDEX_component: reg
generic map (287)
port map (clock, reset, '1', id_ex_in, id_ex_out);
--*********************************
-- EXECUTE
--*********************************
instr_extend_ex <= id_ex_out(79 downto 16);
shiftleft2_component: shiftleft2
port map (instr_extend_ex, shiftleft2_out);

add_component_2: alu
port map (signed(id_ex_out(271 downto 208)), signed(shiftleft2_out), add_2_out, "0010", open);


mux_reg_alu_component: mux2to1
generic map (64)
port map (id_ex_out(272), id_ex_out(143 downto 80), instr_extend_ex, alu_in);
readdata2_debug <= id_ex_out(143 downto 80);

ALUCtrl_debug <= id_ex_out(274 downto 273);

instr_debug <= id_ex_out(10 downto 5);

alu_control_component : alu_control
port map (id_ex_out(274 downto 273), id_ex_out(10 downto 5), ALUOp);
alu_component: alu
port map (signed(id_ex_out(207 downto 144)), signed(alu_in), alu_out, ALUOp, zero_ula);
			-- msb [209-205]
			--204           203        202     201          200           199     198    
			--MemtoReg & RegWrite & MemRead & MemWrite & Uncondbranch & Branch & BNZero 
			--[204-198]	[197-134]     133       [132-69]	[68-5]				[4-0]
ex_mem_in <= id_ex_out(286 downto 275) & add_2_out & zero_ula & alu_out & id_ex_out(143 downto 80) & id_ex_out(4 downto 0);
EXMEM_component: reg
generic map (210)
port map (clock, reset, '1', ex_mem_in, ex_mem_out);
--*********************************
-- MEMORY
--*********************************
mem_adress_debug <= ex_mem_out(132 downto 69);
memwritedata_debug <= ex_mem_out(68 downto 5);
mem_write_debug <= ex_mem_out(201);
data_memory_component: ram
generic map (64, 64)
port map (clock, ex_mem_out(201), ex_mem_out(132 downto 69), ex_mem_out(68 downto 5), memory_data);

--muxA(0) <= ((zero_ula and Branch) or Uncondbranch);
--muxB(0) <= ((not zero_ula and Branch) or Uncondbranch);
muxA(0) <= (ex_mem_out(133) and ex_mem_out(199) and not ex_mem_out(198)) or ex_mem_out(200);
muxB(0) <= ((not ex_mem_out(133)) and ex_mem_out(199) and ex_mem_out(198)) or ex_mem_out(200);
CB_component: mux2to1
generic map(1)
port map (ex_mem_out(198), muxA, muxB, branch_signal); 
	--[139-133]			[132-69]		[68-5]				[4-0]				
mem_wb_in <= ex_mem_out(209 downto 203) & memory_data & ex_mem_out(132 downto 69) & ex_mem_out (4 downto 0);
MEMWB_component: reg
generic map (140)
port map (clock, reset, '1', mem_wb_in, mem_wb_out);
--*********************************
-- WRITE BACK
--*********************************
mux_memory_reg: mux2to1
generic map (64)
port map (mem_wb_out(134),  mem_wb_out(68 downto 5), mem_wb_out(132 downto 69), write_data);

mem2reg_debug <= mem_wb_out(134);
instruction31to21 <= instr_id(31 downto 21);
zero <= zero_ula;

end architecture;