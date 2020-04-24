library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
    GENERIC ( i_width : integer := 16);
    port(
        A,B: in STD_LOGIC_VECTOR (i_width-1 DOWNTO 0);
	op : in std_logic;
        result: out STD_LOGIC_VECTOR (i_width-1 DOWNTO 0);
	overflow: out std_logic
        );
  end adder;

architecture ripple_adder of adder is

    component ripple is
	GENERIC ( n : integer := 4);
	port(
		A: in std_logic_vector(n-1 downto 0);
		B: in std_logic_vector(n-1 downto 0);
		sum: out std_logic_vector(n-1 downto 0);
		cout: out std_logic
	);
    end component;

    signal temp_out : std_logic;
    signal output  : STD_LOGIC_VECTOR(i_width-1 downto 0) := (others => '0');
    signal tows_comp  : STD_LOGIC_VECTOR(i_width-1 downto 0);
    signal second_input  : STD_LOGIC_VECTOR(i_width-1 downto 0);
    signal one  : STD_LOGIC_VECTOR(i_width-1 downto 0) := (others => '0');
    signal ones_comp: std_logic_vector(i_width-1 downto 0);
begin
    one(0) <= '1';
    ones_comp <= not B;
    result <=  output;
    a0 : ripple generic map(i_width) port map (ones_comp, one, tows_comp, temp_out);

    second_input <= tows_comp when (op = '1') else B; 

    a1 : ripple generic map(i_width) port map (A, second_input, output, temp_out);
    
    
    overflow <= '1' when (A(i_width-1) = B(i_width-1)) and (not A(i_width-1) = output(i_width-1)) else '0';
    



end ripple_adder; 




architecture carry_select_adder of adder is

    component carry_select is
	generic (n : integer := 16);
	port(
		A: in std_logic_vector(n-1 downto 0);
		B: in std_logic_vector(n-1 downto 0);
		sum: out std_logic_vector(n-1 downto 0);
		cout: out std_logic
	);
    end component;

    signal temp_out : std_logic;
    signal output  : STD_LOGIC_VECTOR(i_width-1 downto 0) := (others => '0');
    signal tows_comp  : STD_LOGIC_VECTOR(i_width-1 downto 0);
    signal second_input  : STD_LOGIC_VECTOR(i_width-1 downto 0);
    signal one  : STD_LOGIC_VECTOR(i_width-1 downto 0) := (others => '0');
    signal ones_comp: std_logic_vector(i_width-1 downto 0);
begin
    one(0) <= '1';
    ones_comp <= not B;
    result <=  output;
    a0 : carry_select generic map(i_width) port map (ones_comp, one, tows_comp, temp_out);

    second_input <= tows_comp when (op = '1') else B; 

    a1 : carry_select generic map(i_width) port map (A, second_input, output, temp_out);
    
    
    overflow <= '1' when (A(i_width-1) = B(i_width-1)) and (not A(i_width-1) = output(i_width-1)) else '0';
    



end carry_select_adder; 





architecture carry_look_adder of adder is


    component carry_look is
	generic (n : integer := 16);
	port(
		A: in std_logic_vector(n-1 downto 0);
		B: in std_logic_vector(n-1 downto 0);
		sum: out std_logic_vector(n-1 downto 0);
		cout: out std_logic
	);
    end component;

    signal temp_out : std_logic;
    signal output  : STD_LOGIC_VECTOR(i_width-1 downto 0) := (others => '0');
    signal tows_comp  : STD_LOGIC_VECTOR(i_width-1 downto 0);
    signal second_input  : STD_LOGIC_VECTOR(i_width-1 downto 0);
    signal one  : STD_LOGIC_VECTOR(i_width-1 downto 0) := (others => '0');
    signal ones_comp: std_logic_vector(i_width-1 downto 0);
begin
    one(0) <= '1';
    ones_comp <= not B;
    result <=  output;
    a0 : carry_look generic map(i_width) port map (ones_comp, one, tows_comp, temp_out);

    second_input <= tows_comp when (op = '1') else B; 

    a1 : carry_look generic map(i_width) port map (A, second_input, output, temp_out);
    
    
    overflow <= '1' when (A(i_width-1) = B(i_width-1)) and (not A(i_width-1) = output(i_width-1)) else '0';
    



end carry_look_adder; 