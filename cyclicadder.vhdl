library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Cyclic_Prefix_Adder is
    Generic (
        N         : integer := 64;  
        CP_LENGTH : integer := 16   
    );
    Port (
        clk        : in  std_logic;
        reset      : in  std_logic;
        input_data : in  array(0 to N-1) of signed(15 downto 0); 
        output_cp  : out array(0 to N+CP_LENGTH-1) of signed(15 downto 0) 
    );
end Cyclic_Prefix_Adder;

architecture Behavioral of Cyclic_Prefix_Adder is
begin
    process(clk, reset)
    begin
        if reset = '1' then
            for i in 0 to N+CP_LENGTH-1 loop
                output_cp(i) <= to_signed(0, 16);
            end loop;
        elsif rising_edge(clk) then
            for i in 0 to CP_LENGTH-1 loop
                output_cp(i) <= input_data(N-CP_LENGTH+i);
            end loop;
            for i in 0 to N-1 loop
                output_cp(CP_LENGTH+i) <= input_data(i);
            end loop;
        end if;
    end process;
end Behavioral;
