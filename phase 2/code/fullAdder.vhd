LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.numeric_std.all; 

entity full_adder is
	port(
		x: in std_logic;
		y: in std_logic;
		cin: in std_logic;
		sum: out std_logic;
		cout: out std_logic
	);
end entity full_adder;

architecture dataflow of full_adder is

component half_adder is
port (
	a  : in std_logic;
	b  : in std_logic;
	sum   : out std_logic;
	carry : out std_logic
	);
end component;

signal s,c1,c2: std_logic;

begin

a1: half_adder port map(x,y,s,c1);
a2: half_adder port map(s,cin,sum,c2);
cout   <= c1 or c2;

end dataflow;









