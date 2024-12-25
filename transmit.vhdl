library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity OFDM_Transmitter is
    Generic (
        N           : integer := 64;  
        CP_LENGTH   : integer := 16   
    );
    Port (
        clk         : in  std_logic;                            
        reset       : in  std_logic;                            
        data_in     : in  std_logic_vector((2*N)-1 downto 0);   
        tx_enable   : in  std_logic;                            
        data_out    : out std_logic_vector(15 downto 0);       
        data_ready  : out std_logic                             
    );
end OFDM_Transmitter;

architecture Behavioral of OFDM_Transmitter is

    -- Signal declarations for internal connections
    signal qpsk_symbols : array(0 to N-1) of signed(15 downto 0); 
    signal ifft_output  : array(0 to N-1) of signed(15 downto 0); 
    signal with_cp      : array(0 to N+CP_LENGTH-1) of signed(15 downto 0); 
    signal serial_data  : std_logic_vector(15 downto 0);         
    signal ready        : std_logic;                            

begin

    QPSK_Mod: entity work.QPSK_Modulator
        Generic Map (
            N => N
        )
        Port Map (
            clk       => clk,
            reset     => reset,
            data_in   => data_in,
            qpsk_out  => qpsk_symbols
        );

    IFFT_Block: entity work.IFFT_Module
        Generic Map (
            N => N
        )
        Port Map (
            clk       => clk,
            reset     => reset,
            freq_in   => qpsk_symbols,
            time_out  => ifft_output
        );

    CP_Adder: entity work.Cyclic_Prefix_Adder
        Generic Map (
            N         => N,
            CP_LENGTH => CP_LENGTH
        )
        Port Map (
            clk        => clk,
            reset      => reset,
            input_data => ifft_output,
            output_cp  => with_cp
        );

    P2S_Converter: entity work.Parallel_to_Serial
        Generic Map (
            N => N + CP_LENGTH
        )
        Port Map (
            clk        => clk,
            reset      => reset,
            data_in    => with_cp,
            serial_out => serial_data,
            data_ready => ready
        );

    data_out <= serial_data;
    data_ready <= ready;

end Behavioral;
