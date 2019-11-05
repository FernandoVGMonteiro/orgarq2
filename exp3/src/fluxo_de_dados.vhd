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

        zero: out bit;

        bcond : in bit;
        
        setflags : in bit;
        
        bregister : in bit;
        
        blink : in bit;
        
        zeroext0 : in bit;
        
        zeroext1 : in bit;
        
        zeroext2 : in bit;
        
        exclusive : in bit;
        
        numBytes : in bit_vector (1 downto 0);
        
        fp : in bit
        
    
    );
end entity;

architecture arch of data_path is

component alu is
  port (
    A, B : in  signed(63 downto 0); -- inputs
    F    : out bit_vector(63 downto 0); -- output
    S    : in  bit_vector (3 downto 0); -- op selection
    Over : out bit; --overflow flag
    Negative : out bit; --negative flag
    Carry : out bit; --carry flag
    Z    : out bit; -- zero flag
    shift_amount_ex : in bit_vector(5 downto 0)
    );
end component;
component fp_unity is 
    port (
    A,B : in bit_vector (63 downto 0); -- inputs
    op  : in bit_vector (10 downto 0); -- op for instr
    sh  : in bit_vector (5 downto 0);  -- shamt for instr
    O   : out bit_vector (63 downto 0);
    done : out bit                     -- can continue 
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
    data : out bit_vector(wordSize-1 downto 0);
    hit  : out bit
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
    data_o : out bit_vector(wordSize-1 downto 0);
    NumBytes : in bit_vector(1 downto 0);
    hit     : out bit
  );
end component;

component alu_control is
  port (
    ALUCtrl: in bit_vector (1 downto 0);
    func: in bit_vector (10 downto 0);
    ALUOp: out bit_vector (3 downto 0)
);

end component;
signal pc_in, pc_out, soma_4, add_2_out, read_data1: bit_vector(63 downto 0);
signal read_data2, alu_in, alu_out, memory_data, write_data: bit_vector(63 downto 0);
signal instr_if, instr_id: bit_vector(31 downto 0);
signal mux_instr_reg_out: bit_vector(4 downto 0);
signal instr_extend,instr_extend_ex, shiftleft2_out : bit_vector(63 downto 0);
signal zero_ula :bit;
signal branch_signal, branch_signal_aux :bit_vector(0 downto 0);
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

--variables for B.Cond
signal alu_over, alu_carry, alu_negative, branch_conditionally :bit; 
signal flags_ex, flags_ex2, flags_wb, flags_alu :bit_vector(3 downto 0);
signal bcond_id, bcond_array : bit_vector(5 downto 0);
signal bcond_ex, bcond_mem : bit_vector(4 downto 0);
-- variable for BRegister 
signal bregister_id, bregister_ex :bit_vector(0 downto 0);
signal branch_adress : bit_vector (63 downto 0);

--variable for BLink
signal blink_id, blink_ex : bit_vector(0 downto 0);
signal reg_dest : bit_vector(4 downto 0);
signal alu_result_final : bit_vector (63 downto 0);

--variable for loads with diferent acess level
signal load_variable_id, load_variable_ex, load_variable_mem : bit_vector (2 downto 0);
signal memory_extended : bit_vector(63 downto 0);

--variable for stores with diferent acess level
signal numbytes_ex, numbytes_mem : bit_vector(1 downto 0);

--miss signal
signal hit_if, hit_mem, hit_ifmem : bit;

--shift amount signal
signal shift_amount_ex : bit_vector(5 downto 0);

-- fp signal
signal fp_id, fp_ex : bit_vector(27 downto 0);
signal fp_result : bit_vector (63 downto 0);
signal done : bit;
signal fp_exmem, fp_mem, fp_wb : bit_vector (64 downto 0);
signal write_data_fp : bit_vector (63 downto 0);
begin


-- INSTRUCTION FETCH STAGE
hit_ifmem <= hit_if and hit_mem; -- if stalls if a miss ocour in if or mem stage


add_component: alu
port map (signed(pc_out), x"0000000000000004", soma_4, "0010", open, open, open, open, "000000");

instruction_memory_component: rom
port map (pc_out, instr_if, hit_if);

pc_component: reg
generic map (64)
port map (clock, reset, hit_ifmem, pc_in, pc_out); -- only enables if it hit

mux_add1_add2_component: mux2to1
generic map (64)
port map (branch_signal(0), soma_4, ex_mem_out(197 downto 134), pc_in); -- trocar por ex_mem

