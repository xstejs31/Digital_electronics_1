library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench is
end testbench;

architecture tb of testbench is
	component Stopwatch is
    port(
    	clk_i			:in std_logic;	--clock
        srst_n_i		:in std_logic;	--sync reset
        ce_100Hz_i		:in std_logic;	--clock enable
        cnt_en_i		:in std_logic;	--stopwatch enable
        
        sec_h_o			:out unsigned(4-1 downto 0);
        sec_l_o			:out unsigned(4-1 downto 0);
        hth_h_o			:out unsigned(4-1 downto 0);
        hth_l_o			:out unsigned(4-1 downto 0)
    );
    end component;
    
    --Inputs
    signal s_clk_i : std_logic :='0';
    signal s_srst_n_i :std_logic :='0';
    signal s_cnt_en_i	:std_logic :='0';
    
    --Outputs
    signal s_sec_h_o : unsigned(4-1 downto 0);
    signal s_sec_l_o : unsigned(4-1 downto 0);
    signal s_hth_h_o : unsigned(4-1 downto 0);
    signal s_hth_l_o : unsigned(4-1 downto 0);
    
    begin    
    uut: Stopwatch port map(
    	clk_i => s_clk_i,
        srst_n_i => s_srst_n_i,
        ce_100Hz_i => s_clk_i,
        cnt_en_i => s_clk_i,
        
        sec_h_o => s_sec_h_o,
        sec_l_o => s_sec_l_o,
        hth_h_o => s_hth_h_o,
        hth_l_o => s_hth_l_o
    );
    
   	Clk_gen: process	
  	begin
    	while Now < 6 uS loop
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
        s_srst_n_i <= '1';
        wait until rising_edge(s_clk_i);	
        wait until rising_edge(s_clk_i);	
        s_srst_n_i <= '0';
        wait until rising_edge(s_clk_i);	
        wait until rising_edge(s_clk_i);	
        wait until rising_edge(s_clk_i);	
        s_srst_n_i <= '1';
        wait;
    
    end process;        
end tb;