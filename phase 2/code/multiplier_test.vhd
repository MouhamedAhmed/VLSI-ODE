Library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tbMachineMultiplier is
    end entity;

Architecture mytest of tbMachineMultiplier is


    type arr is array (natural range <>) of std_logic_vector(15 downto 0); 
    type arr_bit is array (natural range <>) of std_logic; 
    signal inputs_1 : arr(0 to 10);
    signal inputs_2 : arr(0 to 10);
    signal outputs : arr(0 to 10);
    signal overflows : arr_bit(0 to 10);

    -- integer mul
    signal input1_1 : std_logic_vector(15 downto 0) := "0000011100000000"; -- 7
    signal input1_2 : std_logic_vector(15 downto 0) := "0000001100000000"; -- 3
    signal output1 : std_logic_vector(15 downto 0) := "0001010100000000"; -- 21
    signal overflow1 : std_logic := '0';

    -- fraction mul
    signal input2_1 : std_logic_vector(15 downto 0) := "0000000010000000"; -- 0.5
    signal input2_2 : std_logic_vector(15 downto 0) := "0000000010000000"; -- 0.5
    signal output2 : std_logic_vector(15 downto 0) := "0000000001000000"; -- 0.25
    signal overflow2 : std_logic := '0';



    -- signed mul (+ive * -ive)
    signal input3_1 : std_logic_vector(15 downto 0) := "1111111110000000"; -- -0.5
    signal input3_2 : std_logic_vector(15 downto 0) := "0000000010000000"; -- +0.5
    signal output3 : std_logic_vector(15 downto 0) := "1111111111000000"; -- -0.25
    signal overflow3 : std_logic := '0';


    -- overflow
    signal input4_1 : std_logic_vector(15 downto 0) := "0010000000000000"; -- 32
    signal input4_2 : std_logic_vector(15 downto 0) := "0010000000000000"; -- 32
    signal output4 : std_logic_vector(15 downto 0) := "0000000000000000"; -- 0
    signal overflow4 : std_logic := '1';

    -- signed mul (-ive * -ive)
    signal input5_1 : std_logic_vector(15 downto 0) := "1111111110000000"; -- -0.5
    signal input5_2 : std_logic_vector(15 downto 0) := "1111111110000000"; -- -0.5
    signal output5 : std_logic_vector(15 downto 0) := "0000000001000000"; -- 0.25
    signal overflow5 : std_logic := '0';

    -- integer * fraction (signed)
    signal input6_1 : std_logic_vector(15 downto 0) := "1111100100000000"; -- -7
    signal input6_2 : std_logic_vector(15 downto 0) := "0000000001000000"; -- 0.25
    signal output6 : std_logic_vector(15 downto 0) := "1111111001000000"; -- -1.75    
    signal overflow6 : std_logic := '0';



    


    Signal s_clk : std_logic := '1';
    Signal s_a_input_booth : std_logic_vector(15 downto 0) := "0000011100000000";
    Signal s_b_input_booth : std_logic_vector(15 downto 0) := "0000001100000000";
    Signal s_a_input_binary : std_logic_vector(15 downto 0) := "0000011100000000";
    Signal s_b_input_binary : std_logic_vector(15 downto 0) := "0000001100000000";
    Signal s_output_booth: std_logic_vector(15 downto 0);
    Signal s_output_binary: std_logic_vector(15 downto 0);
    constant CLK_PERIOD : time := 100 ps;

    signal start_booth : std_logic := '1';
    signal start_binary : std_logic := '1';
    signal overflow_booth : std_logic;
    signal done_booth : std_logic;
    signal overflow_binary : std_logic;
    signal done_binary : std_logic;


    signal idx_booth : std_logic_vector(6 downto 0) := "0000000";
    signal idx_binary : std_logic_vector(6 downto 0) := "0000000";

    
    component multiplier IS
    PORT(A     : IN  std_logic_vector(15 DOWNTO 0);
        B     : IN  std_logic_vector(15 DOWNTO 0);
        start : IN std_logic;
        clk   : IN  std_logic;
        result    : OUT std_logic_vector (15 DOWNTO 0);
        overflow   : out std_logic;
        done    : out std_logic
    );        
    END component;


    begin
        -- init test cases
        inputs_1(0) <= input1_1;
        inputs_1(1) <= input2_1;
        inputs_1(2) <= input3_1;
        inputs_1(3) <= input4_1;
        inputs_1(4) <= input5_1;
        inputs_1(5) <= input6_1;

        inputs_2(0) <= input1_2;
        inputs_2(1) <= input2_2;
        inputs_2(2) <= input3_2;
        inputs_2(3) <= input4_2;
        inputs_2(4) <= input5_2;
        inputs_2(5) <= input6_2;

        outputs(0) <= output1;
        outputs(1) <= output2;
        outputs(2) <= output3;
        outputs(3) <= output4;
        outputs(4) <= output5;
        outputs(5) <= output6;

        overflows(0) <= overflow1;
        overflows(1) <= overflow2;
        overflows(2) <= overflow3;
        overflows(3) <= overflow4;
        overflows(4) <= overflow5;
        overflows(5) <= overflow6;
        


        booth: entity work.multiplier(booth_multiplier_arch) generic map (16) port map (s_a_input_booth,s_b_input_booth,start_booth,s_clk,s_output_booth,overflow_booth,done_booth);
        binary: entity work.multiplier(binary_multiplier_arch) generic map (16) port map (s_a_input_binary,s_b_input_binary,start_binary,s_clk,s_output_binary,overflow_binary,done_binary);

        process 
            begin
                wait for CLK_PERIOD/2;
                s_clk <= not s_clk;
        end process;

        P: process (done_booth)
            begin 
            -- x1:for i in 0 to 2 loop
                -- wait for CLK_PERIOD*16;
                if falling_edge(done_booth) then 
                    assert (s_output_booth=outputs(to_integer(unsigned(idx_booth)))) report "error in booth multiplication in test case: "  & integer'image(to_integer(unsigned(idx_booth))+1)  severity error;
                    assert (overflow_booth=overflows(to_integer(unsigned(idx_booth)))) report "error in booth overflow in test case: "  & integer'image(to_integer(unsigned(idx_booth))+1)  severity error;
                if to_integer(unsigned(idx_booth)) < 5 then
                    s_a_input_booth<=inputs_1(to_integer(unsigned(idx_booth))+1);
                    s_b_input_booth<=inputs_2(to_integer(unsigned(idx_booth))+1);
                    start_booth <= '1';
                    idx_booth <= std_logic_vector( unsigned(idx_booth) + 1 );

                else
                    start_booth <= '0';
                end if;
                end if;


        end process;



        P2: process (s_clk)
            begin 
           
                if falling_edge(s_clk) and done_binary = '1' then 
                    assert (s_output_binary=outputs(to_integer(unsigned(idx_binary)))) report "error in binary multiplication in test case: "  & integer'image(to_integer(unsigned(idx_binary))+1)  severity error;
                    assert (overflow_binary=overflows(to_integer(unsigned(idx_binary)))) report "error in binary overflow in test case: "  & integer'image(to_integer(unsigned(idx_binary))+1)  severity error;
                end if;

                if to_integer(unsigned(idx_binary)) < 5 and rising_edge(s_clk) then
                    s_a_input_binary<=inputs_1(to_integer(unsigned(idx_binary))+1);
                    s_b_input_binary<=inputs_2(to_integer(unsigned(idx_binary))+1);
                    start_binary <= '1';
                    idx_binary <= std_logic_vector( unsigned(idx_binary) + 1 );

                elsif rising_edge(s_clk) then
                    start_binary <= '0';
                end if;


        end process;





    end Architecture;