if_id_in <= pc_out & instr_if;
IFID_component: reg
generic map (96)
port map (clock, reset, hit_ifmem, if_id_in, if_id_out); -- only enables if it hit 
--TODO se miss aqui, tem que adicionar NOP e não repetir a instrução anterior!!!!!!

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
-- substituir write data por write_data_fp para fp unity.
dual_reg_file: dualregfile
port map (instr_id(9 downto 5), mux_instr_reg_out, mem_wb_out(139 downto 135), write_data, clock, mem_wb_out(133), read_data1, read_data2);
--         	[286-282]		281           280        279     278          277           276     275     [274-273] 272       [271-208]                [207-144]    [143-80]     [79-16]             [15-5]                 [4-0]
id_ex_in <= instr_id(4 downto 0)&	MemtoReg & RegWrite & MemRead & MemWrite & Uncondbranch & Branch & BNZero & ALUCtl & ALUSrc & if_id_out(95 downto 32) & read_data1 & read_data2 & instr_extend &instr_id(31 downto 21) & instr_id(4 downto 0);

IDEX_component: reg
generic map (287)
port map (clock, reset, hit_mem, id_ex_in, id_ex_out);

--bcond register
bcond_array <= setflags & bcond & instr_id(3 downto 0);
idex_bcond : reg
generic map (6)
port map (clock, reset, hit_mem, bcond_array, bcond_id);

--bregister register
bregister_id(0) <= bregister;

idex_breg : reg
generic map (1)
port map (clock, reset, hit_mem, bregister_id, bregister_ex);

--blink register
blink_id(0) <= blink;
idex_blink : reg
generic map (1)
port map (clock, reset, hit_mem, blink_id, blink_ex);

load_variable_id <= zeroext0 & zeroext1 & zeroext2;
-- variable load register 
idex_loads : reg
generic map (3)
port map (clock, reset, hit_mem, load_variable_id, load_variable_ex);

--register for load with different access level
idex_stores : reg
generic map (2)
port map (clock, reset, hit_mem, numBytes, numbytes_ex);

--register for shift amount
idex_shift : reg
generic map (6)
port map (clock, reset, hit_mem, instr_id(15 downto 10), shift_amount_ex);

fp_id <= instr_id(31 downto 21) & instr_id(15 downto 0) & fp;
idex_fp : reg
generic map (28)
port map (clock, reset, hit_mem, fp_id, fp_ex);
--*********************************
-- EXECUTE
--*********************************
instr_extend_ex <= id_ex_out(79 downto 16);
shiftleft2_component: shiftleft2
port map (instr_extend_ex, shiftleft2_out);

add_component_2: alu
port map (signed(id_ex_out(271 downto 208)), signed(shiftleft2_out), add_2_out, "0010", open,  open, open, open, "000000");

mux_bregister: mux2to1
generic map (64)                   --read data 1
port map (bregister_ex(0), add_2_out, id_ex_out(207 downto 144), branch_adress);

mux_reg_alu_component: mux2to1
generic map (64)
port map (id_ex_out(272), id_ex_out(143 downto 80), instr_extend_ex, alu_in);
readdata2_debug <= id_ex_out(143 downto 80);

ALUCtrl_debug <= id_ex_out(274 downto 273);

instr_debug <= id_ex_out(10 downto 5);

alu_control_component : alu_control
port map (id_ex_out(274 downto 273), id_ex_out(15 downto 5), ALUOp);

alu_component: alu
port map (signed(id_ex_out(207 downto 144)), signed(alu_in), alu_out, ALUOp, flags_alu(3), flags_alu(2), flags_alu(1), zero_ula, shift_amount_ex); --ADICIONAR
--flags_alu <= alu_over & alu_negative & alu_carry & zero_ula;
flags_alu(0) <= zero_ula;

-- se blink = 1, resultado tem que ser o endereço de branch
mux_blink: mux2to1
generic map (64)
port map (blink_ex(0), alu_out, add_2_out, alu_result_final);

--se BCOND = 1, coloca na saída as flags salvas no registrador. Caso contrário, recebe a saída da ula para registrar se necessário.
mux_flags: mux2to1
generic map(4)
port map(bcond_id(4), flags_alu, flags_ex, flags_ex2);


--save flags 
flag_register: reg
generic map (4)
port map (clock, reset, bcond_id(5), flags_alu, flags_ex);


