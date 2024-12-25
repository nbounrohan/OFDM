library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity OFDM_Receiver is
    Generic (
        N           : integer := 64;  
        CP_LENGTH   : integer := 16   
    );
    Port (
        clk         : in  std_logic;                            
        reset       : in  std_logic;                            
        data_in     : in  std_logic_vector(15 downto 0);        
        rx_enable   : in  std_logic;                            
        data_out    : out std_logic_vector((2*N)-1 downto 0);   
        data_ready  : out std_logic                             
    );
end OFDM_Receiver;

architecture Behavioral of OFDM_Receiver is

    signal parallel_data : array(0 to N+CP_LENGTH-1) of signed(15 downto 0); 
    signal no_cp_data    : array(0 to N-1) of signed(15 downto 0);           
    signal freq_data     : array(0 to N-1) of signed(15 downto 0);           
    signal demod_data    : std_logic_vector((2*N)-1 downto 0);               
    signal ready         : std_logic;                                       

begin

    S2P_Converter: entity work.Serial_to_Parallel
        Generic Map (
            N => N + CP_LENGTH
        )
        Port Map (
            clk        => clk,
            reset      => reset,
            serial_in  => data_in,
            data_out   => parallel_data,
            data_ready => ready
        );

    CP_Remover: entity work.Cyclic_Prefix_Remover
        Generic Map (
            N         => N,
            CP_LENGTH => CP_LENGTH
        )
        Port Map (
            clk        => clk,
            reset      => reset,
            input_data => parallel_data,
            output_data => no_cp_data
        );

    FFT_Block: entity work.FFT_Module
        Generic Map (
            N => N
        )
        Port Map (
            clk       => clk,
            reset     => reset,
            time_in   => no_cp_data,
            freq_out  => freq_data
        );

    QPSK_Demod: entity work.QPSK_Demodulator
        Generic Map (
            N => N
        )
        Port Map (
            clk       => clk,
            reset     => reset,
            freq_in   => freq_data,
            data_out  => demod_data
        );
        
    data_out <= demod_data;
    data_ready <= ready;

end Behavioral;
