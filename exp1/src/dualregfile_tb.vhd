library ieee;
use ieee.numeric_bit.all;

entity tb_dualregfile is
end tb_dualregfile;

architecture behavior of tb_dualregfile is

component  dualregfile is
	 port(
		 --Ent1 : in STD_LOGIC_VECTOR(20 downto 16);
		 --WriteRegister : in STD_LOGIC_VECTOR(4 downto 0);
		 --Ent2 : in STD_LOGIC_VECTOR(4 downto 0);
		 --WriteDataBack : in STD_LOGIC_VECTOR(31 downto 0); 
		 --clkmemreg : in std_logic;
		 --RegWriteWBInt : in std_logic;
		 --RegA : out STD_LOGIC_VECTOR(31 downto 0);
		 --RegB : out STD_LOGIC_VECTOR(31 downto 0)
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

signal 		ReadRegister1 : bit_vector (4 downto 0);
signal		ReadRegister2 : bit_vector (4 downto 0);
signal		WriteRegister : bit_vector (4 downto 0);
signal		WriteData     : bit_vector (63 downto 0);
signal		Clock         : bit;
signal		RegWrite      : bit;
signal		ReadData1     :  bit_vector (63 downto 0);
signal		ReadData2     :  bit_vector (63 downto 0);

begin 

drf: dualregFile port 
map ( ReadRegister1 => ReadRegister1,
      ReadRegister2  => ReadRegister2,
      WriteRegister => WriteRegister,
      WriteData     => WriteData ,
      Clock        => Clock ,
      RegWrite     => RegWrite,
      ReadData1    => ReadData1,
      ReadData2    => ReadData2
);

ck_process : process
begin 
	Clock <= '0';
	wait for 100 ns;
	Clock <= '1';
	wait for 100 ns;
end process;

tst_process : process
begin
	-- leitura de 2 registradores
	ReadRegister1 <= "00000";
	ReadRegister2 <= "00000";
	RegWrite <= '1';
	WriteRegister <= "00001";
	WriteData <=  x"FFFFFFFFFFFFFFFF";
	wait for 200 ns;
	ReadRegister1 <= "00001";
	ReadRegister2 <= "00000";
	RegWrite <= '0';
	wait for 1000 ns;
	
	
end process tst_process;
end;