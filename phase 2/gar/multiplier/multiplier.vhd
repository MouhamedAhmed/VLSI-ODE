LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_signed.ALL;
use ieee.std_logic_misc.or_reduce;
use ieee.std_logic_misc.and_reduce;


ENTITY multiplier IS
generic( Nbits : positive := 16 );
   PORT(A     : IN  std_logic_vector(Nbits-1 DOWNTO 0);
        B     : IN  std_logic_vector(Nbits-1 DOWNTO 0);
        start : IN std_logic;
        clk   : IN  std_logic;
        result    : OUT std_logic_vector (Nbits-1 DOWNTO 0);
        overflow   : out std_logic;
        done    : out std_logic
   );        
END multiplier;

ARCHITECTURE booth_multiplier_arch OF multiplier IS

component booth_mul IS
generic( Nbits : positive := 16 );
   PORT(M     : IN  std_logic_vector(Nbits-1 DOWNTO 0);
        Q     : IN  std_logic_vector(Nbits-1 DOWNTO 0);
        start : IN std_logic;
        clk   : IN  std_logic;
        result    : OUT std_logic_vector (2*Nbits-1 DOWNTO 0);
        done    : out std_logic
   );        
END component;

signal big_result : std_logic_vector(2*Nbits-1 downto 0);

begin

    multiply: booth_mul generic map (Nbits) port map (A,B,start,clk,big_result,done);
    result <= big_result (((3*Nbits)/2)-1 downto Nbits/2);
    overflow <= '1' when or_reduce(big_result(2*Nbits-1 downto ((3*Nbits)/2))) = '1' and and_reduce(big_result(2*Nbits-1 downto ((3*Nbits)/2))) = '0' else '0';

end booth_multiplier_arch;


ARCHITECTURE binary_multiplier_arch OF multiplier IS

component binary_mul is
   generic( Nbits : positive := 16 );
   port(
      A,B: in STD_LOGIC_VECTOR (Nbits-1 DOWNTO 0);
      start : IN std_logic;
      clk:in STD_LOGIC;
      result: out STD_LOGIC_VECTOR (2*Nbits-1 DOWNTO 0);
      done    : out std_logic
     );
 end component;

signal big_result : std_logic_vector(2*Nbits-1 downto 0);

begin

    multiply: binary_mul generic map (Nbits) port map (A,B,start,clk,big_result,done);
    result <= big_result (((3*Nbits)/2)-1 downto Nbits/2);
    overflow <= '1' when or_reduce(big_result(2*Nbits-1 downto ((3*Nbits)/2))) = '1' and and_reduce(big_result(2*Nbits-1 downto ((3*Nbits)/2))) = '0' else '0';

end binary_multiplier_arch;

