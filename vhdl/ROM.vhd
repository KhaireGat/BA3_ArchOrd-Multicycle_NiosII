library ieee;
use ieee.std_logic_1164.all;

entity ROM is
    port(
        clk     : in  std_logic;
        cs      : in  std_logic;
        read    : in  std_logic;
        address : in  std_logic_vector(9 downto 0);
        rddata  : out std_logic_vector(31 downto 0)
    );
end ROM;

architecture synth of ROM is
component ROM_Block
PORT
	(
		address		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END component;
signal s_rddata:std_logic_vector(31 downto 0);
signal s_enable:std_logic:='0';
begin

rddata<=s_rddata when s_enable='1' else (others=>'Z');

rom_b :ROM_Block port map
		(address=>address,
			clock => clk,
			q=>s_rddata);
			
buffer_signal:process(clk)

begin
	if(rising_edge(clk)) then
		s_enable<=cs and read;
	end if;
end process;

end synth;
