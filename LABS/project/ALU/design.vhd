library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is 
	port(
      clk_i			:in std_logic;
      reset			:in std_logic;
      SW0_CPLD, SW1_CPLD, SW2_CPLD, SW3_CPLD, SW4_CPLD, SW5_CPLD, SW6_CPLD, SW7_CPLD :in std_logic;
      SW8_CPLD, SW9_CPLD, SW10_CPLD, SW11_CPLD, SW12_CPLD, SW13_CPLD :in std_logic;
      BTN0, BTN1	:in std_logic;
      disp_seg_o	:out std_logic_vector(6 downto 0);
      disp_dig_o	:out std_logic_vector(3 downto 0)
    );
end top;

architecture top of top is
   	signal s_A			:unsigned(7 downto 0);
   	signal s_B 			:unsigned(7 downto 0);
   	signal s_Sel		:unsigned(5 downto 0);
    signal s_Result		:unsigned(7 downto 0);
    signal s_Log_op		:std_logic;
    signal s_clock_en 	:std_logic;
    signal s_hex		:std_logic_vector(3 downto 0);
  
	begin
    -- A
   	s_A(0) <= SW0_CPLD;
   	s_A(1) <= SW1_CPLD;	
   	s_A(2) <= SW2_CPLD;
   	s_A(3) <= SW3_CPLD;
    s_A(4) <= '0';
    s_A(5) <= '0';
    s_A(6) <= '0';
    s_A(7) <= '0';
    -- B
   	s_B(0) <= SW4_CPLD;
	s_B(1) <= SW5_CPLD;
	s_B(2) <= SW6_CPLD;
	s_B(3) <= SW7_CPLD;
    s_B(4) <= '0';
    s_B(5) <= '0';
    s_B(6) <= '0';
    s_B(7) <= '0';
    -- Sel
	s_Sel(0) <= SW8_CPLD; -- +
   	s_Sel(1) <= SW9_CPLD; -- -
   	s_Sel(2) <= SW10_CPLD; -- *
   	s_Sel(3) <= SW11_CPLD; -- /
   	s_Sel(4) <= SW12_CPLD; -- AND
	s_Sel(5) <= SW13_CPLD; -- OR

-----------------------------------------------------------------------------------------
	
    clock_enable : entity work.clock_enable
    port map (
    	clk_i => clk_i,
        reset => BTN0,
        clock_enable_o => s_clock_en
    );   
    
    ALU : entity work.ALU
    port map (
  		clk_i => clk_i,
		clk_en => s_clock_en,
		reset => BTN0,
        A => s_A,
		B => s_B,
		Sel => s_Sel,
		Result => s_Result,
        Log_op => s_Log_op,
       	Calc => BTN1
       
    );
    
    split_dig : entity work.split_dig
    port map (
    	result => s_result,
        Log_op => s_Log_op,
		reset => BTN0,
		clk_i => clk_i,
		clk_en => s_clock_en,
		seg_out	=> s_hex,
        dig_o => disp_dig_o
    );
    
    hex_to_7seg : entity work.hex_to_7seg
    port map (
    	hex_i => s_hex,
        seg_o => disp_seg_o
    );
    
end top;