library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;
entity twoscomplement is
    generic( Nbits : positive := 16 );
    port 
    ( 
        A : in std_logic_vector (Nbits-1 downto 0);
        Y : out std_logic_vector (Nbits-1 downto 0)
    );
end twoscomplement;

architecture twoscomplement_arch of twoscomplement is
    signal temp : std_logic_vector(Nbits-1 downto 0);
    begin
        temp <= not A;
        Y    <= std_logic_vector(unsigned(temp) + 1);
 end twoscomplement_arch;