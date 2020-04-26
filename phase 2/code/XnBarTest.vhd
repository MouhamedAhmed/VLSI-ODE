Library ieee;
use ieee.std_logic_1164.all;
use STD.textio.all;
use ieee.std_logic_textio.all;
USE IEEE.numeric_std.all;

entity XnBarTest is
    end entity;

Architecture XnBarTest_arch of XnBarTest is
    constant CLK_PERIOD : time := 100 ps;
    Signal s_clk : std_logic := '1';
    type arr is array (natural range <>) of std_logic_vector(15 downto 0); 
    signal X_vec : arr(0 to 10);
    signal A_vec : arr(0 to 10);
    signal B_vec : arr(0 to 10);
    signal U_vec : arr(0 to 10);
    signal res : std_logic_vector(15 downto 0) := (others => '0');

    signal A   :  std_logic_vector(15 DOWNTO 0) := (others => '0');
    signal X   :  std_logic_vector(15 DOWNTO 0) := (others => '0');
    signal B   :  std_logic_vector(15 DOWNTO 0) := (others => '0');
    signal U   :  std_logic_vector(15 DOWNTO 0) := (others => '0');
    signal M :  std_logic := '0';
    signal N :  std_logic := '0';
    signal ready_to_receive :  std_logic := '1';
    signal data_loaded :  std_logic := '0';
    signal data_ready :  std_logic;
    signal X_plus_one :  std_logic_vector(15 downto 0);
    signal ready_to_receive_bef :  std_logic_vector(0 downto 0);
    signal ready_to_receive_delayed :  std_logic_vector(0 downto 0) := (others => '0');

    

    component XnBar IS
        PORT(
            A   : IN std_logic_vector(15 DOWNTO 0);
            X   : IN std_logic_vector(15 DOWNTO 0);
            B   : IN std_logic_vector(15 DOWNTO 0);
            U   : IN std_logic_vector(15 DOWNTO 0);
            clk : IN std_logic;
            M : IN std_logic;
            N : IN std_logic;
            ready_to_receive : OUT std_logic;
            data_loaded : IN std_logic;
            data_ready : OUT std_logic;
            X_plus_one_ready_to_receive : IN std_logic;
            X_plus_one : OUT std_logic_vector(15 downto 0);
            accumulator_r : OUT std_logic_vector(15 DOWNTO 0);
            fir : OUT std_logic_vector(15 DOWNTO 0);
            sec : OUT std_logic_vector(15 DOWNTO 0)

            );
    END component;

    signal M_count : std_logic_vector(7 downto 0);
    signal N_count : std_logic_vector(7 downto 0);
    signal acc : std_logic_vector(15 downto 0);
    signal fir : std_logic_vector(15 downto 0);
    signal sec : std_logic_vector(15 downto 0);
    

    signal st : std_logic := '0'; 

    signal idx_AX : std_logic_vector(6 downto 0) := "0000000";
    signal idx_BU : std_logic_vector(6 downto 0) := "0000000";

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



begin
    ready_to_receive_bef(0) <= ready_to_receive;

    XnB : XnBar port map (A,X,B,U,s_clk,M,N,ready_to_receive,data_loaded,data_ready,'1',X_plus_one,acc,fir,sec);
    reg_dec : regi generic map (1) port map (ready_to_receive_bef,'1','0',s_clk,ready_to_receive_delayed);

process 
    begin
        wait for CLK_PERIOD/2;
        s_clk <= not s_clk;
end process;

MNprocess : process (s_clk)

    file MN_file : text open read_mode is "D:\cmp third year\2nd semester\VLSI\project\phase 2\MN.txt";
    variable text_line1 : line;
    -- variable text_line2 : line;
    variable mm : std_logic_vector(7 downto 0);
    variable nn : std_logic_vector(7 downto 0);
    -- variable st : std_logic := '0';
    variable char : character;
    variable m_c : std_logic_vector(7 downto 0); 
    variable n_c : std_logic_vector(7 downto 0);
    variable M_var : std_logic := '0'; 
    variable N_var : std_logic := '0'; 
 

