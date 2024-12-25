library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FFT_Module is
    Generic (
        N : integer := 64  
    );
    Port (
        clk       : in  std_logic;
        reset     : in  std_logic;
        time_in   : in  array(0 to N-1) of signed(15 downto 0);  
        freq_out  : out array(0 to N-1) of signed(15 downto 0)   
    );
end FFT_Module;

architecture Behavioral of FFT_Module is
begin
    process(clk, reset)
    begin
        if reset = '1' then
            for i in 0 to N-1 loop
                freq_out(i) <= to_signed(0, 16);
            end loop;
        elsif rising_edge(clk) then
            for i in 0 to N-1 loop
                freq_out(i) <= time_in(i); -- Placeholder for FFT computation
            end loop;
        end if;
    end process;
end Behavioral;
