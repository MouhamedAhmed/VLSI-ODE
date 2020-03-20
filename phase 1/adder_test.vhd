Library ieee;
use ieee.std_logic_1164.all;

entity tbMachine is
    end entity;

Architecture mytest of tbMachine is
    Signal s_clk,s_rst : std_logic := '0';
    Signal s_a_input,s_b_input : std_logic_vector(15 downto 0) := "0000000000000000";
    Signal s_output: std_logic_vector(28 downto 0);
    constant CLK_PERIOD : time := 10 ns;
    Signal test_output : std_logic_vector(7 downto 0) := "11100001";
    Signal test_input : std_logic_vector(7 downto 0) := "11110000";
    
    component adder is
    port(
      A,B: in STD_LOGIC_VECTOR (15 DOWNTO 0);
      result: out STD_LOGIC_VECTOR (28 DOWNTO 0)
      );
  end component;
begin
    a1:adder port map ( s_a_input,s_b_input,s_output);

process 
    begin
        s_clk <= not s_clk;
        wait for CLK_PERIOD/2;
    end process;

process 
    begin 
    s_rst <= '1';
    wait for CLK_PERIOD/2;
    s_rst <= '0';
    
   wait;
    end process;
    end Architecture;