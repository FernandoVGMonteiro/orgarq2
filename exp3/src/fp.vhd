entity fp_unity is

    port (
    A,B : in bit_vector (63 downto 0); -- inputs
    op  : in bit_vector (10 downto 0); -- op for instr
    sh  : in bit_vector (5 downto 0);  -- shamt for instr
    O   : out bit_vector (63 downto 0);
    done : out bit                     -- can continue 
    );
end fp_unity;

architecture dummy of fp_unity is 
begin

O <= x"0000000000000000";
done <= '1';

end dummy;