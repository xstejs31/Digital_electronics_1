library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Stopwatch is
	port (
		clk_i			:in std_logic;	--clock
        srst_n_i		:in std_logic;	--sync reset
        ce_100Hz_i		:in std_logic;	--clock enable
        cnt_en_i		:in std_logic;	--stopwatch enable
        
        sec_h_o			:out unsigned(4-1 downto 0);
        sec_l_o			:out unsigned(4-1 downto 0);
        hth_h_o			:out unsigned(4-1 downto 0);
        hth_l_o			:out unsigned(4-1 downto 0)
	);
end Stopwatch;

architecture Behavioral of Stopwatch is	    
	signal s_sec_h_i : unsigned(4-1 downto 0) :="0000";
    signal s_sec_l_i : unsigned(4-1 downto 0) :="0000";
    signal s_hth_h_i : unsigned(4-1 downto 0) :="0000";
    signal s_hth_l_i : unsigned(4-1 downto 0) :="0000";
begin
    p_Stopwatch_values : process (clk_i)
    begin
		if rising_edge(clk_i) then
            --Reset
            if srst_n_i = '0' then           	
      			s_sec_h_i <= "0000";
                s_sec_l_i <= "0000";
                s_hth_h_i <= "0000";
                s_hth_l_i <= "0000";
            
            --Stopwatch enable
            elsif cnt_en_i = '1' then 
            	
                --Overflow to minutes - reset all
                if (s_sec_h_i = "0101" and s_sec_l_i = "1001" and s_hth_h_i = "1001" and s_hth_l_i = "1001") then
            	s_sec_h_i <= "0000";
                s_sec_l_i <= "0000";
                s_hth_h_i <= "0000";
                s_hth_l_i <= "0000";
                
                --Overflow to tens of sec - reset all except tens of sec
                elsif (s_sec_l_i = "1001" and s_hth_h_i = "1001" and s_hth_l_i = "1001") then
                s_sec_h_i <= s_sec_h_i + "0001";
                s_sec_l_i <= "0000";
                s_hth_h_i <= "0000";
                s_hth_l_i <= "0000";
                
                --Overflow to seconds - reset all except secs and tens of sec
                elsif (s_hth_h_i = "1001" and s_hth_l_i = "1001") then
                s_sec_l_i <= s_sec_l_i + "0001";
                s_hth_h_i <= "0000";
                s_hth_l_i <= "0000";
                
                --Overflow to tenths - reset only hundredths
                elsif s_hth_l_i = "1001" then
                s_hth_h_i <= s_hth_h_i + "0001";
            	s_hth_l_i <= "0000";
            	
                --Hundredths increment
                else              
                s_hth_l_i <= s_hth_l_i + "0001";
                
                end if;
            end if;            
        end if;
        
	end process p_Stopwatch_values;
    
    p_Stopwatch_update : process(clk_i)
    begin
        if rising_edge(clk_i) then  -- Rising clock edge
            if srst_n_i = '0' then  -- Synchronous reset (active low)
                sec_h_o <= "0000";
                sec_l_o <= "0000";
                hth_h_o <= "0000";
                hth_l_o <= "0000";
            
            elsif ce_100Hz_i = '1' then
            	sec_h_o <= s_sec_h_i;
                sec_l_o <= s_sec_l_i;
                hth_h_o <= s_hth_h_i;
                hth_l_o <= s_hth_l_i;
            
            end if;
        end if;
    end process p_Stopwatch_update;
    
end architecture Behavioral;