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
    signal temp_r : STD_LOGIC_VECTOR(24 downto 0) ;
    signal A_sign : STD_LOGIC_VECTOR(12 downto 0) ;
    signal shift0 : STD_LOGIC_VECTOR(24 downto 0) := (others => '0');
    signal shift1 : STD_LOGIC_VECTOR(24 downto 0) := (others => '0');
    signal shift2 : STD_LOGIC_VECTOR(24 downto 0) := (others => '0');
    signal shift3 : STD_LOGIC_VECTOR(24 downto 0) := (others => '0');
    signal shift4 : STD_LOGIC_VECTOR(24 downto 0) := (others => '0');
    signal shift5 : STD_LOGIC_VECTOR(24 downto 0) := (others => '0');
    signal shift6 : STD_LOGIC_VECTOR(24 downto 0) := (others => '0');
    signal shift7 : STD_LOGIC_VECTOR(24 downto 0) := (others => '0');
    signal shift8 : STD_LOGIC_VECTOR(24 downto 0) := (others => '0');
    signal shift9 : STD_LOGIC_VECTOR(24 downto 0) := (others => '0');
    signal shift10 : STD_LOGIC_VECTOR(24 downto 0) := (others => '0');
    signal shift11 : STD_LOGIC_VECTOR(24 downto 0) := (others => '0');
    signal shift12 : STD_LOGIC_VECTOR(24 downto 0) := (others => '0');

begin
    A_sign <= (others => A(11));
    temp_r <=( A(11 downto 0) &"0000000000000");
    -- result <= std_logic_vector(shift_right(signed(temp_r), to_integer(unsigned(scale_factor)+1)));


    -- there's a more generic implementation for the shifter using counter but it will consume time due to clk 
    -- and we know that shifting will not exceed 12 bits so no problem with this simple and specific design
    
    shift0 (23 downto 12) <= A;
    shift0 (24) <= A_sign(11);

    shift1 (22 downto 11) <= A;
    shift1 (24 downto 23) <= A_sign(12 downto 11);

    shift2 (21 downto 10) <= A;
    shift2 (24 downto 22) <= A_sign(12 downto 10);
    
    shift3 (20 downto 9) <= A;
    shift3 (24 downto 21) <= A_sign(12 downto 9);

    shift4 (19 downto 8) <= A;
    shift4 (24 downto 20) <= A_sign(12 downto 8);

    shift5 (18 downto 7) <= A;
    shift5 (24 downto 19) <= A_sign(12 downto 7);

    shift6 (17 downto 6) <= A;
    shift6 (24 downto 18) <= A_sign(12 downto 6);

    shift7 (16 downto 5) <= A;
    shift7 (24 downto 17) <= A_sign(12 downto 5);

    shift8 (15 downto 4) <= A;
    shift8 (24 downto 16) <= A_sign(12 downto 4);

    shift9 (14 downto 3) <= A;
    shift9 (24 downto 15) <= A_sign(12 downto 3);

    shift10 (13 downto 2) <= A;
    shift10 (24 downto 14) <= A_sign(12 downto 2);

    shift11 (12 downto 1) <= A;
    shift11 (24 downto 13) <= A_sign(12 downto 1);

    shift12 (11 downto 0) <= A;
    shift12 (24 downto 12) <= A_sign(12 downto 0);

    result <= shift0 when scale_factor = "0000" else 
    shift1 when scale_factor = "0001" else 
    shift2 when scale_factor = "0010" else 
    shift3 when scale_factor = "0011" else 
    shift4 when scale_factor = "0100" else 
    shift5 when scale_factor = "0101" else 
    shift6 when scale_factor = "0110" else 
    shift7 when scale_factor = "0111" else 
    shift8 when scale_factor = "1000" else 
    shift9 when scale_factor = "1001" else 
    shift10 when scale_factor = "1010" else 
    shift11 when scale_factor = "1011" else 
    shift12; 
	 



end archshift; 

