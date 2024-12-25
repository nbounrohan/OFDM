library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Receiver_Testbench is
end Receiver_Testbench;

architecture Behavioral of Receiver_Testbench is

    constant N : integer := 64;             
    constant CP_LENGTH : integer := 16;     
    constant W : integer := 16;             

    signal clk       : std_logic := '0';
    signal reset     : std_logic := '1';
    signal rx_data_in : std_logic_vector(15 downto 0);          
    signal rx_data_out : std_logic_vector((2 * N) - 1 downto 0); 
    signal rx_ready   : std_logic;                             

    constant CLK_PERIOD : time := 10 ns;

    component OFDM_Receiver
        Generic (
            N : integer := 64;        
            CP_LENGTH : integer := 16 
        );
        Port (
            clk        : in  std_logic;
            reset      : in  std_logic;
            data_in    : in  std_logic_vector(15 downto 0);
            data_out   : out std_logic_vector((2 * N) - 1 downto 0);
            data_ready : out std_logic
        );
    end component;

begin

    Receiver: OFDM_Receiver
        Generic Map (
            N => N,
            CP_LENGTH => CP_LENGTH
        )
        Port Map (
            clk => clk,
            reset => reset,
            data_in => rx_data_in,
            data_out => rx_data_out,
            data_ready => rx_ready
        );

    clk_process : process
    begin
        while true loop
            clk <= not clk;
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    process
    begin

        reset <= '1';
        rx_data_in <= (others => '0');
        wait for 2 * CLK_PERIOD;
        reset <= '0';

        wait for 10 ns; 
        
        report "Please assign values to rx_data_in through the simulator.";

        wait until rx_ready = '1';

        assert rx_data_out /= (others => '0')
        report "Receiver Output Validated"
        severity note;

        wait; 
    end process;

end Behavioral;
