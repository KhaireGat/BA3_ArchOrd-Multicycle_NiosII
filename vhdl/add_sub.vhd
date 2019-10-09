library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add_sub is
    port(
        a        : in  std_logic_vector(31 downto 0);
        b        : in  std_logic_vector(31 downto 0);
        sub_mode : in  std_logic;
        carry    : out std_logic;
        zero     : out std_logic;
        r        : out std_logic_vector(31 downto 0)
    );
end add_sub;

architecture synth of add_sub is
	constant all_zeros : std_logic_vector(31 downto 0) := (others => '0');
	--component adder 
	 --   port(
	--	a        : in  std_logic_vector(31 downto 0);
	--	b        : in  std_logic_vector(31 downto 0);
	--	c_in     : in  std_logic;
	--	c_out    : out std_logic;
	--	r        : out std_logic_vector(31 downto 0)
	  --  );
	--end component adder;

	signal s_b,s_r,s_sum: std_logic_vector(32 downto 0);

begin

	s_sum<=all_zeros&sub_mode;
	s_b <= '0'&b when (sub_mode='0') else '0'&(not b);
	--add: adder port map(
	--	a =>a,
	--	b =>s_b,
	--	c_in => sub_mode,
	--	c_out  =>carry,
	--	r    =>s_r);
	s_r<=std_logic_vector(unsigned('0'& a) + unsigned(s_b) + unsigned(s_sum));
	r<=s_r(31 downto 0);
	zero<= '1' when s_r(31 downto 0) = all_zeros else '0';
	carry<=s_r(32);

end synth;
