library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity fluxo_de_dados is
	port (enable, restart, clock: in std_logic);
end entity;

architecture arch of fluxo_de_dados is

component alu is
  port (
    A, B : in  signed(63 downto 0); -- inputs
    F    : out signed(63 downto 0); -- output
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
signal instr_extend, shiftleft2_out, : bit_vector(63 downto 0);

begin

add_component: alu
port map (pc_out, others => '0' & "100", soma_4, "0010", open);

instruction_memory_component: rom
port map (pc_out, instr);

mux_instr_reg_component: mux2to1
generic map (5)
port map ("!!!!", instr(20 downto 16), instr(4 downto 0), mux_instr_reg_out);

sign_extend_component: signExtend
port map (instr, instr_extend);

shiftleft2_component: shiftleft2
port map (instr_extend, shiftleft2_out);

add_component_2: alu
port map (pc_out, shiftleft2_out, add_2_out, "0010", open);

mux_add1_add2_component: mux2to1
generic map (64)
port map ("!!!!", soma_4, add_2_out, pc_in);

mux_reg_alu_component: mux2to1
generic map (64)
port map ("!!!!", read_data2, instr_extend, alu_in);

alu_component: alu
port map (read_data1, alu_in, alu_out, "!!!!", "!!!!");

data_memory_component: ram
port map (clock, "!!!!", alu_out, read_data2, memory_data);

mux_memory_reg: mux2to1
port map ("!!!!", memory_data, alu_out, write_data);

pc_component: reg
port map (clock, reset, '1', pc_in, pc_out);

end architecture;