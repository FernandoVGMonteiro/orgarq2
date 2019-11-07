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
		BNZero: out bit;
		clk: out bit;
		Instruction: in bit_vector(31 downto 21);
		bcond 		: out bit;
		setflags : out bit;
		bregister : out bit;
		blink : out bit; 	
		zeroext0 : out bit;
		zeroext1 : out bit;
		zeroext2 : out bit;
		exclusive : out bit;
        numBytes  : out bit_vector(1 downto 0);
        fp : out bit
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
    BNZero <= instruction(24);
    control_process: process(Instruction) begin
        case Instruction(31 downto 26) is
            when "001111" => 
                report "fp instruction";
                Reg2Loc      <= '0';
                Uncondbranch <= '0';
                Branch       <= '0';
                MemRead      <= '0';
                MemtoReg     <= '0';
                ALUOp        <= "10";
                MemWrite     <= '0';
                ALUSrc       <= '0';
                RegWrite     <= '1';
                bcond 	     <= '0';
                setflags     <= '0';
                bregister    <= '0';
                blink 		 <= '0';
                zeroext0 	 <= '0';
                zeroext1	 <= '0';
                zeroext2     <= '0';
                exclusive 	 <= '0';
                numBytes     <= "00";
                fp           <= '1';
                
            when "000101" =>
                report "branch fetched";
                -- Branch B
                Reg2Loc      <= '0';
                Uncondbranch <= '1';
                Branch       <= '0';
                MemRead      <= '0';
                MemtoReg     <= '0';
                ALUOp        <= "00";
                MemWrite     <= '0';
                ALUSrc       <= '0';
                RegWrite     <= '0';
                bcond 	     <= '0';
                setflags     <= '0';
                bregister    <= '0';
                blink 		 <= '0';
                zeroext0 	 <= '0';
                zeroext1	 <= '0';
                zeroext2     <= '0';
                exclusive 	 <= '0';
                numBytes     <= "00";
                fp           <= '0';
			
            when "010101" => 
                -- Branch.cond
                report "branch conditionally fetched";
                Reg2Loc      <= '0';
                Uncondbranch <= '0';
                Branch       <= '0';
                MemRead      <= '0';
                MemtoReg     <= '0';
                ALUOp        <= "00";
                MemWrite     <= '0';
                ALUSrc       <= '0';
                RegWrite     <= '0';
                bcond 	     <= '1';
                setflags     <= '0';
                bregister    <= '0';
                blink 		 <= '0';
                zeroext0 	 <= '0';
                zeroext1	 <= '0';
                zeroext2     <= '0';
                exclusive 	 <= '0';
                numBytes     <= "00";
                fp           <= '0';
				
            when "110101" =>
                --BranchRegister
                report "branch register fetched";
                Reg2Loc      <= '0';
                Uncondbranch <= '1';
                Branch       <= '0';
                MemRead      <= '0';
                MemtoReg     <= '0';
                ALUOp        <= "00";
                MemWrite     <= '0';
                ALUSrc       <= '0';
                RegWrite     <= '0';
                bcond 	     <= '0';
                setflags     <= '0';
                bregister    <= '1';
                blink 		 <= '0';
                zeroext0 	 <= '0';
                zeroext1	 <= '0';
                zeroext2     <= '0';
                exclusive 	 <= '0';
                numBytes     <= "00";
                fp           <= '0';
				
            when "100101" =>
                -- Branch with Link BL
                report "branch with link fetched";
                Reg2Loc      <= '0';
                Uncondbranch <= '1';
                Branch       <= '0';
                MemRead      <= '0';
                MemtoReg     <= '0';
                ALUOp        <= "00";
                MemWrite     <= '0';
                ALUSrc       <= '0';
                RegWrite     <= '1';
                bcond 	     <= '0';
                setflags     <= '0';
                bregister    <= '0';
                blink 		 <= '1';
                zeroext0 	 <= '0';
                zeroext1	 <= '0';
                zeroext2     <= '0';
                exclusive 	 <= '0';
                numBytes     <= "00";
                fp           <= '0';
				
            when "100010" =>
                    -- AND == 10001010000
                    -- Add == 10001011000 --ALUOp 10
                    report "add fetched";
                Reg2Loc      <= '0';
                Uncondbranch <= '0';
                Branch       <= '0';
                MemRead      <= '0';
                MemtoReg     <= '0';
                ALUOp        <= "10";
                MemWrite     <= '0';
                ALUSrc       <= '0';
                RegWrite     <= '1';
                bcond 	     <= '0';
                setflags     <= '0';
                bregister    <= '0';
                blink 		 <= '0';
                zeroext0 	 <= '0';
                zeroext1	 <= '0';
                zeroext2     <= '0';
                exclusive 	 <= '0';
                numBytes     <= "00";
                fp           <= '0';

			
            when "100100" =>  
                -- Add Immediate == 10010001000 or 10010001001
                -- Andi             10010010000 or 10010010001
                --AluOp 10
                report "addi fetched fetched";
                Reg2Loc      <= '0';
                Uncondbranch <= '0';
                Branch       <= '0';
                MemRead      <= '0';
                MemtoReg     <= '0';
                ALUOp        <= "00";
                MemWrite     <= '0';
                ALUSrc       <= '1';
                RegWrite     <= '1';
                bcond 	     <= '0';
                setflags     <= '0';
                bregister    <= '0';
                blink 		 <= '0';
                zeroext0 	 <= '0';
                zeroext1	 <= '0';
                zeroext2     <= '0';
                exclusive 	 <= '0';
                numBytes     <= "00";
                fp           <= '0';
			
                              -- Inclusive ORR imediate    == 1011001000
            when "101100" =>  -- Add Immediate & Set Flags == 10110001000 or 10110001001
                    --AluOp 00
                report "addis fetched";
                Reg2Loc      <= '0';
                Uncondbranch <= '0';
                Branch       <= '0';
                MemRead      <= '0';
                MemtoReg     <= '0';
                ALUOp        <= "00";
                MemWrite     <= '0';
                ALUSrc       <= '1';
                RegWrite     <= '1';
                bcond 	     <= '0';
                setflags     <= '1';
                bregister    <= '0';
                blink 		 <= '0';
                zeroext0 	 <= '0';
                zeroext1	 <= '0';
                zeroext2     <= '0';
                exclusive 	 <= '0';
                numBytes     <= "00";
                fp           <= '0';

                              -- Inclusive or       101010110000
            when "101010" =>  -- Add & Set Flags == 10101011000
                --AluOp 00
                report "adds fetched";
                Reg2Loc      <= '0';
                Uncondbranch <= '0';
                Branch       <= '0';
                MemRead      <= '0';
                MemtoReg     <= '0';
                ALUOp        <= "00";
                MemWrite     <= '0';
                ALUSrc       <= '0';
                RegWrite     <= '1';
                bcond 	     <= '0';
                setflags     <= '1';
                bregister    <= '0';
                blink 		 <= '0';
                zeroext0 	 <= '0';
                zeroext1	 <= '0';
                zeroext2     <= '0';
                exclusive 	 <= '0';
                numBytes     <= "00";
                fp           <= '0';

                              --  MOVe wide with Keep       == 111100101XX
            when "111100" =>  --  AND Immediate & Set Flags == 111100 10000 or 11110010001
                --AluOp 11
                report "andis fetched";
                if (Instruction(23) = '1') then
                    Reg2Loc      <= '1'; -- para ler o valor anterior do registrador
                    Uncondbranch <= '0';
                    Branch       <= '0';
                    MemRead      <= '0';
                    MemtoReg     <= '0';
                    ALUOp        <= "11"; -- trocar por 10 11 para codificar 
                    MemWrite     <= '0';
                    ALUSrc       <= '1';
                    RegWrite     <= '1';
                    bcond 	     <= '0';
                    setflags     <= '0';
                    bregister    <= '0';
                    blink 		 <= '0';
                    zeroext0 	 <= '0';
                    zeroext1	 <= '0';
                    zeroext2     <= '0';
                    exclusive 	 <= '0';
                    numBytes     <= "00";
                    fp           <= '0';
                else
                    Reg2Loc      <= '0';
                    Uncondbranch <= '0';
                    Branch       <= '0';
                    MemRead      <= '0';
                    MemtoReg     <= '0';
                    ALUOp        <= "11";
                    MemWrite     <= '0';
                    ALUSrc       <= '1';
                    RegWrite     <= '1';
                    bcond 	     <= '0';
                    setflags     <= '1';
                    bregister    <= '0';
                    blink 		 <= '0';
                    zeroext0 	 <= '0';
                    zeroext1	 <= '0';
                    zeroext2     <= '0';
                    exclusive 	 <= '0';
                    numBytes     <= "00";
                    fp           <= '0';
                end if;

            when "111010" =>  --  AND & Set Flags == 11101 010000
                --AluOp 11
                report "ands fetched";
                Reg2Loc      <= '0';
                Uncondbranch <= '0';
                Branch       <= '0';
                MemRead      <= '0';
                MemtoReg     <= '0';
                ALUOp        <= "11";
                MemWrite     <= '0';
                ALUSrc       <= '0';
                RegWrite     <= '1';
                bcond 	     <= '0';
                setflags     <= '1';
                bregister    <= '0';
                blink 		 <= '0';
                zeroext0 	 <= '0';
                zeroext1	 <= '0';
                zeroext2     <= '0';
                exclusive 	 <= '0';
                numBytes     <= "00";
                fp           <= '0';

            when "101101" =>  -- Compare & Branch if Zero == 10110100XXX
                          -- Compare & Branch if Not Zero == 10110101XXX
                    --AluOp 10 para copiar
                    -- se bit 31-8 = 1, é branch not zero
                    --BNZero setado assincronamente
                    --if instruction(24) = '1' then 
                report "cbz fetched";
                Reg2Loc      <= '0';
                Uncondbranch <= '0';
                Branch       <= '1';
                MemRead      <= '0';
                MemtoReg     <= '0';
                ALUOp        <= "10";
                MemWrite     <= '0';
                ALUSrc       <= '0';
                RegWrite     <= '0';
                bcond 	     <= '0';
                setflags     <= '0';
                bregister    <= '0';
                blink 		 <= '0';
                zeroext0 	 <= '0';
                zeroext1	 <= '0';
                zeroext2     <= '0';
                exclusive 	 <= '0';
                numBytes     <= "00";
                fp           <= '0';
                        --BNZero       <= '0';
                    --else
                    --	Reg2Loc      <= '0';
                    --	Uncondbranch <= '0';
                    --	Branch       <= '1';
                    --	MemRead      <= '0';
                    --	MemtoReg     <= '0';
                    --	ALUOp        <= "10";
                    --	MemWrite     <= '0';
                    --	ALUSrc       <= '0';
                    --	RegWrite     <= '0';
                    --	BNZero       <= '1';
                    --end if;

            when "111110" =>
                report "Entrei no 111110";
                if (Instruction(22) = '0') then
                    --AluOp 00
                    -- Load Register Unscaled offset == 11111000010
                    report "load";
                    Reg2Loc      <= '0';
                    Uncondbranch <= '0';
                    Branch       <= '0';
                    MemRead      <= '1';
                    MemtoReg     <= '1';
                    ALUOp        <= "00";
                    MemWrite     <= '0';
                    ALUSrc       <= '1';
                    RegWrite     <= '1';
                    bcond 	     <= '0';
                    setflags     <= '0';
                    bregister    <= '0';
                    blink 		 <= '0';
                    zeroext0 	 <= '0';
                    zeroext1	 <= '0';
                    zeroext2     <= '0';
                    exclusive 	 <= '0';
                    numBytes     <= "00";
                    fp           <= '0';
                    
                else --(Instruction(31 downto 21) = "11111000000") then
                    -- STore Register Unscaled offset == 11111000000
                    report "store Register Unscaled offset";
                    Reg2Loc      <= '1';
                    Uncondbranch <= '0';
                    Branch       <= '0';
                    MemRead      <= '0';
                    MemtoReg     <= '0';
                    ALUOp        <= "00";
                    MemWrite     <= '1';
                    ALUSrc       <= '1';
                    RegWrite     <= '0';
                    bcond 	     <= '0';
                    setflags     <= '0';
                    bregister    <= '0';
                    blink 		 <= '0';
                    zeroext0 	 <= '0';
                    zeroext1	 <= '0';
                    zeroext2     <= '0';
                    exclusive 	 <= '0';
                    numBytes     <= "00";
                    fp           <= '0';
                    
                end if;
			
            when "001110" =>
                --AluOp 00
                if (Instruction(22) = '0') then
                    -- Load Register byte Unscaled offset == 0011100010
                    report "load byte unscaled register";
                    Reg2Loc      <= '0';
                    Uncondbranch <= '0';
                    Branch       <= '0';
                    MemRead      <= '1';
                    MemtoReg     <= '1';
                    ALUOp        <= "00";
                    MemWrite     <= '0';
                    ALUSrc       <= '1';
                    RegWrite     <= '1';
                    bcond 	     <= '0';
                    setflags     <= '0';
                    bregister    <= '0';
                    blink 		 <= '0';
                    zeroext0 	 <= '1';
                    zeroext1	 <= '1';
                    zeroext2     <= '1';
                    exclusive 	 <= '0';
                    numBytes     <= "11";
                    fp           <= '0';
				else 
                    -- STore Register Unscaled offset == 11111000000
                    report "store byte Register Unscaled offset";
                    Reg2Loc      <= '1';
                    Uncondbranch <= '0';
                    Branch       <= '0';
                    MemRead      <= '0';
                    MemtoReg     <= '0';
                    ALUOp        <= "00";
                    MemWrite     <= '1';
                    ALUSrc       <= '1';
                    RegWrite     <= '0';
                    bcond 	     <= '0';
                    setflags     <= '0';
                    bregister    <= '0';
                    blink 		 <= '0';
                    zeroext0 	 <= '0';
                    zeroext1	 <= '0';
                    zeroext2     <= '0';
                    exclusive 	 <= '0';
                    numBytes     <= "11";
                    fp           <= '0';
                end if;
                
            when "011110" =>
                --AluOp 00
                -- Load half Register Unscaled offset == 011110
                 if (Instruction(22) = '0') then
                    report "load half unscaled register ";
                    Reg2Loc      <= '0';
                    Uncondbranch <= '0';
                    Branch       <= '0';
                    MemRead      <= '1';
                    MemtoReg     <= '1';
                    ALUOp        <= "00";
                    MemWrite     <= '0';
                    ALUSrc       <= '1';
                    RegWrite     <= '1';
                    bcond 	     <= '0';
                    setflags     <= '0';
                    bregister    <= '0';
                    blink 		 <= '0';
                    zeroext0 	 <= '0';
                    zeroext1	 <= '1';
                    zeroext2     <= '1';
                    exclusive 	 <= '0';
                    numBytes     <= "10";
                    fp           <= '0';
                    
                else
                    -- STore half Register Unscaled offset == 11111000000
                    report "store half Register Unscaled offset";
                    Reg2Loc      <= '1';
                    Uncondbranch <= '0';
                    Branch       <= '0';
                    MemRead      <= '0';
                    MemtoReg     <= '0';
                    ALUOp        <= "00";
                    MemWrite     <= '1';
                    ALUSrc       <= '1';
                    RegWrite     <= '0';
                    bcond 	     <= '0';
                    setflags     <= '0';
                    bregister    <= '0';
                    blink 		 <= '0';
                    zeroext0 	 <= '0';
                    zeroext1	 <= '0';
                    zeroext2     <= '0';
                    exclusive 	 <= '0';
                    numBytes     <= "10";
                    fp           <= '0';
                end if;
					

            when "101110" =>
                --AluOp 00
                if (Instruction(23) = '1') then
                    -- 101110 00100
                    -- Load word Register Unscaled offset == 101110
                    report "load word unscaled register half ";
                    Reg2Loc      <= '0';
                    Uncondbranch <= '0';
                    Branch       <= '0';
                    MemRead      <= '1';
                    MemtoReg     <= '1';
                    ALUOp        <= "00";
                    MemWrite     <= '0';
                    ALUSrc       <= '1';
                    RegWrite     <= '1';
                    bcond 	     <= '0';
                    setflags     <= '0';
                    bregister    <= '0';
                    blink 		 <= '0';
                    zeroext0 	 <= '0';
                    zeroext1	 <= '0';
                    zeroext2     <= '1';
                    exclusive 	 <= '0';
                    numBytes     <= "01";
                    fp           <= '0';
                
                else
                    -- STore half Register Unscaled offset == 101110 00000
                    report "store half Register Unscaled offset";
                    Reg2Loc      <= '1';
                    Uncondbranch <= '0';
                    Branch       <= '0';
                    MemRead      <= '0';
                    MemtoReg     <= '0';
                    ALUOp        <= "00";
                    MemWrite     <= '1';
                    ALUSrc       <= '1';
                    RegWrite     <= '0';
                    bcond 	     <= '0';
                    setflags     <= '0';
                    bregister    <= '0';
                    blink 		 <= '0';
                    zeroext0 	 <= '0';
                    zeroext1	 <= '0';
                    zeroext2     <= '0';
                    exclusive 	 <= '0';
                    numBytes     <= "01";
                    fp           <= '0';
                
                end if;

            when "110010" =>
                -- AluOp 00
                -- Load exclusive register  == 11001000010
                if (Instruction(25) = '0') then 
                    if (Instruction(22) = '0') then
                        report "load exclusive register ";
                        Reg2Loc      <= '0';
                        Uncondbranch <= '0';
                        Branch       <= '0';
                        MemRead      <= '1';
                        MemtoReg     <= '1';
                        ALUOp        <= "00";
                        MemWrite     <= '0';
                        ALUSrc       <= '1';
                        RegWrite     <= '1';
                        bcond 	     <= '0';
                        setflags     <= '0';
                        bregister    <= '0';
                        blink 		 <= '0';
                        zeroext0 	 <= '0';
                        zeroext1	 <= '0';
                        zeroext2     <= '0';
                        exclusive 	 <= '1';
                        numBytes     <= "00";
                        fp           <= '0';
                    else
                        -- STore exclusive
                        report "store exclusive ";
                        Reg2Loc      <= '1';
                        Uncondbranch <= '0';
                        Branch       <= '0';
                        MemRead      <= '0';
                        MemtoReg     <= '0';
                        ALUOp        <= "00";
                        MemWrite     <= '1';
                        ALUSrc       <= '1';
                        RegWrite     <= '0';
                        bcond 	     <= '0';
                        setflags     <= '0';
                        bregister    <= '0';
                        blink 		 <= '0';
                        zeroext0 	 <= '0';
                        zeroext1	 <= '0';
                        zeroext2     <= '0';
                        exclusive 	 <= '1';
                        numBytes     <= "00";
                        fp           <= '0';
                    
                    end if;
                else 

            -- exclusive OR             ==     11001010000 como fazer?
			--when "110010" =>  -- SUBtract == 11001011000
					--AluOp 01
                    report "subfetched";
                    Reg2Loc      <= '0';
                    Uncondbranch <= '0';
                    Branch       <= '0';
                    MemRead      <= '0';
                    MemtoReg     <= '0';
                    ALUOp        <= "01"; --trocar por 10 ou 11
                    MemWrite     <= '0';
                    ALUSrc       <= '0';
                    RegWrite     <= '1';
                    bcond 	     <= '0';
                    setflags     <= '0';
                    bregister    <= '0';
                    blink 		 <= '0';
                    zeroext0 	 <= '0';
                    zeroext1	 <= '0';
                    zeroext2     <= '0';
                    exclusive 	 <= '0';
                    numBytes     <= "00";
                    fp           <= '0';
                end if;

                              -- MOVe wide with Zero   110100101XX
                              -- Logical Shift Right   11010011010
                              -- Logical Shift Left    11010011011
                              -- EORI                  1101001000X
            when "110100" =>  -- SUBtract Immediate == 1101000100X
                    --AluOp 01
                report "subi fetched";
                if (Instruction(23) = '1') then
                    Reg2Loc      <= '1'; -- para ler o valor anterior do registrador
                    Uncondbranch <= '0';
                    Branch       <= '0';
                    MemRead      <= '0';
                    MemtoReg     <= '0';
                    ALUOp        <= "11"; -- trocar por 10 11 para codificar 
                    MemWrite     <= '0';
                    ALUSrc       <= '1';
                    RegWrite     <= '1';
                    bcond 	     <= '0';
                    setflags     <= '0';
                    bregister    <= '0';
                    blink 		 <= '0';
                    zeroext0 	 <= '0';
                    zeroext1	 <= '0';
                    zeroext2     <= '0';
                    exclusive 	 <= '0';
                    numBytes     <= "00";
                    fp           <= '0';
                
                else
                    Reg2Loc      <= '0';
                    Uncondbranch <= '0';
                    Branch       <= '0';
                    MemRead      <= '0';
                    MemtoReg     <= '0';
                    ALUOp        <= "11"; -- trocar por 10 11 para codificar 
                    MemWrite     <= '0';
                    ALUSrc       <= '1';
                    RegWrite     <= '1';
                    bcond 	     <= '0';
                    setflags     <= '0';
                    bregister    <= '0';
                    blink 		 <= '0';
                    zeroext0 	 <= '0';
                    zeroext1	 <= '0';
                    zeroext2     <= '0';
                    exclusive 	 <= '0';
                    numBytes     <= "00";
                    fp           <= '0';
                end if;
            when "100110" =>
                report "fp instruction";
                Reg2Loc      <= '0';
                Uncondbranch <= '0';
                Branch       <= '0';
                MemRead      <= '0';
                MemtoReg     <= '0';
                ALUOp        <= "10";
                MemWrite     <= '0';
                ALUSrc       <= '0';
                RegWrite     <= '1';
                bcond 	     <= '0';
                setflags     <= '0';
                bregister    <= '0';
                blink 		 <= '0';
                zeroext0 	 <= '0';
                zeroext1	 <= '0';
                zeroext2     <= '0';
                exclusive 	 <= '0';
                numBytes     <= "00";
                fp           <= '1';
                
            when others =>
                report "not an instruction";
                Reg2Loc      <= '0';
                Uncondbranch <= '0';
                Branch       <= '0';
                MemRead      <= '0';
                MemtoReg     <= '0';
                ALUOp        <= "00";
                MemWrite     <= '0';
                ALUSrc       <= '0';
                RegWrite     <= '0';
                bcond 	     <= '0';
                setflags     <= '0';
                bregister    <= '0';
                blink 		 <= '0';
                zeroext0 	 <= '0';
                zeroext1	 <= '0';
                zeroext2     <= '0';
                exclusive 	 <= '0';
                numBytes     <= "00";
                fp           <= '0';

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