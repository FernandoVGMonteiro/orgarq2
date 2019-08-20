library ieee;
-- use ieee.std_logic_1164.ALL;
-- use ieee.std_logic.ALL;
-- use ieee.numeric_std.ALL;
use ieee.numeric_bit.ALL;

entity control is
	port(
		Reg2Loc: out bit;
		Uncondbranch: out bit;
		Branch: out bit;
		MemRead: out bit;
		MemtoReg: out bit;
		ALUOp: out bit_vector(3 downto 0);
		MemWrite: out bit;
		ALUSrc: out bit;
		RegWrite: out bit;
		Instruction: in bit_vector(31 downto 21)
	);
end control;

architecture Control of control is 
begin
	--Rst_regs <= Reset;
	-- rom hardcoded
	control_process: process(Instruction) begin
		case Instruction(31 downto 26) is
			when "100010" =>
				if (Instruction(31 downto 21) = "10001011000") then
				    -- Add == 10001011000
					Reg2Loc      <= '0';
					Uncondbranch <= '0';
					Branch       <= '0';
					MemRead      <= '0';
					MemtoReg     <= '0';
					ALUOp        <= "0010";
					MemWrite     <= '0';
					ALUSrc       <= '0';
					RegWrite     <= '1';
				elsif (Instruction(31 downto 21) = "10001010000") then
					-- AND == 10001010000
					Reg2Loc      <= '0';
					Uncondbranch <= '0';
					Branch       <= '0';
					MemRead      <= '0';
					MemtoReg     <= '0';
					ALUOp        <= "0000";
					MemWrite     <= '0';
					ALUSrc       <= '0';
					RegWrite     <= '1';
				else
					Reg2Loc      <= '0';
					Uncondbranch <= '0';
					Branch       <= '0';
					MemRead      <= '0';
					MemtoReg     <= '0';
					ALUOp        <= "0000";
					MemWrite     <= '0';
					ALUSrc       <= '0';
					RegWrite     <= '0';
				
				end if;
			
			when "100100" =>  
				
				if (Instruction(31 downto 22) = "1001000100") then
					-- Add Immediate == 10010001000 or 10010001001

					Uncondbranch <= '0';
					Branch       <= '0';
					MemRead      <= '0';
					MemtoReg     <= '0';
					ALUOp        <= "0010";
					MemWrite     <= '0';
					ALUSrc       <= '1';
					RegWrite     <= '1';
				elsif (Instruction(31 downto 22) = "1001001000") then
				 -- AND Immediate == 10010010000 or 10010010001

					Uncondbranch <= '0';
					Branch       <= '0';
					MemRead      <= '0';
					MemtoReg     <= '0';
					ALUOp        <= "0000";
					MemWrite     <= '0';
					ALUSrc       <= '1';
					RegWrite     <= '1';
				else
					Reg2Loc      <= '0';
					Uncondbranch <= '0';
					Branch       <= '0';
					MemRead      <= '0';
					MemtoReg     <= '0';
					ALUOp        <= "0000";
					MemWrite     <= '0';
					ALUSrc       <= '0';
					RegWrite     <= '0';
				end if;
			
			when "101100" =>  -- Add Immediate & Set Flags == 10110001000 or 10110001001
					
					Uncondbranch <= '0';
					Branch       <= '0';
					MemRead      <= '0';
					MemtoReg     <= '0';
					ALUOp        <= "0010";
					MemWrite     <= '0';
					ALUSrc       <= '1';
					RegWrite     <= '1';

			when "101010" =>  -- Add & Set Flags == 10101011000
					Reg2Loc      <= '0';
					Uncondbranch <= '0';
					Branch       <= '0';
					MemRead      <= '0';
					MemtoReg     <= '0';
					ALUOp        <= "0010";
					MemWrite     <= '0';
					ALUSrc       <= '0';
					RegWrite     <= '1';

			when "111100" =>  --  AND Immediate & Set Flags == 11110010000 or 11110010001
					Reg2Loc      <= '0';
					Uncondbranch <= '0';
					Branch       <= '0';
					MemRead      <= '0';
					MemtoReg     <= '0';
					ALUOp        <= "0000";
					MemWrite     <= '0';
					ALUSrc       <= '1';
					RegWrite     <= '1';

			when "111010" =>  --  AND & Set Flags == 11101010000
				if (Instruction(31 downto 21) = "11101010000") then
					Reg2Loc      <= '0';
					Uncondbranch <= '0';
					Branch       <= '0';
					MemRead      <= '0';
					MemtoReg     <= '0';
					ALUOp        <= "0000";
					MemWrite     <= '0';
					ALUSrc       <= '0';
					RegWrite     <= '1';
				elsif (Instruction(31 downto 21) = "11101011000") then
			 	-- SUBtract & set flags == 11101011000
					Reg2Loc      <= '0';
					Uncondbranch <= '0';
					Branch       <= '0';
					MemRead      <= '0';
					MemtoReg     <= '0';
					ALUOp        <= "0110";
					MemWrite     <= '0';
					ALUSrc       <= '0';
					RegWrite     <= '1';
				else
					Reg2Loc      <= '0';
					Uncondbranch <= '0';
					Branch       <= '0';
					MemRead      <= '0';
					MemtoReg     <= '0';
					ALUOp        <= "0000";
					MemWrite     <= '0';
					ALUSrc       <= '0';
					RegWrite     <= '0';
				end if;

			when "101101" =>  -- Compare & Branch if Zero == 10110100XXX
					Reg2Loc      <= '0';
					Uncondbranch <= '0';
					Branch       <= '1';
					MemRead      <= '0';
					MemtoReg     <= '0';
					ALUOp        <= "0110";
					MemWrite     <= '0';
					ALUSrc       <= '0';
					RegWrite     <= '0';

			when "111110" =>
				if (Instruction(31 downto 21) = "11111000010") then
					-- Load Register Unscaled offset == 11111000010
					Uncondbranch <= '0';
					Branch       <= '0';
					MemRead      <= '1';
					MemtoReg     <= '1';
					ALUOp        <= "0010";
					MemWrite     <= '0';
					ALUSrc       <= '1';
					RegWrite     <= '1';
				elsif (Instruction(31 downto 21) = "11111000000") then
					-- STore Register Unscaled offset == 11111000000
					Reg2Loc      <= '1';
					Uncondbranch <= '0';
					Branch       <= '0';
					MemRead      <= '0';
					MemtoReg     <= '0';
					ALUOp        <= "0010";
					MemWrite     <= '1';
					ALUSrc       <= '1';
					RegWrite     <= '0';
				else
					Reg2Loc      <= '0';
					Uncondbranch <= '0';
					Branch       <= '0';
					MemRead      <= '0';
					MemtoReg     <= '0';
					ALUOp        <= "0000";
					MemWrite     <= '0';
					ALUSrc       <= '0';
					RegWrite     <= '0';
				end if;

			when "110010" =>  -- SUBtract == 11001011000
					Reg2Loc      <= '0';
					Uncondbranch <= '0';
					Branch       <= '0';
					MemRead      <= '0';
					MemtoReg     <= '0';
					ALUOp        <= "0110";
					MemWrite     <= '0';
					ALUSrc       <= '0';
					RegWrite     <= '1';

			when "110100" =>  -- SUBtract Immediate == 1101000100X

					Uncondbranch <= '0';
					Branch       <= '0';
					MemRead      <= '0';
					MemtoReg     <= '0';
					ALUOp        <= "0110";
					MemWrite     <= '0';
					ALUSrc       <= '1';
					RegWrite     <= '1';

			when "111100" =>  -- SUBtract Immediate & Set Flags == 1111000100X
					Uncondbranch <= '0';
					Branch       <= '0';
					MemRead      <= '0';
					MemtoReg     <= '0';
					ALUOp        <= "0110";
					MemWrite     <= '0';
					ALUSrc       <= '1';
					RegWrite     <= '1';
			when others =>
					Reg2Loc      <= '0';
					Uncondbranch <= '0';
					Branch       <= '0';
					MemRead      <= '0';
					MemtoReg     <= '0';
					ALUOp        <= "0000";
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