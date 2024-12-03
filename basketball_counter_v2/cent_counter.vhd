----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:11:06 11/12/2024 
-- Design Name: 
-- Module Name:    cent_counter - Behavioral 
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
use IEEE.NUMERIC_STD.all;
use work.constants.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cent_counter is
	generic (
		counts_to_cent : integer := 50_000
	);
	port (
		reset : in std_logic;
		clk : in std_logic;
		state : in STATE;
		passed_cent : out std_logic
	);
end cent_counter;

architecture Behavioral of cent_counter is
	constant counts_to_cent_last : integer := counts_to_cent - 1;
	signal counter : integer range 0 to counts_to_cent_last;
begin
	process (clk, reset)
	begin
		if reset = '1' then
			passed_cent <= '0';
			counter <= 0;
		elsif clk'event and clk = '1' then
			if state = CONTA then
				if counter = counts_to_cent_last then
					passed_cent <= '1';
					counter <= 0;
				else
					passed_cent <= '0';
					counter <= counter + 1;
				end if;
			end if;
		end if;
	end process;

end Behavioral;