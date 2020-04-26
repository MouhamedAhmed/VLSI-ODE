library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;
use ieee.std_logic_misc.or_reduce;
use ieee.std_logic_misc.and_reduce;
entity counter is
    generic( Nbits : positive := 16 );
    port 
    ( 
        restart : in std_logic;
        clk : in std_logic;
        done : out std_logic
    );
end counter;

architecture counter_arch of counter is

    component regi IS
        generic( Nbits : positive := 16 );
        PORT(
            d   : IN std_logic_vector(Nbits-1 DOWNTO 0);
            ld  : IN std_logic; -- load/enable.
            clr : IN std_logic; -- async. clear.
            clk : IN std_logic; -- clock.
            q   : OUT std_logic_vector(Nbits-1 DOWNTO 0) -- output
        );
    END component;

    signal count : std_logic_vector(Nbits-1 downto 0) := (others => '1');
    signal count_reg : std_logic_vector(Nbits-1 downto 0);
    signal clk_bar : std_logic;
    signal start_sig : std_logic;
    begin
        clk_bar <= not clk;
        u : regi generic map (Nbits) port map (count, '1', '0', clk_bar, count_reg);
        done <= not or_reduce(count);
        start_sig <= '1' when((restart = '1') and (or_reduce(count) = '0')) else '0';

    p : process (clk)
    begin
        if rising_edge(clk) then
            if start_sig = '1' or (not or_reduce(count)='1') then
                count <= (others => '1');
            elsif restart = '1' or (and_reduce(count)='0') then
                count(Nbits - 1) <= '0';
                count(Nbits - 2 downto 0) <= count_reg(Nbits - 1 downto 1);
            end if; 
            
        end if;   
        
    end process p;

        
 end counter_arch;