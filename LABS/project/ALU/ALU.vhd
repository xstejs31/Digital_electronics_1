library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
	port(
    	clk_i 		:in std_logic;
        clk_en		:in std_logic;
        Calc_i		:in std_logic;
        reset 		:in std_logic;
        A			:in unsigned(3 downto 0);
        B			:in unsigned(3 downto 0);
        Sel			:in unsigned(3 downto 0);
        Overflow	:out std_logic:='0';
        Result_is_0 :out std_logic:='0';
        Dev_by_0	:out std_logic:='0';
        Log_op		:out std_logic:='0';
        Result		:out unsigned(7 downto 0)
    );
end ALU;

architecture ALU of ALU is
begin
	p_ALU : process(clk_i)
	begin
    	if rising_edge(clk_i) then
        	if reset = '0' then
			Result <= "00000000";
            Log_op <= '0';
            
            Result_is_0 <= '0';
            Dev_by_0 <= '0';
            Overflow <= '0';
            
      		elsif clk_en = '1' AND Calc_i = '0' then
              case Sel is
              -- MIN number
              	 when "0000" =>
                    if A > B then
                    	Result <= unsigned(resize(unsigned(B),8));
                        Log_op <= '0';
                    else 
                        Result <= unsigned(resize(unsigned(A),8));
                        Log_op <= '0';
                    end if;
              -- MAX number
              	 when "1111" =>
                 	if A > B then
                    	Result <= unsigned(resize(unsigned(A),8));
                        Log_op <= '0';
                    else
                    	Result <= unsigned(resize(unsigned(B),8));
                        Log_op <= '0';
                    end if;
---------------------------------------------------------------------
              -- A - 1
              	when "0101" =>
                	if A = x"0" then
                    	Overflow <= '1';
                        Result <= x"00";
                    else 
                		Log_op <= '0';
                		Result <= unsigned(resize(unsigned(A),8)) - 1;
             		end if;
              -- A + 1
              	when "1010" =>
                	if A = x"1" then
                    	Overflow <= '1';
                        Result <= x"00";
                    else    
                   	 	Log_op <= '0';
                		Result <= unsigned(resize(unsigned(A),8)) + 1;
                    end if;
              -- ror A
              	when "0110" =>
                	Log_op <= '1';
                    Result <= unsigned(resize(unsigned(A ror 1),8));
              -- rol A
                when "0111" =>
                	Log_op <= '1';
                    Result <= unsigned(resize(unsigned(A rol 1),8));
---------------------------------------------------------------------
              -- addition
              	when "1000" =>
                 	Log_op <= '0';
					Result <= unsigned(resize(unsigned(A),8)) + unsigned(resize(unsigned(B),8));                  
              -- substraction
                when "0100" =>
                	Log_op <= '0';
                	if A >= B then
                    	if A = B then
                        	Result_is_0 <= '1';
                        end if;
                		Result <= unsigned(resize(unsigned(A),8)) - unsigned(resize(unsigned(B),8));                  	
                    else
                    	Overflow <= '1';
                        Result <= x"00";
                    end if;                      
              -- multiplication
                when "0010" =>
                	Log_op <= '0';
                    if A = x"0" OR B = x"0" then
                    	Result <= x"00";
                        Result_is_0 <= '1';
                    else                   	
         				Result <= A * B;                            
                   	end if;
              -- division
                when "0001" =>
                	Log_op <= '0';
                    if (B = x"0") then
                    	Dev_by_0 <= '1';
                		Result <=  x"00";
                    elsif (A = x"0") then
                    	Result_is_0 <= '1';
                        Result <= x"00";
                    else
                		Result <=  unsigned(resize(unsigned(A),8))/unsigned(resize(unsigned(B),8));
					end if;                    	
----------------------------------------------------------------------
              -- AND signals
                 when "1100" =>
                    Log_op <= '1';
                    Result <= unsigned(resize(unsigned(A AND B),8));               
              -- NAND signals
              	when "1011" =>
                	Log_op <= '1';
                    Result <= unsigned(resize(unsigned(A NAND B),8));
              -- OR signals
                 when "1001" =>
                    Log_op <= '1';
                    Result <= unsigned(resize(unsigned(A OR B),8));
              -- NOR signals
                 when "0011" =>
                    Log_op <= '1';
                    Result <= unsigned(resize(unsigned(A NOR B),8));
              -- XOR signals
              	 when "1110" =>
                 	Log_op <= '1';
                    Result <= unsigned(resize(unsigned(A XOR B),8));
              -- XNOR signals
              	 when "1101" =>
                 	Log_op <= '1';
                    Result <= unsigned(resize(unsigned(A XNOR B),8));
                 when others =>
              		  
              end case;
            end if;    
         end if;     
	end process p_ALU;
end architecture ALU;