library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench is
end testbench;

architecture tb of testbench is
	component traffic_lights is
    port(
    	clk_i			:in std_logic;	
        reset			:in std_logic;
           
        lights_NS		:out unsigned(2 downto 0);
        lights_EW		:out unsigned(2 downto 0)
    );
    end component;
    
    --Inputs
    signal s_clk_i : std_logic :='0';
    signal s_reset :std_logic :='0';
    
    --Outputs
    signal s_lights_NS : unsigned(2 downto 0);
    signal s_lights_EW : unsigned(2 downto 0);
    
    begin    
    uut: traffic_lights port map(
    	clk_i => s_clk_i,
        reset => s_reset,
        
        lights_NS => s_lights_NS,
        lights_EW => s_lights_EW
    );
    
   	Clk_gen: process	
  	begin
    	while Now < 4.4 uS loop
      		s_clk_i <= '0';
      		wait for 0.5 NS;
      		s_clk_i <= '1';
      		wait for 0.5 NS;
    	end loop;
    	wait;
  	end process Clk_gen;

   -- Stimulus process
   stim_proc: process
   begin
       s_reset <= '1';
       wait until rising_edge(s_clk_i);	
       wait until rising_edge(s_clk_i);	
       s_reset <= '0';
       wait until rising_edge(s_clk_i);	
       wait until rising_edge(s_clk_i);	
       wait until rising_edge(s_clk_i);	
       s_reset <= '1';
       wait;
   end process;        
end tb;