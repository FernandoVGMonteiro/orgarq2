library ieee;
use ieee.numeric_bit.ALL;

entity alu_control is 
	port (
		ALUCtrl: in bit_vector (1 downto 0);
		func: in bit_vector (5 downto 0);
		ALUOp: out bit_vector (3 downto 0)
	
	);
end alu_control;
 
 architecture aluctrl of alu_control is
 signal aux :bit_vector(1 downto 0);
 begin
 aux <=  func(5) & func(3);
 aluctrprocess: process (ALUCtrl, func, aux) begin
	case ALUCtrl is
	when "00" =>
		--SUM
		ALUOp <= "0010";
	when "01" => --SUB
		ALUOp <= "0110";
	when "10" =>
		case	aux is
		when "00"   => ALUOp <= "0000"; --and
		when "01"   => ALUOp <= "0010"; --sum
		when "10"   => ALUOp <= "0111"; 
		when "11"   => ALUOp <= "0111"; --copy?
		when others => ALUOp <= "0111";
		end case;
	when "11" =>
		case aux is
		when "00"   => ALUOp <= "0000"; --and
		when "01"   => ALUOp <= "0110"; --sub
		when "10"   => ALUOp <= "0111"; --dont care ?
		when "11"   => ALUOp <= "0111"; --copy?
		when others => ALUOp <= "0111";
		end case;
	when others => ALUOp <= "0111";
	end case;
 end process aluctrprocess;
 end  architecture aluctrl;