library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Parallel_to_Serial is
    Generic (
        N : integer := 80  
    );
    Port (
        clk        : in  std_logic;
        reset      : in  std_logic;
        data_in    : in  array(0 to N-1) of signed(15 downto 0);
        serial_out : out std_logic_vector(15 downto 0);
        data_ready : out std_logic
    );
end Parallel_to_Serial;

architecture Behavioral of Parallel_to_Serial is
    signal index : integer range 0 to N-1 := 0;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            serial_out <= (others => '0');
            index <= 0;
            data_ready <= '0';
        elsif rising_edge(clk) then
            if index < N then
                serial_out <= std_logic_vector(data_in(index));
                index <= index + 1;
            else
                index <= 0;
                data_ready <= '1';
            end if;
        end if;
    end process;
end Behavioral;
