LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.numeric_std.all; 

entity carry_look IS
    generic (n : integer := 16);
    port
	(
	A : in STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	B : in STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	sum : out STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	cout : out STD_LOGIC
        );
end carry_look;

architecture carry_look_adder_arc OF carry_look IS

signal tempSum: STD_LOGIC_VECTOR(n-1 DOWNTO 0);
signal G: STD_LOGIC_VECTOR(n-1 DOWNTO 0);
signal P: STD_LOGIC_VECTOR(n-1 DOWNTO 0);
signal tempC: STD_LOGIC_VECTOR(n-2 DOWNTO 0) := (others => '0');
signal sig_done: STD_LOGIC := '0';

begin
    tempSum <= A xor B;
    G <= A and B;
    P <= A or B;

process (G,P,tempC)
begin

    tempC(0) <= G(0);

	for i in 1 to n-2 loop
	    tempC(i) <= G(i) or (P(i) and tempC(i-1));
	end loop;

    cout <= G(n-1) or (P(n-1) and tempC(n-2));

end process;

    sum(0) <= tempSum(0);
    sum(n-1 DOWNTO 1) <= tempSum(n-1 DOWNTO 1) xor tempC(n-2 DOWNTO 0);
end carry_look_adder_arc;
