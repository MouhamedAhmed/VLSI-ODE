LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_signed.ALL;

ENTITY step IS
    generic( Nbits : positive := 16 );
   PORT(M     : IN  std_logic_vector(Nbits - 1 DOWNTO 0);
        Q     : IN  std_logic_vector(Nbits - 1 DOWNTO 0);
        A     : IN  std_logic_vector(Nbits - 1 DOWNTO 0);
        qin  : IN  std_logic;
        Q_out    : OUT std_logic_vector (Nbits - 1 DOWNTO 0);
        A_out    : OUT std_logic_vector (Nbits - 1 DOWNTO 0);
        qout  : OUT std_logic
   );        
END step;

ARCHITECTURE arch OF step IS

    component adder is
        GENERIC ( i_width : integer := 16);
        port(
            A,B: in STD_LOGIC_VECTOR (i_width-1 DOWNTO 0);
            op : in std_logic;
            result: out STD_LOGIC_VECTOR (i_width-1 DOWNTO 0);
            overflow: out std_logic
            );
    end component;


    signal same : std_logic;
    signal op : std_logic;
    signal resultAdd : std_logic_vector (Nbits - 1 downto 0);
    signal overflow : std_logic;
    signal Aback : std_logic_vector(Nbits - 1 downto 0);

BEGIN
    same <= qin xnor Q(0);
    op <= Q(0);
    add: entity work.adder(carry_look_adder) generic map (16) port map (A,M,op,resultAdd,overflow);
    Aback <= A when (same = '1') else resultAdd;
    qout <= Q(0);
    Q_out <= Aback(0) & Q(Nbits - 1 downto 1);
    A_out <= Aback(Nbits - 1) & Aback(Nbits - 1 downto 1);
END arch;