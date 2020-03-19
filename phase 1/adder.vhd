library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
    port(
      A,B: in STD_LOGIC_VECTOR (15 DOWNTO 0);
      result: out STD_LOGIC_VECTOR (28 DOWNTO 0)
      );
  end adder;

architecture archadd of adder is

    component comp is
        port(
          operandA,operandB: in STD_LOGIC_VECTOR (11 DOWNTO 0);
          A,B: in STD_LOGIC_VECTOR (3 DOWNTO 0);
          output: out STD_LOGIC;
          scale_max: out STD_LOGIC_VECTOR (3 DOWNTO 0);
          scale_min: out STD_LOGIC_VECTOR (3 DOWNTO 0);
          max: out STD_LOGIC_VECTOR (11 DOWNTO 0);
          min: out STD_LOGIC_VECTOR (11 DOWNTO 0)
          );
      end component;

    component shift is
        port(
            A: in STD_LOGIC_VECTOR (11 DOWNTO 0);
            scale_factor: in STD_LOGIC_VECTOR (3 DOWNTO 0);
            result: out STD_LOGIC_VECTOR (24 DOWNTO 0)
          );
      end component;

    signal scale_factor_A : STD_LOGIC_VECTOR(3 downto 0);
    signal scale_factor_B : STD_LOGIC_VECTOR(3 downto 0);
    signal operand_A : STD_LOGIC_VECTOR(11 downto 0);
    signal operand_B : STD_LOGIC_VECTOR(11 downto 0);
    signal temp_result : STD_LOGIC_VECTOR(23 downto 0);
    signal scale_factor_out : STD_LOGIC_VECTOR(3 downto 0);
    signal scale_factor_diff : STD_LOGIC_VECTOR(3 downto 0);
    signal scale_index_max : STD_LOGIC;
    signal operand_scale_max : STD_LOGIC_VECTOR(11 downto 0);
    signal operand_scale_min : STD_LOGIC_VECTOR(11 downto 0);
    signal scale_max : STD_LOGIC_VECTOR(3 downto 0);
    signal scale_min : STD_LOGIC_VECTOR(3 downto 0);
    signal max_shifted : STD_LOGIC_VECTOR(24 downto 0);
    signal min_shifted : STD_LOGIC_VECTOR(24 downto 0);
    signal result_shifted : STD_LOGIC_VECTOR(24 downto 0);
    signal scale_out : STD_LOGIC_VECTOR(4 downto 0);
    signal eleven : STD_LOGIC_VECTOR(4 downto 0) := "01011";


begin
    scale_factor_A <= A(15 downto 12);
    scale_factor_B <= B(15 downto 12);
    operand_A <= A(11 downto 0) ;
    operand_B <= B(11 downto 0) ;
    u0 : comp port map (operand_A,operand_B,scale_factor_A,scale_factor_B,scale_index_max,scale_max,scale_min,operand_scale_max,operand_scale_min);

    scale_factor_diff <= std_logic_vector(unsigned(scale_max) - unsigned(scale_min));

    u1 : shift port map (operand_scale_max,scale_factor_diff,max_shifted);

    min_shifted <=(operand_scale_min(11) & operand_scale_min(11 downto 0) & "000000000000");
    result_shifted <= std_logic_vector(signed(min_shifted) + signed(max_shifted));

    
    scale_out <= std_logic_vector(signed('0'&scale_min) + signed(eleven));
    result <= scale_out & result_shifted(24 downto 1);

    



end archadd; 