begin
    if st = '0' then
        readline(MN_file, text_line1);
        read(text_line1, mm);
        M_count <= std_logic_vector( unsigned(mm)  );
        read(text_line1, char);
        read(text_line1, nn);
        N_count <=  std_logic_vector( unsigned(nn)  );
        st <= '1';
    end if;

    if rising_edge(s_clk) then

        if data_loaded = '1' and ready_to_receive_delayed(0) = '1' then
            if (not (M_count = "00000000")) then
                m_c := M_count;
                M_count <= std_logic_vector( unsigned(m_c) - 1 );
                M <= '0';
            else
                M <= '1';
            end if;
       
            if (not (N_count = "00000000")) then
                n_c := N_count;
                N_count <= std_logic_vector( unsigned(n_c) - 1 );
                N <= '0';
            else
                N <= '1';
            end if;
        end if;

    end if;

end process;



vectorsLoad : process 

    variable char : character;

    file X_file : text open read_mode is "D:\cmp third year\2nd semester\VLSI\project\phase 2\X.txt";
    variable text_X_line : line;

    file A_file : text open read_mode is "D:\cmp third year\2nd semester\VLSI\project\phase 2\A.txt";
    variable text_A_line : line;

    file B_file : text open read_mode is "D:\cmp third year\2nd semester\VLSI\project\phase 2\B.txt";
    variable text_B_line : line;

    file U_file : text open read_mode is "D:\cmp third year\2nd semester\VLSI\project\phase 2\U.txt";
    variable text_U_line : line;

    file res_file : text open read_mode is "D:\cmp third year\2nd semester\VLSI\project\phase 2\result.txt";
    variable text_res_line : line;

    variable m_c : std_logic_vector (7 downto 0);
    variable n_c : std_logic_vector (7 downto 0);

    variable X_var : std_logic_vector (15 downto 0);
    variable A_var : std_logic_vector (15 downto 0);
    variable B_var : std_logic_vector (15 downto 0);
    variable U_var : std_logic_vector (15 downto 0);
    variable res_var : std_logic_vector (15 downto 0);


begin
    
    
    m_c := "00000000";
    n_c := "00000000";

    while not endfile(A_file) loop
        readline(X_file, text_X_line);
        readline(A_file, text_A_line);

        read(text_X_line, X_var);
        X_vec(to_integer(unsigned(m_c))) <= X_var;
        -- read(text_X_line, char);

        read(text_A_line, A_var);
        A_vec(to_integer(unsigned(m_c))) <= A_var;

        -- read(text_A_line, char);

        m_c := std_logic_vector( unsigned(m_c) + 1 );
    end loop;

    while not endfile(B_file) loop
        readline(B_file, text_B_line);
        readline(U_file, text_U_line);

        read(text_B_line, B_var);
        B_vec(to_integer(unsigned(n_c))) <= B_var;
        -- read(text_B_line, char);

        read(text_U_line, U_var);
        U_vec(to_integer(unsigned(n_c))) <= U_var;
        -- read(text_U_line, char);

        n_c := std_logic_vector( unsigned(n_c) + 1 );
    end loop;

    readline(res_file, text_res_line);
    read(text_res_line, res_var);
    res <= res_var;


    wait;

end process;

genOutput : process (s_clk)
begin
    if rising_edge(s_clk) then
        if (ready_to_receive = '1' and (M = '0' or N = '0'))then
            
            data_loaded <= '1';
            if M = '0' then
                idx_BU <= std_logic_vector( unsigned(idx_BU) + 1 );
                B <= B_vec(to_integer(unsigned(idx_BU)));
                U <= U_vec(to_integer(unsigned(idx_BU)));
            else
                B <= (others => '0');
                U <= (others => '0');
            end if;

            if N = '0' then
                idx_AX <= std_logic_vector( unsigned(idx_AX) + 1 );
                A <= A_vec(to_integer(unsigned(idx_AX)));
                X <= X_vec(to_integer(unsigned(idx_AX)));
            else
                A <= (others => '0');
                X <= (others => '0');
            end if;
        else
            data_loaded <= '0';
            -- if N = '1'  then
            --     A <= (others => '0');
            --     X <= (others => '0');
            -- end if;
            -- if M = '1'  then
            --     B <= (others => '0');
            --     U <= (others => '0');
            -- end if;
            
        end if;
    end if;
end process;

test : process (s_clk,data_ready) 
begin
    if falling_edge(s_clk) and data_ready = '1'  then
        assert ((res=X_plus_one)) report "XnBar failed"  severity error;
    end if;
end process;



end XnBarTest_arch;