-- reg dst
regdst_select: mux2to1
generic map (5)
port map (blink_id(0), id_ex_out(4 downto 0), "11110", reg_dest); 
            -- msb [209-205]
            --204           203        202     201          200           199     198    
            --MemtoReg & RegWrite & MemRead & MemWrite & Uncondbranch & Branch & BNZero 
            --[204-198]	[197-134]     133       [132-69]	[68-5]				[4-0]
ex_mem_in <= id_ex_out(286 downto 275) & branch_adress & zero_ula & alu_result_final & id_ex_out(143 downto 80) & reg_dest;
EXMEM_component: reg
generic map (210)
port map (clock, reset, hit_mem, ex_mem_in, ex_mem_out);



-- fp unity
fp_component : fp_unity
port map (id_ex_out(207 downto 144), alu_in, fp_ex(17 downto 7), fp_ex(6 downto 1), fp_result, done);


-- state register for B.cond
bcond_component: reg
generic map (4)
port map (clock, reset, hit_mem, flags_ex2, flags_wb); 

--bcond register
exmem_bcond : reg
generic map (5)
port map (clock, reset, hit_mem, bcond_id(4 downto 0), bcond_ex);

-- variable load register 
exmem_loads : reg
generic map (3)
port map (clock, reset, hit_mem, load_variable_ex, load_variable_mem);

--register for load with different access level
exmem_stores : reg
generic map (2)
port map (clock, reset, hit_mem, numbytes_ex, numbytes_mem);

-- register for fp result
fp_exmem <= fp_result & fp_ex(0);
exmem_fp: reg
generic map (65)
port map (clock, reset, hit_mem, fp_exmem, fp_mem);
--*********************************
-- MEMORY
--*********************************
mem_adress_debug <= ex_mem_out(132 downto 69);
memwritedata_debug <= ex_mem_out(68 downto 5);
mem_write_debug <= ex_mem_out(201);
data_memory_component: ram
generic map (64, 64)
port map (clock, ex_mem_out(201), ex_mem_out(132 downto 69), ex_mem_out(68 downto 5), memory_data, numbytes_mem, hit_mem);

-- extensao de zeros
hword_select : mux2to1
generic map (32)
port map (load_variable_mem(2), memory_data(63 downto  32), x"00000000", memory_extended(63 downto 32));

halfword_select : mux2to1
generic map (16)
port map (load_variable_mem(1), memory_data(31 downto  16), x"0000", memory_extended(31 downto 16));

byte_select : mux2to1
generic map (8)
port map (load_variable_mem(0), memory_data(15 downto  8), x"00", memory_extended(15 downto 8));
--muxA(0) <= ((zero_ula and Branch) or Uncondbranch);
--muxB(0) <= ((not zero_ula and Branch) or Uncondbranch);
muxA(0) <= (ex_mem_out(133) and ex_mem_out(199) and not ex_mem_out(198)) or ex_mem_out(200);
muxB(0) <= ((not ex_mem_out(133)) and ex_mem_out(199) and ex_mem_out(198)) or ex_mem_out(200);
branch_conditionally <= bcond_ex(4) and ((bcond_ex(3) and flags_wb(3)) or (bcond_ex(2) and flags_wb(2)) or (bcond_ex(1) and flags_wb(1)) or (bcond_ex(0) and flags_wb(0))); 
CB_component: mux2to1
generic map(1)
port map (ex_mem_out(198), muxA, muxB, branch_signal_aux); 
branch_signal(0) <= branch_signal_aux(0) or  branch_conditionally;

    --[139-133]			[132-69]		[68-5]				[4-0]				
mem_wb_in <= ex_mem_out(209 downto 203) & memory_extended & ex_mem_out(132 downto 69) & ex_mem_out (4 downto 0);
MEMWB_component: reg
generic map (140)
port map (clock, reset, hit_mem, mem_wb_in, mem_wb_out);

-- fp register 

memwb_fp : reg
generic map (65)
port map (clock, reset, hit_mem, fp_mem, fp_wb);
--*********************************
-- WRITE BACK
--*********************************
mux_memory_reg: mux2to1
generic map (64)
port map (mem_wb_out(134),  mem_wb_out(68 downto 5), mem_wb_out(132 downto 69), write_data);

mux_fp_reg: mux2to1
generic map(64)
port map (fp_wb(0), write_data, fp_wb(64 downto 1), write_data_fp);

mem2reg_debug <= mem_wb_out(134);
instruction31to21 <= instr_id(31 downto 21);
zero <= zero_ula;

end architecture;