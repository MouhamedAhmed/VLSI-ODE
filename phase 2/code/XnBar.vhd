LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_signed.ALL;

ENTITY XnBar IS
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
END XnBar;

ARCHITECTURE XnBar_arch OF XnBar IS


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

component accumulator IS
    generic( Nbits : positive := 16 );
    PORT(
        in1   : IN std_logic_vector(Nbits-1 DOWNTO 0);
        in2   : IN std_logic_vector(Nbits-1 DOWNTO 0);
        enable  : IN std_logic; -- load/enable.
        clr : IN std_logic; -- async. clear.
        clk : IN std_logic; -- clock.
        sum   : OUT std_logic_vector(Nbits-1 DOWNTO 0) -- output
    );
END component;

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

signal input : std_logic_vector(0 downto 0);
signal output : std_logic_vector(0 downto 0) := (others => '0');

signal one : std_logic_vector(0 downto 0) := (others => '1');

signal start_mul : std_logic := '0';
signal AX : std_logic_vector(15 downto 0);
signal BU : std_logic_vector(15 downto 0);
signal AX_overflow : std_logic := '0';
signal BU_overflow : std_logic := '0';
signal AX_done : std_logic := '0';
signal BU_done : std_logic := '0';


signal M_done : std_logic_vector(0 downto 0) := (others => '0');
signal N_done : std_logic_vector(0 downto 0) := (others => '0');

signal M_mul_done : std_logic_vector(0 downto 0) := (others => '0');
signal N_mul_done : std_logic_vector(0 downto 0) := (others => '0');

signal ready_to_out : std_logic_vector(0 downto 0) := (others => '0');
signal clr_all : std_logic_vector(0 downto 0) := (others => '1');

signal first_operand_accum : std_logic_vector(15 downto 0) := (others => '0');
signal second_operand_accum : std_logic_vector(15 downto 0) := (others => '0');
signal accumulator_result : std_logic_vector(15 downto 0) := (others => '0');
signal acc_done : std_logic_vector(0 downto 0) := (others => '0');
signal acc_done_delayed : std_logic_vector(0 downto 0) := (others => '0');

signal ld_reg_mul_M_done : std_logic;
signal ld_reg_mul_N_done : std_logic;

begin

    accumulator_r <= accumulator_result;
    fir <= first_operand_accum;
    sec <= second_operand_accum;
    start_mul <= data_loaded when (output(0) = '1') else '0';
    A_times_X: entity work.multiplier(booth_multiplier_arch) generic map (16) port map (A,X,start_mul,clk,AX,AX_overflow,AX_done);
    B_times_U: entity work.multiplier(booth_multiplier_arch) generic map (16) port map (B,U,start_mul,clk,BU,BU_overflow,BU_done);


    -- accumulator
    first_operand_accum <= AX when (AX_done = '1') else (others => '0');
    second_operand_accum <= BU when (BU_done = '1') else (others => '0');
    accumulate : accumulator generic map (16) port map (first_operand_accum,second_operand_accum,'1',clr_all(0),clk,accumulator_result);
    acc_done(0) <= '1' when (AX_done = '1') or (BU_done = '1') else '0';
    accDone : regi generic map (1) port map (acc_done,'1','0',clk,acc_done_delayed);



    -- check if element is done and out it
    reg_row_M_done : regi generic map (1) port map (one,M,clr_all(0),clk,M_done);
    reg_row_N_done : regi generic map (1) port map (one,N,clr_all(0),clk,N_done);
    ld_reg_mul_M_done <= M_done(0) and BU_done;
    ld_reg_mul_N_done <= N_done(0) and AX_done;
    
    reg_mul_M_done : regi generic map (1) port map (one,ld_reg_mul_M_done,clr_all(0),clk,M_mul_done);
    reg_mul_N_done : regi generic map (1) port map (one,ld_reg_mul_N_done,clr_all(0),clk,N_mul_done);
    ready_to_out(0) <= M_mul_done(0) and N_mul_done(0) and X_plus_one_ready_to_receive;
    X_plus_one <= accumulator_result when (ready_to_out(0) = '1') else (others => '0');
    data_ready <= ready_to_out(0);

    -- clear all
    reg_clr : regi generic map (1) port map (ready_to_out,'1','0',clk,clr_all);
    ready_to_receive <= acc_done_delayed(0) and (not AX_done) and (not BU_done) when (output(0) = '1') else '1';
    input(0) <= '1' when output(0) = '0';
    reg_enable : regi generic map (1) port map (input,'1','0',clk,output);





end XnBar_arch;
