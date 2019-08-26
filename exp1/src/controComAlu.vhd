library ieee;
use ieee.std_logic_1164.ALL;
-- use ieee.std_logic_1164.ALL;
-- use ieee.std_logic.ALL;
-- use ieee.numeric_std.ALL;
use ieee.numeric_bit.ALL;

entity clock_gen is
	generic(period: time := 10 ns);
	port(clk: out bit);
end clock_gen;

architecture comportamental of clock_gen is
	signal temp: bit :='0';
	begin
		temp <= not temp after period ;
		clk <= temp;
end comportamental;



entity control is
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
		clk: out bit;
		Instruction: in bit_vector(31 downto 21)
	);

	
end control;

architecture Control of control is 

component clock_gen is
		generic(period: time := 10 ns);
		port(clk: out bit);
	end component;

begin
	clock_generator: clock_gen
		port map (clk => clk);

	control_process: process(Instruction) begin
		case Instruction(31 downto 26) is
			when "100010" =>
				    -- Add == 10001011000 --ALUOp 10
					Reg2Loc      <= '0';
					Uncondbranch <= '0';
					Branch       <= '0';
					MemRead      <= '0';
					MemtoReg     <= '0';
					ALUOp        <= "10";
					MemWrite     <= '0';
					ALUSrc       <= '0';
					RegWrite     <= '1';

			
			when "100100" =>  
					-- Add Immediate == 10010001000 or 10010001001
					--AluOp 10
					Uncondbranch <= '0';
					Branch       <= '0';
					MemRead      <= '0';
					MemtoReg     <= '0';
					ALUOp        <= "10";
					MemWrite     <= '0';
					ALUSrc       <= '1';
					RegWrite     <= '1';
			
			when "101100" =>  -- Add Immediate & Set Flags == 10110001000 or 10110001001
					--AluOp 00
					Uncondbranch <= '0';
					Branch       <= '0';
					MemRead      <= '0';
					MemtoReg     <= '0';
					ALUOp        <= "00";
					MemWrite     <= '0';
					ALUSrc       <= '1';
					RegWrite     <= '1';

			when "101010" =>  -- Add & Set Flags == 10101011000
					--AluOp 00
					Reg2Loc      <= '0';
					Uncondbranch <= '0';
					Branch       <= '0';
					MemRead      <= '0';
					MemtoReg     <= '0';
					ALUOp        <= "00";
					MemWrite     <= '0';
					ALUSrc       <= '0';
					RegWrite     <= '1';

			when "111100" =>  --  AND Immediate & Set Flags == 111100 10000 or 11110010001
				--AluOp 11
					Reg2Loc      <= '0';
					Uncondbranch <= '0';
					Branch       <= '0';
					MemRead      <= '0';
					MemtoReg     <= '0';
					ALUOp        <= "11";
					MemWrite     <= '0';
					ALUSrc       <= '1';
					RegWrite     <= '1';

			when "111010" =>  --  AND & Set Flags == 11101 010000
				--AluOp 11
					Reg2Loc      <= '0';
					Uncondbranch <= '0';
					Branch       <= '0';
					MemRead      <= '0';
					MemtoReg     <= '0';
					ALUOp        <= "11";
					MemWrite     <= '0';
					ALUSrc       <= '0';
					RegWrite     <= '1';

			when "101101" =>  -- Compare & Branch if Zero == 10110100XXX
					--AluOp 10 para copiar
					Reg2Loc      <= '0';
					Uncondbranch <= '0';
					Branch       <= '1';
					MemRead      <= '0';
					MemtoReg     <= '0';
					ALUOp        <= "10";
					MemWrite     <= '0';
					ALUSrc       <= '0';
					RegWrite     <= '0';

			when "111110" =>
				report "Entrei no 111110";
				if (Instruction(22) = '0') then
					--AluOp 00
					-- Load Register Unscaled offset == 11111000010
					report "load";
					Uncondbranch <= '0';
					Branch       <= '0';
					MemRead      <= '1';
					MemtoReg     <= '1';
					ALUOp        <= "00";
					MemWrite     <= '0';
					ALUSrc       <= '1';
					RegWrite     <= '1';
				else --(Instruction(31 downto 21) = "11111000000") then
					-- STore Register Unscaled offset == 11111000000
					report "store";
					Reg2Loc      <= '1';
					Uncondbranch <= '0';
					Branch       <= '0';
					MemRead      <= '0';
					MemtoReg     <= '0';
					ALUOp        <= "00";
					MemWrite     <= '1';
					ALUSrc       <= '1';
					RegWrite     <= '0';
				end if;

			when "110010" =>  -- SUBtract == 11001011000
					--AluOp 01
					Reg2Loc      <= '0';
					Uncondbranch <= '0';
					Branch       <= '0';
					MemRead      <= '0';
					MemtoReg     <= '0';
					ALUOp        <= "01";
					MemWrite     <= '0';
					ALUSrc       <= '0';
					RegWrite     <= '1';

			when "110100" =>  -- SUBtract Immediate == 1101000100X
					--AluOp 01
					Uncondbranch <= '0';
					Branch       <= '0';
					MemRead      <= '0';
					MemtoReg     <= '0';
					ALUOp        <= "01";
					MemWrite     <= '0';
					ALUSrc       <= '1';
					RegWrite     <= '1';

			when others =>
					Reg2Loc      <= '0';
					Uncondbranch <= '0';
					Branch       <= '0';
					MemRead      <= '0';
					MemtoReg     <= '0';
					ALUOp        <= "00";
					MemWrite     <= '0';
					ALUSrc       <= '0';
					RegWrite     <= '0';
			
			--when "?????" =>  -- INSTRUCTION NAME
			--		Reg2Loc      <= 
			--		Uncondbranch <= 
			--		Branch       <= 
			--		MemRead      <= 
			--		MemtoReg     <= 
			--		ALUOp        <= 
			--		MemWrite     <= 
			--		ALUSrc       <= 
			--		RegWrite     <= 
			

		end case;
	end process control_process;
end architecture control;