library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity traffic_lights is 
	port(
    	clk_i : in std_logic;
        reset : in std_logic; 
        
        lights_NS :out unsigned(2 downto 0) :="000";
        lights_EW :out unsigned(2 downto 0) :="000"    
    );
end traffic_lights;

architecture traffic_lights of traffic_lights is
    type state_type is (red_green, red_orange, red_red, redorange_red, green_red, orange_red, red_red2, red_redorange);
    signal state: state_type;
    signal count : unsigned(3 downto 0);
    constant SEC5: unsigned(3 downto 0) := "1111";
    constant SEC1: unsigned(3 downto 0) := "0011";
	begin
-----------------------------------------------------------------------------------------
		p_Traffic : process(clk_i)
		begin
        if rising_edge(clk_i) then
        	if reset = '0' then
        	state <= red_green;
            count <= "0000";
        	else
              	case state is
                  	when red_green =>
                      	if count = (SEC5-1) then
                          	state <= red_orange;
                          	count <= "0000";
                      	else
                          	state <= red_green;
                          	count <= count + "0001";
                      	end if;
	
                  	when red_orange =>
                      	if count = (SEC1 - 1) then
                          	state <= red_red;
                          	count <= "0000";
                      	else
                          	state <= red_orange;
                          	count <= count + "0001";
                      	end if;
	
                  	when red_red =>
                      	if count = (SEC5 - 1) then
                          	state <= redorange_red;
                          	count <= "0000";
                      	else
                          	state <= red_red;
                          	count <= count + "0001";
                      	end if;
	
                  	when redorange_red =>
                      	if count = (SEC1 - 1) then
                          	state <= green_red;
                          	count <= "0000";
                      	else
                          	state <= redorange_red;
                          	count <= count + "0001";
                      	end if;
	
                  	when green_red =>
                      	if count = (SEC5 - 1) then
                          	state <= orange_red;
                          	count <= "0000";
                      	else
                          	state <= green_red;
                          	count <= count + "0001";
                      	end if;
	
                  	when orange_red =>
                      	if count = (SEC1 - 1) then
                          	state <= red_red2;
                          	count <= "0000";
                      	else
                          	state <= orange_red;
                          	count <= count + "0001";
                      	end if;    
	
                  	when red_red2 =>
                      	if count = (SEC5 - 1) then
                          	state <= red_redorange;
                          	count <= "0000";
                      	else
                          	state <= red_red2;
                          	count <= count + "0001";
                      	end if;    
	
                  	when red_redorange =>
                      	if count = (SEC1 - 1) then
                          	state <= red_green;
                          	count <= "0000";
                      	else
                          	state <= red_redorange;
                          	count <= count + "0001";
                      	end if;  
                  	when others =>
                      	state <= red_green;
              	end case;    
			end if;
        end if;
        end process p_Traffic;
------------------------------------------------------------------------------------------
        p_Light_out : process(state)
        begin
        	case state is
            	when red_green =>
                	lights_NS <= "100";
                    lights_EW <= "001";
                    
                when red_orange =>
                	lights_NS <= "100";
                    lights_EW <= "010";
                    
                when red_red =>
                	lights_NS <= "100";
                    lights_EW <= "100";
                    
                when redorange_red =>
                	lights_NS <= "110";
                    lights_EW <= "100";
                    
                when green_red =>
                	lights_NS <= "001";
                    lights_EW <= "100";
                    
                when orange_red =>
                	lights_NS <= "010";
                    lights_EW <= "100";
                    
                when red_red2 =>
                	lights_NS <= "100";
                    lights_EW <= "100";
                    
                when red_redorange =>
                	lights_NS <= "100";
                    lights_EW <= "110";
                when others =>
                	lights_NS <= "100";
                    lights_EW <= "001";
            end case;
        end process p_Light_out;
--------------------------------------------------------------------------------------------
end traffic_lights;