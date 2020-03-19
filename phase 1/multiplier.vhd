library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier is
    port(
      A,B: in STD_LOGIC_VECTOR (15 DOWNTO 0);
      result: out STD_LOGIC_VECTOR (28 DOWNTO 0)
      );
  end multiplier;

architecture archmul of multiplier is
    signal scale_factor_A : STD_LOGIC_VECTOR(3 downto 0);
    signal scale_factor_B : STD_LOGIC_VECTOR(3 downto 0);
    signal operand_A : STD_LOGIC_VECTOR(11 downto 0);
    signal operand_B : STD_LOGIC_VECTOR(11 downto 0);
    signal temp_result : STD_LOGIC_VECTOR(23 downto 0);
    signal scale_factor_out : STD_LOGIC_VECTOR(4 downto 0);
    


begin
    scale_factor_A <= A(15 downto 12);
    scale_factor_B <= B(15 downto 12);
    operand_A <= A(11 downto 0) ;
    operand_B <= B(11 downto 0) ;
    temp_result <= std_logic_vector(signed(operand_A) * signed(operand_B));
    scale_factor_out <= std_logic_vector(signed('0' & scale_factor_A) + signed('0' & scale_factor_B));
    result <= scale_factor_out & temp_result;
    



end archmul; 

