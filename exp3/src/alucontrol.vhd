library ieee;
use ieee.numeric_bit.ALL;

entity alu_control is 
	port (
		ALUCtrl: in bit_vector (1 downto 0);
		func: in bit_vector (10 downto 0);
		ALUOp: out bit_vector (3 downto 0)
	
	);
end alu_control;
 
 architecture aluctrl of alu_control is
 signal aux :bit_vector(2 downto 0);
 begin
 aux <=  func(5) & func(4) & func(3);
 aluctrprocess: process (ALUCtrl, func, aux) begin
	case ALUCtrl is
	when "00" =>
		--SUM
        report "Sum alu oper";
		ALUOp <= "0010";
	when "01" => --SUB
        report "Sub alu oper";
		ALUOp <= "0110";
	when "10" =>
		case	aux is
		when "000"   =>  ALUOp <= "0111"; --nosel      --ALUOp <= "0000"; --and
		when "001"   =>  if (func(8) = '0') then        --ALUOp <= "0111"; 
                            report "Sum alu oper";     --ALUOp <= "0111"; --copy?
                            ALUOp <= "0010"; --sum
                         else
                            ALUOp <= "0000"; --and 
                         end if;
		when "010"   => if (func(9) = '1') then
                            ALUOp <= "0001";
                            report "xclusive or alu oper";
                        elsif (func(8) = '1') then
                            ALUOp <= "0011";
                            report "inclusive or alu oper";
                        else
                            ALUOp <= "0000";
                            report "and alu oper";
                        end if;

                                                       
		when "011"   =>  ALUOp <= "0110";  
                         report "Sub alu oper";
        when "100"   => ALUOp <= "0111";
                        report "copy alu oper selected";
        when "101"   => if (func(8) = '1') then 
                            ALUOp <= "0111";
                            report "copy oper selected";
                        elsif (func(3) = '1') then
                            ALUOp <= "0010";
                            report "sum oper selected";
                        else
                            ALUOp <= "0000";
                            report "And oper selected";
                        end if;
        when "110"   => ALUOp <= "0111";
                        report "No oper selected";
        when "111"   => ALUOp <= "0111";
                        report "No oper selected";
		when others => ALUOp <= "0111";
                        report "No oper selected";
		end case;
        
	when "11" =>
		case aux is
		when "000"   => ALUOp <= "0111"; --copia
                        report "not an operation";
        when "001"   => ALUOp <= "0110"; --subtype
                        report "sub operation selected";
		when "010"   => 
            if (func(9) = '0') then 
                ALUOp <= "0011";
                report "inclusive OR operation";
            elsif (func(8) = '0') then
                if (func(2) = '0') then
                    ALUOp <= "0001";
                    report "exclusive oper select";
                else
                    ALUOP <= "0101";
                    report "MOVZ";
                end if;

            elsif (func(2) = '1') then
                ALUOp <= "0100";
                report "movk oper selected";
            else 
                ALUOp <= "0000";
                report "and oper selected";
            end if;
        
        when "011"   =>
            if (func(9) = '0') then
                ALUOp <= "0010";
                report "Sum oper selected";
            elsif (func(0)='1') then
                ALUOp <= "1001";
                report "shift left logical operation selected ";
            else
                ALUOp <= "1000";
                report "shift right logical operation selected";
            end if;
            
		when "100"   => ALUOp <= "0111"; --dont care ?
                        report "Not an operation selected";
        when "101"   => ALUOp <= "0111"; --dont care ?
            report "Not an operation selected";
		when "110"   => ALUOp <= "0111"; --copy?
            report "Not an operation selected";
        when "111"   => ALUOp <= "0111"; --copy?
            report "Not an operation selected";
		when others => ALUOp <= "0111";
            report "Not an operation selected";
		end case;
	when others => ALUOp <= "0111";
        report "Not an operation selected";
	end case;
 end process aluctrprocess;
 end  architecture aluctrl;