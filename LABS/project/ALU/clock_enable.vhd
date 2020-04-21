library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity clock_enable is
generic (
    g_NPERIOD : unsigned(16-1 downto 0) := x"0064"
);
port (
    clk_i          : in  std_logic;
    reset	       : in  std_logic; -- Synchronous reset (active low)
    clock_enable_o : out std_logic
);
end entity clock_enable;

architecture Behavioral of clock_enable is
    signal s_cnt : unsigned(16-1 downto 0) := x"0000";
begin


    p_clk_enable : process(clk_i)
    begin
        if rising_edge(clk_i) then  -- Rising clock edge
            if reset = '0' then  -- Synchronous reset (active low)
                s_cnt <= (others => '0');   -- Clear all bits
                clock_enable_o <= '0';
            else
                if s_cnt >= g_NPERIOD-1 then
                    s_cnt <= (others => '0');
                    clock_enable_o <= '1';
                else
                    s_cnt <= s_cnt + x"0001";
                    clock_enable_o <= '0';
                end if;
            end if;
        end if;
    end process p_clk_enable;

end architecture Behavioral;