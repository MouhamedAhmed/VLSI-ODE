Library ieee;
use ieee.std_logic_1164.all;

entity tbMachineAdder is
    end entity;

Architecture mytest of tbMachineAdder is
    Signal s_clk : std_logic := '0';
    Signal s_a_input,s_b_input : std_logic_vector(15 downto 0) := "0000000000000000";
    Signal s_output: std_logic_vector(28 downto 0);
    constant CLK_PERIOD : time := 10 ns;
    Signal test_output : std_logic_vector(289 downto 0) := "01011000000000000000000000000010111111111111110000000000000101100000000000000000000000001011111111111111100000000000010110100000000000000000000000101111111111111101111111111101100000000000001000000000000101111111111111110000000000001011111111111111110000000000010111000000000000000000000000";
    Signal test_input_a : std_logic_vector(159 downto 0) := "0000111111111111000011111111111100000000000000000000101010101010000001111111111100001111111111110001000000000001110011111111111111001010101010101100111111111111";
    Signal test_input_b : std_logic_vector(159 downto 0) := "0000000000000001000011111111111100000000000000000000010101010101000000000000000111001111111111110001000000000001110011111111111111000101010101011100000000000001";
    
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
  
    x1:for i in 0 to test_input_a'length/16-1 loop
        s_a_input<=test_input_a(i*16+15 DOWNTO i*16);
        s_b_input<=test_input_b(i*16+15 DOWNTO i*16);
        wait for CLK_PERIOD;
        assert (s_output=test_output(i*29+28 DOWNTO i*29)) report "error" severity error;
        
    end loop;
    
   wait;
    end process;
    end Architecture;
