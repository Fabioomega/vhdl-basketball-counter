--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.constants.all;

entity min15_counter is
    port (
        clk : in std_logic;
        enable : in std_logic;
        state : in STATE;
        reset : in std_logic;
        valor_carregado : in integer range 0 to 15;
        minutos : out integer range 0 to 15;
        min_enable : out std_logic
    );
end min15_counter;

architecture Behavioral of min15_counter is
    signal contador_interno : integer range 0 to 15 := 15;
begin
    process (clk, reset)
    begin
        if clk'event and clk = '1' then
            case state is
                when REP =>
                    -- Resta o contador para 15
                    contador_interno <= 15;
                    min_enable <= '0';

                when CONTA =>
                    -- Estado de contagem decrementa se habilitado e maior que 0
                    if enable = '1' then
                        if contador_interno > 0 then
                            contador_interno <= contador_interno - 1;
                            min_enable <= '0'; -- Não finalizada a contagem
                        else
                            min_enable <= '1'; -- Contagem finalizada
                        end if;
                    end if;

                when LOAD =>
                    -- Estado de carga (carregar valor externo)
                    contador_interno <= valor_carregado;
                    min_enable <= '0';

                when PARADO =>
                    -- Estado parado (mantém o valor atual)
                    min_enable <= '0';

                when others =>
                    -- Estado de segurança
                    contador_interno <= contador_interno;
                    min_enable <= '0';
            end case;
        end if;
    end process;

    minutos <= contador_interno;
end Behavioral;