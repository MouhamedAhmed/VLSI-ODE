LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.numeric_std.all; 


entity simple_sub is
	GENERIC ( n : integer := 4);
	port(
		A: in std_logic_vector(n-1 downto 0);
		B: in std_logic_vector(n-1 downto 0);
		sum: out std_logic_vector(n-1 downto 0);
		cout: out std_logic
	);
end entity simple_sub;

architecture structural_sub of simple_sub is
	component full_adder is
	port (
		x: in std_logic;
		y: in std_logic;
		cin: in std_logic;
		sum: out std_logic;
		cout: out std_logic
		);
	end component;

	component simple_adder is
	GENERIC ( n : integer := 4);
	port(
		A: in std_logic_vector(n-1 downto 0);
		B: in std_logic_vector(n-1 downto 0);
		sum: out std_logic_vector(n-1 downto 0);
		cout: out std_logic
	);
	end component;
	
	signal carry: std_logic_vector(n downto 0);
	signal twos_comp: std_logic_vector(n-1 downto 0);
	signal one: std_logic_vector(n-1 downto 0) := (others => '0');
	signal ones_comp: std_logic_vector(n-1 downto 0);
	signal carry_out_temp: std_logic;

begin
    one(0) <= '1';
    ones_comp <= not b;
    comp: simple_adder generic map (n) port map(ones_comp, one, twos_comp, carry_out_temp);
    carry(0) <= '0';
    s_adder:
    for i in 0 to n-1 generate

	s: full_adder port map(A(i),twos_comp(i),carry(i),sum(i),carry(i+1));

    end generate s_adder;


end structural_sub;
