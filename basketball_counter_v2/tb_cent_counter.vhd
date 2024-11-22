-- TestBench Template 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;

entity testbench is
end testbench;

architecture behavior of testbench is

    -- Signals
    signal reset : std_logic := '0';
    signal state : STATE := REP;
    signal passed_cent : std_logic := '0';
    
    -- Clk
    signal clk : std_logic := '0';
    constant period: time := 5ns;
begin

    -- Component Instantiation
    uut : entity work.cent_counter 
	 generic map(
		counts_to_cent => 10
	 )
	 port map(
      reset => reset,
		clk => clk,
		state => state,
		passed_cent => passed_cent
    );

    process
    begin
        wait for period;
		  clk <= not clk;
    end process;

    reset <= '1' after 10ns, '0' after 15ns;
end;