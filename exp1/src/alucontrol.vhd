library ieee;
--use ieee.std_logic.all;
--use ieee.std_logic_1164.all;

entity alucontrol is
port (
	func: in bit_vector(10 downto 0);
	alu_op: in bit_vector (3 downto 0);--alu_op: in bit_vector (1 downto 0);
	alu_ctrl: out bit_vector (3 downto 0)
);
end alucontrol;

architecture withselect of alucontrol is 
begin
	alu_ctrl <= alu_op;
	--alu_ctrl(3) <= '0';
	--alu_ctrl(2) <= alu_op(0) or (alu_op(1) and func(1));
	--alu_ctrl(1) <= (not alu_op(1)) or (not func(2));
	--alu_ctrl(0) <= (func(3) or func(0)) and alu_op(1);
end withselect;

