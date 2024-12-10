----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:02:14 11/26/2024 
-- Design Name: 
-- Module Name:    quarter_counter - Behavioral 
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
use work.constants.ALL;

entity quarter_counter is
    port(
        clk: in std_logic;
        enable: in std_logic;
        state: in STATE;
        reset: in std_logic;
        quarter: out integer range 0 to 4;
        valor_carregado: in integer range 0 to 4;
        quarter_enable: out std_logic
    );
end quarter_counter;

architecture Behavioral of quarter_counter is
    signal contador_interno: integer range 1 to 4;
begin
    process(clk, reset)
	 begin
        if reset = '1' then
            contador_interno <= 1;
            quarter_enable <= '0';
        elsif clk'event and clk = '1' then
            case state is
                when REP =>
                    -- Reseta o contador para 4
                    contador_interno <= 1;
                    quarter_enable <= '0';

                when CONTA =>
                    -- Estado de contagem decrementa se habilitado e maior que 0
                    if enable = '1' then
                        if contador_interno > 4 then
                            contador_interno <= contador_interno+1;
                            quarter_enable <= '0';
                        else
                            quarter_enable <= '1';
                        end if;
                    end if;
                
                when LOAD =>
                    -- Estado de carga (carregam valor externo)
                    contador_interno <= valor_carregado;
                    quarter_enable <= '0';
                
                when PARADO =>
                    -- Estado parado (mantém o valor atual)
                    quarter_enable <= '0';
                
                when others =>
                    -- Estado de segurança
                    contador_interno <= contador_interno;
                    quarter_enable <= '0';
            end case;
        end if;
    end process;
                        
    quarter <= contador_interno;            
end Behavioral;

