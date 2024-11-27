----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:29:44 11/22/2024 
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
		min_enable: out std_logic;
		output_secs: out integer range 0 to 59;
		valor_carregado: in integer range 0 to 59
	);
end min_counter;

architecture Behavioral of min_counter is
	signal counter : integer range 0 to 59;
begin
	output_secs <= counter;

	process (clk, reset)
	begin
		if reset = '1' then
			counter <= 59;
			min_enable <= '0';--adicionado depois
		elsif clk'event and clk = '1' then
			case state is
				when REP =>
				when CONTA =>
        	        -- Estado de contagem decrementa se habilitado e maior que 0
						if enable = '1' then
							if counter = 0 then --ou seja deu um sec
								min_enable <= '1';
								counter <= 59;
							else
								min_enable <= '0';
								counter <= counter-1;
							end if;
						end if;
				when LOAD =>
        	        -- Estado de carga (carregar valor externo)
					counter <= valor_carregado;
					min_enable <= '0';
						
				when PARADO =>
        	        -- Estado parado (mantém o valor atual)
					min_enable <= '0';
						
				when others =>
					-- Estado de segurança
					counter <= counter;
					min_enable <= '0';
			end case;
		end if;
					
	end process;

end Behavioral;

