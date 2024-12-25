library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Serial_to_Parallel is
    Generic (
        N : integer := 80 
    );
    Port (
        clk        : in  std_logic;
        reset      : in  std_logic;
        serial_in  : in  std_logic_vector(15 downto 0);
        data_out   : out array(0 to N-1) of signed(15 downto 0);
        data_ready : out std_logic
    );
end Serial_to_Parallel;

architecture Behavioral of Serial_to_Parallel is
    signal idx : integer range 0 to N-1 := 0;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            idx <= 0;
            data_ready <= '0';
        elsif rising_edge(clk) then
            if idx < N then
                data_out(idx) <= signed(serial_in);
                idx <= idx + 1;
            else
                idx <= 0;
                data_ready <= '1';
            end if;
        end if;
    end process;
end Behavioral;
