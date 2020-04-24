LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.numeric_std.all; 


entity mux is
	port(
		--sum0: in std_logic_vector (1 downto 0);
		--sum1: in std_logic_vector (1 downto 0);
		A0,A1,B0,B1: in std_logic;
		--B0: in std_logic;
		--A1: in std_logic;
		--B1: in std_logic;
		c0: in std_logic;
		c1: in std_logic;
		s: in std_logic;
		--sumOut: out std_logic_vector (1 downto 0);
		Aout,Bout: out std_logic;
		--Bout: out std_logic;
		c: out std_logic
	);
end entity mux;

architecture behavioral of mux is
begin
process (A0, A1, B0, B1, c0, c1, s)
begin
	--if s = '0' then sumOut <= sum0; c <= c0;
	--else sumOut <= sum1; c <= c1;
	if s = '0' then Aout <= A0; Bout <= A1; c <= c0;
	else Aout <= A0; Bout <= B1; c <= c1;
end if;
end process;
end behavioral;
