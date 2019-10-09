library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file is
    port(
        clk    : in  std_logic;
        aa     : in  std_logic_vector(4 downto 0);
        ab     : in  std_logic_vector(4 downto 0);
        aw     : in  std_logic_vector(4 downto 0);
        wren   : in  std_logic;
        wrdata : in  std_logic_vector(31 downto 0);
        a      : out std_logic_vector(31 downto 0);
        b      : out std_logic_vector(31 downto 0)
    );
end register_file;

architecture synth of register_file is
	type reg_type is array(0 to 31) of std_logic_vector(31 downto 0);
	signal reg: reg_type;
	signal s_aa,s_ab,s_aw: integer:=0;
begin
	--convert the adresses to integers
	s_aa<=to_integer(unsigned(aa));
	s_ab<=to_integer(unsigned(ab));
	s_aw<=to_integer(unsigned(aw));

	--read: process(s_aa,s_ab)
	--begin
		a<=reg(s_aa);
		b<=reg(s_ab);
	--end process;

	write:process(clk)
	begin
		if(rising_edge(clk)) then
			if wren='1' then
				reg(s_aw)<=wrdata;
			end if;
		end if;
		reg(0)<=(others=>'0');
	end process;
end synth;
