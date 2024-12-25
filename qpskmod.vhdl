library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity QPSK_Modulator is
    Generic (
        N : integer := 64  
    );
    Port (
        clk      : in  std_logic;
        reset    : in  std_logic;
        data_in  : in  std_logic_vector((2*N)-1 downto 0);  
        qpsk_out : out array(0 to N-1) of signed(15 downto 0) 
    );
end QPSK_Modulator;

architecture Behavioral of QPSK_Modulator is
begin
    process(clk, reset)
    begin
        if reset = '1' then
            for i in 0 to N-1 loop
                qpsk_out(i) <= to_signed(0, 16);
            end loop;
        elsif rising_edge(clk) then
            for i in 0 to N-1 loop
                case data_in((2*i)+1 downto 2*i) is
                    when "00" => qpsk_out(i) <= to_signed(16384, 16);  -- 1+j (scaled)
                    when "01" => qpsk_out(i) <= to_signed(16384, 16);  -- 1-j
                    when "10" => qpsk_out(i) <= to_signed(-16384, 16); -- -1+j
                    when "11" => qpsk_out(i) <= to_signed(-16384, 16); -- -1-j
                    when others => qpsk_out(i) <= to_signed(0, 16);
                end case;
            end loop;
        end if;
    end process;
end Behavioral;
