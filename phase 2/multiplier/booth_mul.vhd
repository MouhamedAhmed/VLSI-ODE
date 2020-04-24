LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_signed.ALL;

ENTITY booth_mul IS
generic( Nbits : positive := 16 );
   PORT(M     : IN  std_logic_vector(Nbits - 1 DOWNTO 0);
        Q     : IN  std_logic_vector(Nbits - 1 DOWNTO 0);
        start : IN std_logic;
        clk   : IN  std_logic;
        result    : OUT std_logic_vector (2*Nbits-1 DOWNTO 0);
        done    : out std_logic
   );        
END booth_mul;

ARCHITECTURE booth_mul_arch OF booth_mul IS

    component step IS
    generic( Nbits : positive := 16 );
    PORT(   M     : IN  std_logic_vector(Nbits - 1 DOWNTO 0);
            Q     : INOUT  std_logic_vector(Nbits - 1 DOWNTO 0);
            A     : IN  std_logic_vector(Nbits - 1 DOWNTO 0);
            qin  : IN  std_logic;
            Q_out    : OUT std_logic_vector (Nbits - 1 DOWNTO 0);
            A_out    : OUT std_logic_vector (Nbits - 1 DOWNTO 0);
            qout  : OUT std_logic
    );        
    END component;

    component regi IS
        generic( Nbits : positive := 16 );
        PORT(
            d   : IN STD_LOGIC_VECTOR(Nbits-1 DOWNTO 0);
            ld  : IN STD_LOGIC; -- load/enable.
            clr : IN STD_LOGIC; -- async. clear.
            clk : IN STD_LOGIC; -- clock.
            q   : OUT STD_LOGIC_VECTOR(Nbits-1 DOWNTO 0) -- output
        );
    END component;

    component counter is
        generic( Nbits : positive := 16 );
        port 
        ( 
            restart : in std_logic;
            clk : in std_logic;
            done : out std_logic
        );
    end component;

    SIGNAL A : std_logic_vector(Nbits - 1 DOWNTO 0) := (others => '0');
    
    signal step_in_A : std_logic_vector(Nbits - 1 downto 0);
    signal step_in_Q : std_logic_vector(Nbits - 1 downto 0);
    signal step_in_q0 : std_logic_vector(0 downto 0);
    signal step_out_A : std_logic_vector(Nbits - 1 downto 0);
    signal step_out_Q : std_logic_vector(Nbits - 1 downto 0);
    signal step_out_q0 : std_logic_vector(0 downto 0);
    signal ll : std_logic_vector(1 downto 0) := (others => '1');
    signal l : std_logic;

    signal reg2_in_A : std_logic_vector(Nbits - 1 downto 0);
    signal reg2_in_Q : std_logic_vector(Nbits - 1 downto 0);
    signal reg2_in_q0 : std_logic_vector(0 downto 0);
    signal reg2_out_A : std_logic_vector(Nbits - 1 downto 0);
    signal reg2_out_Q : std_logic_vector(Nbits - 1 downto 0);
    signal reg2_out_q0 : std_logic_vector(0 downto 0);

    signal clk_sig : std_logic;
    signal done_sig : std_logic_vector(0 downto 0);
    signal done_sig_delayed : std_logic_vector(0 downto 0);

    signal result_sig : std_logic_vector(2*Nbits-1 downto 0) := (others => '0');

BEGIN
    l <= ll(0) nor ll(1);
    clk_sig <= not clk;
    -- Q_start <= Q;
    step_in_Q <= reg2_out_Q when (ll = "00") else Q;
    step_in_A <= reg2_out_A when (ll = "00") else A;
    step_in_q0 <= reg2_out_q0 when (ll = "00") else (others => '0');

    u : step generic map(Nbits) port map (M,step_in_Q,step_in_A,step_in_q0(0),step_out_Q,step_out_A,step_out_q0(0));

    reg1_A : regi generic map (Nbits) port map (step_out_A,'1','0',clk,reg2_in_A);
    reg1_Q : regi generic map (Nbits) port map (step_out_Q,'1','0',clk,reg2_in_Q);
    reg1_q0 : regi generic map (1) port map (step_out_q0,'1','0',clk,reg2_in_q0);

    reg2_A : regi generic map (Nbits) port map (reg2_in_A,'1','0',clk_sig,reg2_out_A);
    reg2_Q : regi generic map (Nbits) port map (reg2_in_Q,'1','0',clk_sig,reg2_out_Q);
    reg2_q0 : regi generic map (1) port map (reg2_in_q0,'1','0',clk_sig,reg2_out_q0);

    reg_done : regi generic map (1) port map (done_sig,'1','0',clk,done_sig_delayed);

    count : counter generic map (Nbits) port map (start,clk,done_sig(0));

    result_sig <= reg2_in_A & reg2_in_Q when done_sig(0) = '1' and done_sig_delayed(0) = '0';

    done <= done_sig(0);
    result <= result_sig;






    p : process (clk,clk_sig)
    begin
        if rising_edge(clk_sig) then
            if done_sig(0) = '1' then
                ll <= "11";
            elsif ll = "11" and start = '1' then
                ll <= "10";
            elsif ll = "10" then
                ll <= "00";
            end if;
        end if;  
        if rising_edge(clk) then
            if rising_edge(done_sig_delayed(0)) then
                ll <= "11"; 
            end if;

        end if;
    end process p;

END booth_mul_arch;