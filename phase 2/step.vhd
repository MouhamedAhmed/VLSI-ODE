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

    component twoscomplement is
        generic( Nbits : positive := 16 );
        port 
        ( 
            A : in std_logic_vector (Nbits-1 downto 0);
            Y : out std_logic_vector (Nbits-1 downto 0)
        );
    end component;

    component adder IS
    generic( Nbits : positive := 16 );
        PORT(data1 : IN  std_logic_vector(Nbits - 1 DOWNTO 0);
            data2 : IN  std_logic_vector(Nbits - 1 DOWNTO 0);
            result : OUT std_logic_vector (Nbits - 1 DOWNTO 0);
            overflow : OUT std_logic
        );
    END component;

    signal same : std_logic;
    signal op : std_logic;
    signal Mcomp : std_logic_vector (Nbits - 1 downto 0);
    signal Madd : std_logic_vector (Nbits - 1 downto 0);
    signal resultAdd : std_logic_vector (Nbits - 1 downto 0);
    signal overflow : std_logic;
    signal Aback : std_logic_vector(Nbits - 1 downto 0);

BEGIN
    same <= qin xnor Q(0);
    op <= Q(0);
    u0 : twoscomplement generic map (Nbits) port map (M,Mcomp);
    Madd <= M when (op = '0') else Mcomp;
    u1 : adder generic map (Nbits) port map (A,Madd,resultAdd,overflow);
    Aback <= A when (same = '1') else resultAdd;
    qout <= Q(0);
    Q_out <= Aback(0) & Q(Nbits - 1 downto 1);
    A_out <= Aback(Nbits - 1) & Aback(Nbits - 1 downto 1);
END arch;