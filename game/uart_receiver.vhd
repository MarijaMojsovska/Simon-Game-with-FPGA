library ieee;
use ieee.std_logic_1164.all;
use work.newtype.all;


entity uart_receiver is
  port (clock         : in  std_logic;
        uart_rx       : in  std_logic;
        valid         : out std_logic;
        input_sequence: out matrix);
end entity uart_receiver;


architecture str of uart_receiver is

  type state_t is (idle_s, start_s, bit0_s, bit1_s, bit2_s, bit3_s, bit4_s, bit5_s, bit6_s, bit7_s, stop_s);     -- bit4_s, bit5_s, bit6_s, bit7_s => padding bits
  signal state : state_t := idle_s;

  signal baudrate_out : std_logic;
  signal received_data_s : std_logic_vector(7 downto 0);

  component sampler_generator is
    port (clock        : in  std_logic;
          uart_rx      : in  std_logic;
          baudrate_out : out std_logic);
  end component sampler_generator;


begin  -- architecture str

  sampler_generator_1 : sampler_generator port map(clock        => clock,
                                                   uart_rx      => uart_rx,
                                                   baudrate_out => baudrate_out);



  main : process (clock) is
  
  variable i : integer := 0;
  
  begin  -- process main
    if rising_edge(clock) then          -- rising clock edge
      case state is
      
        when idle_s =>   
          received_data_s <= (others => '0');
          valid           <= '0';
          if uart_rx = '0' then
            state <= start_s;
          end if;
          
        when start_s =>
          if baudrate_out = '1' then
            received_data_s(0) <= uart_rx;
            state              <= bit0_s;
          end if;
          
        when bit0_s =>
          if baudrate_out = '1' then
            received_data_s(1) <= uart_rx;
            state              <= bit1_s;
          end if;
          
        when bit1_s =>
          if baudrate_out = '1' then
            received_data_s(2) <= uart_rx;
            state              <= bit2_s;
          end if;
          
        when bit2_s =>
          if baudrate_out = '1' then
            received_data_s(3) <= uart_rx;
            state              <= bit3_s;
          end if;
          
        when bit3_s =>
          if baudrate_out = '1' then
            
            received_data_s(4) <= uart_rx;
            state              <= bit4_s;
          end if;   
          
        when bit4_s =>
          if baudrate_out = '1' then
            received_data_s(5) <= uart_rx;
            state              <= bit5_s;
          end if; 
          
        when bit5_s =>
          if baudrate_out = '1' then
            received_data_s(6) <= uart_rx;
            state              <= bit6_s;
          end if;                         
          
        when bit6_s =>
          if baudrate_out = '1' then
            received_data_s(7) <= uart_rx;
            state              <= bit7_s;
          end if;                     
          
        when bit7_s =>
          if baudrate_out = '1' then
            input_sequence(i) <= received_data_s(3 downto 0);
          	i := i + 1;
          	if i = 6 then
          		valid <= '1';
          		i := 0;
          	end if;
          	
         	state <= idle_s; 
           end if;
           
        when others => null;
        
      end case;
    end if;
  end process main;
end architecture str;
