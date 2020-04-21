library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
	port(
    	clk_i 	:in std_logic;
        clk_en	:in std_logic;
        Calc	:in std_logic;
        reset 	:in std_logic;
        A		:in unsigned(7 downto 0);
        B		:in unsigned(7 downto 0);
        Sel		:in unsigned(5 downto 0);
        Log_op	:out std_logic;
        Result	:out unsigned(7 downto 0)
    );
end ALU;

architecture ALU of ALU is
begin
	p_ALU : process(clk_i)
	begin
    -- + x"00" resizes calculated result to 8 bits
    	if rising_edge(clk_i) then
        	if reset = '0' then
			Result <= "00000000";
            Log_op <= '0';
            
      		elsif clk_en = '1' AND Calc = '0' then
              case Sel is
               -- addition
              	when "100000" =>
                 	Log_op <= '0';
					Result <= A + B;
                    
              -- substraction
                when "010000" =>
                	Log_op <= '0';
                	if A > B then
                		Result <= A - B;
                    else
                    	Result <= B - A;
                    end if;    
                    
              -- multiplication
                when "001000" =>
                	Log_op <= '0';
         			Result <= unsigned(resize(unsigned(A * B),8));
                    
              -- division
                when "000100" =>
                	Log_op <= '0';
                    if (A = x"00") AND (B = x"00") then
                	Result <=  x"00";
                    elsif A > B then
                		Result <=  A / B;
                    else 
                    	Result <=  B / A;
                   	end if;

              -- AND each bit
                 when "000010" =>
                    Log_op <= '1';
                    Result(0) <= A(0) AND B(0);
                    Result(1) <= A(1) AND B(1);
                    Result(2) <= A(2) AND B(2);
                    Result(3) <= A(3) AND B(3);
                    
              -- OR each bit
                 when "000001" =>
                    Log_op <= '1';
                    Result(0) <= A(0) OR B(0);
                    Result(1) <= A(1) OR B(1);
                    Result(2) <= A(2) OR B(2);
                    Result(3) <= A(3) OR B(3);
                      
                 when others =>
              		  
              end case;
            end if;    
         end if;     
	end process p_ALU;
end architecture ALU;