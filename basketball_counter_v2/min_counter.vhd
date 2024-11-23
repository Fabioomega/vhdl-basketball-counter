----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:53:28 11/22/2024 
-- Design Name: 
-- Module Name:    min_counter - Behavioral 
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
use IEEE.STD_LOGIC_1164.ALL;
use work.constants.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity min_counter is
	port(
		clk: in std_logic;
		enable: in std_logic;
		reset: in std_logic;
		state: in STATE;
		passed_min: out std_logic;
		output_min: out integer range 0 to 59--60 segundos são um minito
	);
end min_counter;

architecture Behavioral of min_counter is
	signal counter : integer range 0 to 99;
begin
	output_min <= counter;
	process (clk, reset)
	begin
		if reset = '1' then
			counter <= 59;
			passed_min <= '0';--adicionado depois
		elsif clk'event and clk = '1' then--lógica da borda de subida do clock
			if enable = '1' then
				if counter = 0 then --ou seja deu um minuto
					passed_min <= '1';
					counter <= 59;
				else
					passed_min <= '0';
					counter <= counter-1;
				end if;
			end if;
		end if;
	end process;

end Behavioral;

