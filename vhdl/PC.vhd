library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
    port(
        clk     : in  std_logic;
        reset_n : in  std_logic;
        en      : in  std_logic;
        sel_a   : in  std_logic;
        sel_imm : in  std_logic;
        add_imm : in  std_logic;
        imm     : in  std_logic_vector(15 downto 0);
        a       : in  std_logic_vector(15 downto 0);
        addr    : out std_logic_vector(31 downto 0)
    );
end PC;

architecture synth of PC is
    signal s_addr: std_logic_vector(31 downto 0);
begin
    
    addr<=s_addr;

    process(reset_n,clk)
    begin
        if reset_n='0' then
            s_addr<=(others => '0');
        elsif rising_edge(clk) then
            if en='1' then
                s_addr(15 downto 0)<= std_logic_vector(unsigned(s_addr(15 downto 0))+to_unsigned(4, 16)); 

            end if;
        end if;
    end process;

end synth;
