library ieee;
use ieee.std_logic_1164.all;

entity controller is
    port(
        clk        : in  std_logic;
        reset_n    : in  std_logic;
        -- instruction opcode
        op         : in  std_logic_vector(5 downto 0);
        opx        : in  std_logic_vector(5 downto 0);
        -- activates branch condition
        branch_op  : out std_logic;
        -- immediate value sign extention
        imm_signed : out std_logic;
        -- instruction register enable
        ir_en      : out std_logic;
        -- PC control signals
        pc_add_imm : out std_logic;
        pc_en      : out std_logic;
        pc_sel_a   : out std_logic;
        pc_sel_imm : out std_logic;
        -- register file enable
        rf_wren    : out std_logic;
        -- multiplexers selections
        sel_addr   : out std_logic;
        sel_b      : out std_logic;
        sel_mem    : out std_logic;
        sel_pc     : out std_logic;
        sel_ra     : out std_logic;
        sel_rC     : out std_logic;
        -- write memory output
        read       : out std_logic;
        write      : out std_logic;
        -- alu op
        op_alu     : out std_logic_vector(5 downto 0)
    );
end controller;

architecture synth of controller is

    type StateType is (FETCH1, FETCH2, DECODE, R_OP, STORE, BREAK, LOAD1, I_OP, LOAD2);
    signal s_cur_state, s_next_state ,s_execute_state: StateType;
    signal s_op,s_opx: std_logic_vector(7 downto 0);

begin
	--basic operations
	s_op <= "00"&op;
	s_opx <= "00"&opx;
    --unused outputs
    branch_op  <='0';
    pc_add_imm <='0';
    pc_sel_a   <='0';
    pc_sel_imm <='0';   
    sel_pc     <='0';
    sel_ra     <='0';
    

    --FSM
    FSM:process(clk,reset_n)
    begin
        if(reset_n='0') then
            s_cur_state<=FETCH1;
        elsif rising_edge(clk) then
            s_cur_state<=s_next_state;
        end if;
    end process FSM;

    with s_cur_state select s_next_state<=
        FETCH2 when FETCH1,
        DECODE when  FETCH2,
        s_execute_state when DECODE,
        LOAD2 when LOAD1,
        BREAK when BREAK,
        FETCH1 when others;

    execute_state: process(s_op,s_opx)
    begin
        case (s_op) is
      	when x"3A" =>
      		if (s_opx) = x"34" then
                s_execute_state<=BREAK;
            else
                s_execute_state<=R_OP;
            end if;
        when x"17" =>
        	s_execute_state<= LOAD1;
        when x"15"=>
        	s_execute_state<= STORE;
        when others =>
        	s_execute_state <= I_OP;
        end case;
    end process execute_state;


    --Execution
    execution:process(s_cur_state)
    begin
    	--Not sure we want all the signals here but this gives us a solid base
        read<='0';
        write<='0';
        pc_en<='0';
        ir_en<='0';
        rf_wren<='0';
        imm_signed<='0';
        sel_b<='0';
        sel_rC<='0';
        sel_addr<='0';
        sel_mem<='0';

        case s_cur_state is
        when FETCH1 =>
            read<='1';

        when FETCH2=>
            pc_en<='1';
            ir_en<='1';

        when I_OP=>
        	imm_signed<='1';
        	rf_wren<='1';
      
        when R_OP=>
        	sel_b<='1';
        	sel_rC<='1';
        	rf_wren<='1';
	    
        when LOAD1=>
        	read<='1';
        	sel_addr<='1';
        	imm_signed<='1';

        when LOAD2=>
        	rf_wren<='1';
        	sel_mem<='1';

        when STORE=>
        	write<='1';
        	sel_addr<='1';
        	imm_signed<='1';

        when others=>
        	null;
         --BREAK or DECODE
        end case;
    end process execution;


    alu_control : process (s_opx, s_op)
    begin
      case (s_op) is
      when x"3A" =>	--R-type instructions use the opx to leave room for I-type instructions
      	case (s_opx) is 
      		when x"0E"=>
      			op_alu<="100001";--and
      		when x"1B"=>
      			op_alu<="110011";--srl
      		when others =>
      			op_alu<=(others=>'0');
      	end case;
      when x"04"|x"17"|x"15"=>
      	op_alu<="000000";--add
      when others=>
      	op_alu<=(others=>'0');
      end case;



      

    end process alu_control;
    













end synth;




