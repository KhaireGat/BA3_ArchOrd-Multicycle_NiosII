library ieee;
use ieee.std_logic_1164.all;

entity multiplexer is
    port(
        i0  : in  std_logic_vector(31 downto 0);
        i1  : in  std_logic_vector(31 downto 0);
        i2  : in  std_logic_vector(31 downto 0);
        i3  : in  std_logic_vector(31 downto 0);
        sel : in  std_logic_vector(1 downto 0);
        o   : out std_logic_vector(31 downto 0)
    );
end multiplexer;

architecture synth of multiplexer is
constant all_zeros: std_logic_vector(31 downto 0):= (others=>'0');
begin
with sel select
	o<= i3 when "11",
		i2 when "10",
		i1 when "01",
		i0 when "00",
		(others=>'0') when others;
end synth;
