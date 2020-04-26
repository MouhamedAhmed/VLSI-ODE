library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity binary_mul is
generic(Nbits : integer := 16);
    port(
      A,B: in STD_LOGIC_VECTOR (Nbits-1 DOWNTO 0);
	start : IN std_logic;
        clk:in STD_LOGIC;
         result: out STD_LOGIC_VECTOR ((2*Nbits)-1 DOWNTO 0);
        done    : out std_logic
      );
  end binary_mul;

architecture binary_mul_arch of binary_mul is
signal zeros : std_logic_vector((2*Nbits)-1 downto 0) := (others => '0');

signal p1 : STD_LOGIC_VECTOR((2*Nbits)-1 downto 0) :=(others => '0');
signal p2 : STD_LOGIC_VECTOR((2*Nbits)-1 downto 0) :=(others => '0');
signal p3 : STD_LOGIC_VECTOR((2*Nbits)-1 downto 0) :=(others => '0');
signal p4 : STD_LOGIC_VECTOR((2*Nbits)-1 downto 0) :=(others => '0');
signal p5 : STD_LOGIC_VECTOR((2*Nbits)-1 downto 0) :=(others => '0');
signal p6 : STD_LOGIC_VECTOR((2*Nbits)-1 downto 0) :=(others => '0');
signal p7 : STD_LOGIC_VECTOR((2*Nbits)-1 downto 0) :=(others => '0');
signal p8 : STD_LOGIC_VECTOR((2*Nbits)-1 downto 0) :=(others => '0');
signal p9 : STD_LOGIC_VECTOR((2*Nbits)-1 downto 0) :=(others => '0');
signal p10 : STD_LOGIC_VECTOR((2*Nbits)-1 downto 0) :=(others => '0');
signal p11 : STD_LOGIC_VECTOR((2*Nbits)-1 downto 0) :=(others => '0');
signal p12 : STD_LOGIC_VECTOR((2*Nbits)-1 downto 0) :=(others => '0');
signal p13 : STD_LOGIC_VECTOR((2*Nbits)-1 downto 0) :=(others => '0');
signal p14 : STD_LOGIC_VECTOR((2*Nbits)-1 downto 0) :=(others => '0');
signal p15 : STD_LOGIC_VECTOR((2*Nbits)-1 downto 0) :=(others => '0');
signal p16 : STD_LOGIC_VECTOR((2*Nbits)-1 downto 0) :=(others => '0');
signal p16_2s:STD_LOGIC_VECTOR((2*Nbits) downto 0) :=(others => '0');


begin

	--calc. partial products
	p1 <= STD_LOGIC_VECTOR(resize(signed(A), p1'length)) when B(0) = '1' and start = '1' else zeros;
	p2 <= STD_LOGIC_VECTOR(shift_left(resize(signed(A), p1'length), 1)) when B(1) = '1' and start = '1' else zeros;
	p3 <= STD_LOGIC_VECTOR(shift_left(resize(signed(A), p1'length), 2)) when B(2) = '1' and start = '1' else zeros;
	p4 <= STD_LOGIC_VECTOR(shift_left(resize(signed(A), p1'length), 3)) when B(3) = '1' and start = '1' else zeros;
	p5 <= STD_LOGIC_VECTOR(shift_left(resize(signed(A), p1'length), 4)) when B(4) = '1' and start = '1' else zeros;
	p6 <= STD_LOGIC_VECTOR(shift_left(resize(signed(A), p1'length), 5)) when B(5) = '1' and start = '1' else zeros;
	p7 <= STD_LOGIC_VECTOR(shift_left(resize(signed(A), p1'length), 6)) when B(6) = '1' and start = '1' else zeros;
	p8 <= STD_LOGIC_VECTOR(shift_left(resize(signed(A), p1'length), 7)) when B(7) = '1' and start = '1' else zeros;
	p9 <= STD_LOGIC_VECTOR(shift_left(resize(signed(A), p1'length), 8)) when B(8) = '1' and start = '1' else zeros;
	p10 <= STD_LOGIC_VECTOR(shift_left(resize(signed(A), p1'length), 9)) when B(9) = '1' and start = '1' else zeros;
	p11 <= STD_LOGIC_VECTOR(shift_left(resize(signed(A), p1'length), 10)) when B(10) = '1' and start = '1' else zeros;
	p12 <= STD_LOGIC_VECTOR(shift_left(resize(signed(A), p1'length), 11)) when B(11) = '1' and start = '1' else zeros;
	p13 <= STD_LOGIC_VECTOR(shift_left(resize(signed(A), p1'length), 12)) when B(12) = '1' and start = '1' else zeros;
	p14 <= STD_LOGIC_VECTOR(shift_left(resize(signed(A), p1'length), 13)) when B(13) = '1' and start = '1' else zeros;
	p15 <= STD_LOGIC_VECTOR(shift_left(resize(signed(A), p1'length), 14)) when B(14) = '1' and start = '1' else zeros;
	p16<= STD_LOGIC_VECTOR(shift_left(resize(signed(not(A))+1,p1'length),15))when B(15) = '1' and start = '1' else zeros;
	--p16 <= STD_LOGIC_VECTOR(shift_left(resize(signed(A), p1'length), 15)) when B(15) = '1' and start = '1' else zeros;
	result <= STD_LOGIC_VECTOR(signed(p1)+signed(p2)+signed(p3)+signed(p4)+signed(p5)+signed(p6)+signed(p7)+signed(p8)+signed(p9)+signed(p10)+signed(p11)+signed(p12)+signed(p13)+signed(p14)+signed(p15)+signed(p16));
	done <= start;

end binary_mul_arch; 

