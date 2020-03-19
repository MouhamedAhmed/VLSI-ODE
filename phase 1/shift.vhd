library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;               -- Needed for shifts

entity shift is
    port(
      A: in STD_LOGIC_VECTOR (11 DOWNTO 0);
      scale_factor: in STD_LOGIC_VECTOR (3 DOWNTO 0);
      result: out STD_LOGIC_VECTOR (24 DOWNTO 0)
      );
  end shift;

architecture archshift of shift is
    signal temp_r : STD_LOGIC_VECTOR(24 downto 0);

begin
    temp_r <=( A(11 downto 0) &"0000000000000");
    result <= std_logic_vector(shift_right(signed(temp_r), to_integer(unsigned(scale_factor)+1)));
end archshift; 

