LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.numeric_std.all; 


entity ripple is
	GENERIC ( n : integer := 4);
	port(
		A: in std_logic_vector(n-1 downto 0);
		B: in std_logic_vector(n-1 downto 0);
		sum: out std_logic_vector(n-1 downto 0);
		cout: out std_logic
	);
end entity ripple;

architecture ripple_adder_arc of ripple is
	component full_adder is
	port (
		x: in std_logic;
		y: in std_logic;
		cin: in std_logic;
		sum: out std_logic;
		cout: out std_logic
		);
	end component;
	
	signal carry: std_logic_vector(n downto 0);
	


begin

    carry(0) <= '0';
    s_adder:
    for i in 0 to n-1 generate

	s: full_adder port map(A(i),B(i),carry(i),sum(i),carry(i+1));

    end generate s_adder;


end ripple_adder_arc;