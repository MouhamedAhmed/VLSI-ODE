Library ieee;
use ieee.std_logic_1164.all;

entity tbMachineMultiplier is
    end entity;

Architecture mytest of tbMachineMultiplier is
    Signal s_clk : std_logic := '0';
    Signal s_a_input,s_b_input : std_logic_vector(15 downto 0) := "0000000000000000";
    Signal s_output: std_logic_vector(28 downto 0);
    constant CLK_PERIOD : time := 10 ns;
    Signal test_output : std_logic_vector(57 downto 0) := "0101100000000000000000000000001011011111111111100000000000";
    Signal test_input_a : std_logic_vector(31 downto 0) := "00001111111111110000111111111111";
    Signal test_input_b : std_logic_vector(31 downto 0) := "00000000000000010000111111111111";
    
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
    
    x1:for i in 0 to 1 loop
        s_a_input<=test_input_a(i*16+15 DOWNTO i*16);
        s_b_input<=test_input_b(i*16+15 DOWNTO i*16);
        wait for CLK_PERIOD;
        assert (s_output=test_output(i*29+28 DOWNTO i*29)) report "error" severity error;
        
    end loop;
    
   wait;
    end process;
    end Architecture;
