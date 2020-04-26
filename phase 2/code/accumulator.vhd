LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_signed.ALL;

ENTITY accumulator IS
generic( Nbits : positive := 16 );
PORT(
    in1   : IN std_logic_vector(Nbits-1 DOWNTO 0);
    in2   : IN std_logic_vector(Nbits-1 DOWNTO 0);
    enable  : IN std_logic; -- load/enable.
    clr : IN std_logic; -- async. clear.
    clk : IN std_logic; -- clock.
    sum   : OUT std_logic_vector(Nbits-1 DOWNTO 0) -- output
);
END accumulator;

ARCHITECTURE accumulator_arch OF accumulator IS
component adder is
    GENERIC ( i_width : integer := 16);
    port(
        A,B: in STD_LOGIC_VECTOR (i_width-1 DOWNTO 0);
        op : in std_logic;
        result: out STD_LOGIC_VECTOR (i_width-1 DOWNTO 0);
        overflow: out std_logic
        );
end component;

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

signal inputs_sum : std_logic_vector(Nbits-1 downto 0);
signal overf1 : std_logic;
signal overf2 : std_logic;
signal sum_sig: std_logic_vector(Nbits-1 downto 0) := (others => '0');
signal sum_sig_delayed: std_logic_vector(Nbits-1 downto 0);
signal inputs_sum_delayed: std_logic_vector(Nbits-1 downto 0);

BEGIN

add: entity work.adder(ripple_adder) generic map (Nbits) port map (in1,in2,'0',inputs_sum,overf1);
add2: entity work.adder(ripple_adder) generic map (Nbits) port map (inputs_sum_delayed,sum_sig,'0',sum_sig_delayed,overf2);
reg : regi generic map (16) port map (inputs_sum,enable,clr,clk,inputs_sum_delayed);
reg2 : regi generic map (16) port map (sum_sig_delayed,enable,clr,clk,sum_sig);
sum <= sum_sig_delayed;

    -- process(clk, clr)
    -- -- variable sum_sig: std_logic_vector(Nbits-1 downto 0) := (others => '0');

    -- begin
    --     if clr = '1' then
    --         sum_sig <= (others => '0');
    --     elsif rising_edge(clk) then
    --         sum <= sum_sig_delayed;
    --     end if;
    -- end process;
END accumulator_arch;