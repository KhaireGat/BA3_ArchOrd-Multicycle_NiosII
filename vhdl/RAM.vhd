library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAM is
    port(
        clk     : in  std_logic;
        cs      : in  std_logic;
        read    : in  std_logic;
        write   : in  std_logic;
        address : in  std_logic_vector(9 downto 0);
        wrdata  : in  std_logic_vector(31 downto 0);
        rddata  : out std_logic_vector(31 downto 0));
end RAM;

architecture synth of RAM is

	TYPE reg_type is array(0 to 1023) of std_logic_vector(31 downto 0);

	SIGNAL s_read : std_logic_vector(31 downto 0);
	SIGNAL s_address : std_logic_vector(9 downto 0);
	SIGNAL s_enable : std_logic;
	Signal reg:reg_type; --IMPORTANT: creer ce signal autrement reg_type(s_integer_address) devient un cast vers type reg_type

	SIGNAL s_integer_address : integer:=0;


begin

	s_integer_address<=to_integer(unsigned(s_address));

	s_read<=reg(s_integer_address);


	dff : process(clk) is
	begin

		if rising_edge(clk) then
			s_address <= address;
			s_enable <= (read and cs);
		end if;

	end process dff;

	rddata <= s_read when (s_enable = '1') else (others=>'Z');

	--triStateBuffer : process(clk) is
	--begin

	--	if rising_edge(clk) then
	--		if(s_enable = '1') then
	--			rddata <= s_read;
	--		else
	--			rddata <= (others=>'Z');
	--		end if;
	--		--rddata <= s_read when (s_enable = '1') else (others=>'Z');
	--	end if;

	--end process triStateBuffer;



	writeRAM : process(clk) is
	begin

		if rising_edge(clk) then
			if (write = '1' and cs = '1') then
				reg(address) <= wrdata;

			end if;
		end if;

	end process writeRAM;


end synth;
