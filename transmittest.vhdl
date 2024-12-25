library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Transmitter_Testbench is
end Transmitter_Testbench;

architecture Behavioral of Transmitter_Testbench is


    constant N : integer := 64;             
    constant CP_LENGTH : integer := 16;     
    constant W : integer := 16;             
   
    signal clk       : std_logic := '0';
    signal reset     : std_logic := '1';
    signal tx_data_in : std_logic_vector((2 * N) - 1 downto 0); 
    signal tx_data_out : std_logic_vector(15 downto 0);         
    signal tx_ready   : std_logic;                             

    
    constant CLK_PERIOD : time := 10 ns;

   
    component OFDM_Transmitter
        Generic (
            N : integer := 64;        
            CP_LENGTH : integer := 16 
        );
        Port (
            clk        : in  std_logic;
            reset      : in  std_logic;
            data_in    : in  std_logic_vector((2 * N) - 1 downto 0);
            serial_out : out std_logic_vector(15 downto 0);
            data_ready : out std_logic
        );
    end component;

begin
 
    Transmitter: OFDM_Transmitter
        Generic Map (
            N => N,
            CP_LENGTH => CP_LENGTH
        )
        Port Map (
            clk => clk,
            reset => reset,
            data_in => tx_data_in,
            serial_out => tx_data_out,
            data_ready => tx_ready
        );

    clk_process : process
    begin
        while true loop
            clk <= not clk;
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    process
        variable input_data : std_logic_vector((2 * N) - 1 downto 0);
    begin
        reset <= '1';
        tx_data_in <= (others => '0');
        wait for 2 * CLK_PERIOD;
        reset <= '0';

        wait for 10 ns;
        
        report "Please assign values to tx_data_in through the simulator.";
        
        wait until tx_ready = '1';

        assert tx_data_out /= (others => '0')
        report "Transmitter Output Validated"
        severity note;

        wait; 
    end process;

end Behavioral;
