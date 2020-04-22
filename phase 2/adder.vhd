LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_signed.ALL;

ENTITY adder IS
generic( Nbits : positive := 16 );

   PORT(data1     : IN  std_logic_vector(Nbits - 1 DOWNTO 0);
        data2     : IN  std_logic_vector(Nbits - 1 DOWNTO 0);
        result    : OUT std_logic_vector (Nbits - 1 DOWNTO 0);
        overflow  : OUT std_logic
   );        
END adder;

ARCHITECTURE arch OF adder IS
    SIGNAL result_temp : std_logic_vector(Nbits - 1 DOWNTO 0);
BEGIN
    result_temp <= (data1 + data2);
    overflow    <= '1' WHEN (data1(Nbits - 1)=data2(Nbits - 1) AND result_temp(Nbits - 1)/=data1(Nbits - 1));
    result      <= result_temp;
END arch;