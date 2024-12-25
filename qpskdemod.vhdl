library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity QPSK_Demodulator is
    Generic (
        N : integer := 64  
    );
    Port (
        clk      : in  std_logic;
        reset    : in  std_logic;
        freq_in  : in  array(0 to N-1) of signed(15 downto 0);  
        data_out : out std_logic_vector((2*N)-1 downto 0)       
    );
end QPSK_Demodulator;

architecture Behavioral of QPSK_Demodulator is
begin
    process(clk, reset)
    begin
        if reset = '1' then
            data_out <= (others => '0');
        elsif rising_edge(clk) then
            for i in 0 to N-1 loop
                case freq_in(i) is
                    when others => data_out((2*i)+1 downto 2*i) <= "00"; 
                end case;
            end loop;
        end if;
    end process;
end Behavioral;
