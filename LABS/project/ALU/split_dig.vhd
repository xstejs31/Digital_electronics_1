library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity split_dig is
	port(
    	result	:in unsigned(7 downto 0);
        reset	:in std_logic;
        clk_i	:in std_logic;
        clk_en	:in	std_logic;
        log_op	:in std_logic;
        dig_o	:out std_logic_vector(3 downto 0);
        seg_out	:out std_logic_vector(3 downto 0)
    );
end split_dig;

architecture split_dig of split_dig is
    signal S0			:unsigned(3 downto 0) := "0000";
    signal S0_temp		:integer := 0;
    signal S1			:unsigned(3 downto 0) := "0000";
    signal S1_temp		:integer := 0;
    signal S2			:unsigned(3 downto 0) := "0000";
    signal S2_temp		:integer := 0;
    signal S3		:unsigned(3 downto 0) := "0000";  
    
    signal seg		:unsigned(3 downto 0) := "0001";
begin

--------------------------------------------------------------------------
	p_split : process(clk_i)
	begin
    	if rising_edge(clk_i) then
        	if reset = '0' then
				S0 <= "0000";
                S1 <= "0000";
                S2 <= "0000";
                S3 <= "0000";
                S0_temp <= 0;
                S1_temp <= 0;
                S2_temp <= 0;

      		elsif log_op = '0' then
            	if clk_en = '1' then
                	S0_temp <= to_integer(result);
                    S0 <= to_unsigned((S0_temp mod 10),4);
            		S1_temp <= S0_temp/10;
                    S1 <= to_unsigned((S1_temp mod 10),4);
            		S2_temp <= S1_temp/10;
            		S2 <= to_unsigned((S2_temp mod 10),4);
              		--2x4bits, max 3 digit number
              	end if;
            elsif log_op = '1' then
            	if clk_en = '1' then    
                    S0 <= (unsigned(resize(unsigned(result),4)) and "0001");
					S1 <= (unsigned(resize(unsigned(result),4)) and "0010") ror 1;
                    S2 <= (unsigned(resize(unsigned(result),4)) and "0100") ror 2;
                    S3 <= (unsigned(resize(unsigned(result),4)) and "1000") ror 3;                       
           		end if;
            end if;  
         end if;     
	end process p_split;
--------------------------------------------------------------------------
    p_dig_out : process(clk_i)
    begin
    	if rising_edge(clk_i) then
        	case seg is
            	when "0001" =>
                	dig_o <= std_logic_vector(not seg);
                    seg_out <= std_logic_vector(S0);
                    
                    seg <= seg rol 1;
                when "0010" =>
             		dig_o <= std_logic_vector(not seg);
                    seg_out <= std_logic_vector(S1);
                    
      				seg <= seg rol 1;
                when "0100" =>
             		dig_o <= std_logic_vector(not seg);
                    seg_out <= std_logic_vector(S2);
                    
                    seg <= seg rol 1;
                when "1000" =>
                	dig_o <= std_logic_vector(not seg);
                    seg_out <= std_logic_vector(S3);
                    
                    seg <= seg rol 1;
                when others =>
            end case;
        end if;
    end process p_dig_out;
--------------------------------------------------------------------------
end architecture split_dig;