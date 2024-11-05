----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:00:40 10/29/2024 
-- Design Name: 
-- Module Name:    counter - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter is
	generic (
		clk_frequency : integer := 50_000_000
	);

	port (
		load_button : in std_logic;
		start : in std_logic;
		reset : in std_logic;
		clk : in std_logic;
		chaves : in std_logic_vector(6 downto 0)
	);
end counter;

architecture Behavioral of counter is
	constant clk_frequency_half : integer := clk_frequency / 2;

	signal clk_internal : std_logic;

	type ROM is array (0 to 99) of std_logic_vector (7 downto 0);

	constant conv_to_BCD : ROM := (
		"00000000", "00000001", "00000010", "00000011", "00000100",
		"00000101", "00000110", "00000111", "00001000", "00001001",
		"00010000", "00010001", "00010010", "00010011", "00010100",
		"00010101", "00010110", "00010111", "00011000", "00011001",
		"00100000", "00100001", "00100010", "00100011", "00100100",
		"00100101", "00100110", "00100111", "00101000", "00101001",
		"00110000", "00110001", "00110010", "00110011", "00110100",
		"00110101", "00110110", "00110111", "00111000", "00111001",
		"01000000", "01000001", "01000010", "01000011", "01000100",
		"01000101", "01000110", "01000111", "01001000", "01001001",
		"01010000", "01010001", "01010010", "01010011", "01010100",
		"01010101", "01010110", "01010111", "01011000", "01011001",
		"01100000", "01100001", "01100010", "01100011", "01100100",
		"01100101", "01100110", "01100111", "01101000", "01101001",
		"01110000", "01110001", "01110010", "01110011", "01110100",
		"01110101", "01110110", "01110111", "01111000", "01111001",
		"10000000", "10000001", "10000010", "10000011", "10000100",
		"10000101", "10000110", "10000111", "10001000", "10001001",
		"10010000", "10010001", "10010010", "10010011", "10010100",
		"10010101", "10010110", "10010111", "10011000", "10011001");

	type states is (REP, LOAD, COUNT);

	signal EA, PE : states;
	--EA -> Estado atual
	--PE -> Próximo estado
	signal divisor : integer range 0 to (clk_frequency_half - 1);

	signal seconds_counter : integer range 0 to 59;
	signal minutes_counter : integer range 0 to 99;
	
begin
	state_machine : process (clk, reset)
	begin
		if reset = '1' then
			EA <= REP;
		else
			if clk'event and clk = '1' then
				case EA is
					when REP =>
						if load_button = '1' then
							PE <= LOAD;
						else
							PE <= REP;
						end if;
					when LOAD =>
						minutes_counter <= to_integer(unsigned(chaves));
						if start = '1' then
							PE <= COUNT;
						else
							PE <= LOAD;
						end if;
					when COUNT =>
						if seconds_counter = 0 and minutes_counter = 0 then
							PE <= REP;
						else
							PE <= COUNT;
						end if;
				end case;
				EA <= PE;
			end if;
		end if;
	end process;

	clk_divisor_1s : process (clk, reset)
		constant upper_bound : integer := (clk_frequency_half - 1);
	begin
		if reset = '1' then
			divisor <= 0;
			clk_internal <= '0';
		else
			if clk'event and clk = '1' then
				if divisor = upper_bound then
					clk_internal <= not clk_internal;
					divisor <= 0;
				else
					divisor <= divisor + 1;
				end if;
			end if;
		end if;
	end process;

	seconds_counter_process : process (clk_internal, reset)
	begin
		if reset = '1' then
			seconds_counter <= 0;
		else
			if clk_internal'event and clk_internal = '1' then
				if EA = COUNT then
					if seconds_counter = 0 then
						seconds_counter <= 59;
					else
						seconds_counter <= seconds_counter - 1;
					end if;
				else
					seconds_counter <= seconds_counter;
				end if;
			end if;
		end if;
	end process;

	minutes_counter_process : process (clk_internal, reset)
	begin
		if reset = '1' then
			minutes_counter <= 0;
		else
			if clk_internal'event and clk_internal = '1' then
				if EA = COUNT then
					if seconds_counter = 0 then
						if minutes_counter = 0 then
							minutes_counter <= 15;
						else
							minutes_counter <= minutes_counter - 1;
						end if;
					else
						minutes_counter <= minutes_counter;
					end if;
				else
					minutes_counter <= minutes_counter;
				end if;
			end if;
		end if;
	end process;

end Behavioral;