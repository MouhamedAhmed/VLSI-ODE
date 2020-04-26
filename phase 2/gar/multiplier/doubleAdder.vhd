LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.numeric_std.all; 


entity d_adder is
	port(
		--A, B: in std_logic_vector (1 downto 0);
		A0,A1,B0,B1: in std_logic;
		--B0: in std_logic;
		--A1: in std_logic;
		--B1: in std_logic;
		cin: in std_logic;
		--sum: out std_logic_vector (1 downto 0);
		sum0,sum1: out std_logic;
		--sum1: out std_logic;
		cout: out std_logic
	);
end entity d_adder;

architecture structural of d_adder is


component full_adder is
port (
	x: in std_logic;
	y: in std_logic;
	cin: in std_logic;
	sum: out std_logic;
	cout: out std_logic
	);
end component;

signal c: std_logic;

begin

d1: full_adder port map(A0,B0,cin,sum0,c);
d2: full_adder port map(A1,B1,c,sum1,cout);
--d1: full_adder port map(A(0),B(0),cin,sum(0),c);
--d2: full_adder port map(A(1),B(1),c,sum(1),cout);

end structural;















