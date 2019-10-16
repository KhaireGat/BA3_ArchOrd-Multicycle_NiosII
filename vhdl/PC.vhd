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
    signal s_next,s_addr: std_logic_vector(31 downto 0);
begin
    
    
    addr<=s_addr;
    process(reset_n,clk)
    begin
        if reset_n='0' then
            s_addr<=(others => '0');
        elsif rising_edge(clk) then
            if en='1' then
                s_addr<=s_next;
                --s_next(31 downto 0)<= std_logic_vector(unsigned(s_next(31 downto 0))+to_unsigned(4, 16)); 

            end if;
        end if;
    end process;


    control_flow : process(s_addr, add_imm, sel_imm, sel_a, imm, a) is
    begin

            --if (add_imm = '1') then                    -- BRANCH
            --    s_next <= "0x0000" & std_logic_vector(signed(s_next) + signed(imm));

            --elsif (sel_imm = '1') then                              -- CALL
            --    s_next <= "0x00000000";
            --    s_next(17 downto 2) <= imm;

            --elsif (sel_a = '1') then                                -- CALLR
            --    s_add <= "0x0000" & a;

            --elsif (sel_a = '1') then                                -- JMP
            --    s_add <= "0x0000" & a;

            --elsif (sel_imm = '1') then                              -- JUMPI
            --    s_next <= "0x00000000";
            --    s_next(17 downto 2) <= imm;

        s_next<= std_logic_vector(unsigned(s_addr(31 downto 0))+to_unsigned(4, 32));
        
        if (add_imm = '1') then                                 -- BRANCH
            s_next <= std_logic_vector(signed(s_next) + to_signed(to_integer(signed(imm)), 32));

        elsif (sel_imm = '1') then                              -- CALL & JUMPI (same)
            s_next(17 downto 2) <= imm;

        elsif (sel_a = '1') then                                -- CALLR & JMP (same)
            s_next(15 downto 0) <=  a;


        end if;


        -- normal case? address + 4

    end process control_flow;

end synth;
