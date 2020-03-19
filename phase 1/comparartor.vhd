library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;               -- Needed for shifts

entity comp is
    port(
      operandA,operandB: in STD_LOGIC_VECTOR (11 DOWNTO 0);
      A,B: in STD_LOGIC_VECTOR (3 DOWNTO 0);
      output: out STD_LOGIC;
      scale_max: out STD_LOGIC_VECTOR (3 DOWNTO 0);
      scale_min: out STD_LOGIC_VECTOR (3 DOWNTO 0);
      max: out STD_LOGIC_VECTOR (11 DOWNTO 0);
      min: out STD_LOGIC_VECTOR (11 DOWNTO 0)
      );
  end comp;

architecture archcomp of comp is
    signal xorr : STD_LOGIC_VECTOR(3 downto 0);
    signal selectors : STD_LOGIC_VECTOR(3 downto 0);
    signal t : STD_LOGIC_VECTOR(3 downto 0);
    signal o : STD_LOGIC;
begin
    xorr <= A xor B;
    selectors(3) <= xorr(3);
    selectors(2) <= not xorr(3) and xorr(2);
    selectors(1) <= not xorr(3) and not xorr(2) and xorr(1);
    selectors(0) <= not xorr(3) and not xorr(2) and not xorr(1) and xorr(0);

    t <= selectors and (not A);
    o <= t(0) or t(1) or t(2) or t(3);
    
    max <= operandA when o = '0' else operandB;
    min <= operandA when o = '1' else operandB;
    scale_max <= A when o = '0' else B;
    scale_min <= A when o = '1' else B;
    output <= o;


end archcomp; 

