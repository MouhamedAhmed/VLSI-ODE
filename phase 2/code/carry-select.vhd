LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.numeric_std.all; 


entity carry_select is
	generic (n : integer := 16);
	port(
		A: in std_logic_vector(n-1 downto 0);
		B: in std_logic_vector(n-1 downto 0);
		sum: out std_logic_vector(n-1 downto 0);
		cout: out std_logic
	);
end entity carry_select;

architecture carry_select_adder_arc of carry_select is

	component d_adder is
	port (
		A0,A1,B0,B1: in std_logic;
		cin: in std_logic;
		sum0,sum1: out std_logic;
		cout: out std_logic
		);
	end component;


component mux is
port (
		A0,A1,B0,B1: in std_logic;
		c0: in std_logic;
		c1: in std_logic;
		s: in std_logic;
		Aout,Bout: out std_logic;
		c: out std_logic
	);
end component;

signal cs : std_logic_vector(n/2 downto 0);
signal tempC1 : std_logic_vector(n/2-1 downto 0);
signal tempC2 : std_logic_vector(n/2-1 downto 0);
signal tempSum1 : std_logic_vector(n-3 downto 0);
signal tempSum2 : std_logic_vector(n-3 downto 0);
begin

    --d0: d_adder port map(A(0 to 1),B(0 to 1),'0',sum(0 to 1),cs(0));
    d0: d_adder port map(A(0),A(1),B(0),B(1),'0',sum(0),sum(1),cs(0));

    c_adder:
    for i in 1 to (n/2)-1 generate

	--dd1: d_adder port map(A((i*2) to (i*2+1)),B((i*2) to (i*2+1)),'0',tempSum1((i*2-2) to (i*2-1)),tempC1(i-1));
	--dd2: d_adder port map(A((i*2) to (i*2+1)),B((i*2) to (i*2+1)),'1',tempSum2((i*2-2) to (i*2-1)),tempC2(i-1));
	dd1: d_adder port map(A(i*2), A(i*2+1), B(i*2), B(i*2+1), '0', tempSum1(i*2-2), tempSum1(i*2-1), tempC1(i-1));
	dd2: d_adder port map(A(i*2), A(i*2+1), B(i*2), B(i*2+1), '1', tempSum2(i*2-2), tempSum2(i*2-1), tempC2(i-1));

    end generate c_adder;

    c_mux:
    for i in 0 to (n/2)-2 generate

	--m0: mux port map(tempSum1((i*2) to (i*2+1)),tempSum2((i*2) to (i*2+1)),tempC1(i),tempC2(i),cs(i),sum((i*2+2) to (i*2+3)),cs(i+1));
	m0: mux port map(tempSum1(i*2), tempSum1(i*2+1), tempSum2(i*2), tempSum2(i*2+1), tempC1(i), tempC2(i), cs(i), sum(i*2+2), sum(i*2+3), cs(i+1));
    end generate c_mux;
    cout <= '1' when cs(n/2-1)='1' else '0';
end carry_select_adder_arc;



