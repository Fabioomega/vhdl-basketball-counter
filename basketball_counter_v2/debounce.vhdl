----------------------------------------------------------------------------------
-- Company: UFSC
-- Designer: Ney Calazans
-- 
-- Create Date: 17.11.2024 10:51:00
-- Design Name: cron_basq
-- Module Name: Debounce - Debounce
-- Project Name: Cronmetro de Basquete
-- Target Devices: Nexys 2 (FPGA Spartan 3E xc3s1200e-4fg320)
-- Tool Versions: ISE 14.7
-- Description: Este  mdulo que adapta o apertar de chaves em escala temporal
--		humana para a escala temporal da placa. O apertar de uma tecla na entrada
--		 transformado em um nico pulso de relgio. Um apertar longo produz
--		o efeito de auto-repeat a exemplo do que ocorre em teclados convencionais
--		de computadores e outros equipamentos.
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Debounce is
    generic (DIVISION_RATE : integer := 4_000_000); -- Valor correto para clock de 50MHz
    port (
        clock : in std_logic;
        reset : in std_logic; -- Ateno polaridade do reset mudada a partir desta data para positiva 
        key : in std_logic;
        debkey : out std_logic);
end Debounce;

architecture Debounce of Debounce is
    type State_type is (S1, S2, S3, S4, S5, S6, S7, S8);
    signal EA, EADiv : State_type;
    signal clockLento : std_logic := '0';
    -- Lembrando, a inicializao  meramente simulvel,  ignorada na sntese!!

begin
    process (reset, clock)
    begin
        if (clock'event and clock = '0') then -- borda de descida do clock da mquina
            if (reset = '1') then
                EA <= S1;
            else
                case EA is
                    when S1 => if (key = '1') then
                        EA <= S2;
                end if;
                when S2 => EA <= S3;
                when S3 => if (clockLento = '1') then
                EA <= S4;
            end if;
            when S4 => if (clockLento = '0') then
            EA <= S5;
        end if;
        when S5 => if (clockLento = '1') then
        EA <= S6;
    end if;
    when S6 => if (clockLento = '0') then
    EA <= S7;
end if;
when S7 => if (clockLento = '1') then
EA <= S8;
end if;
when S8 => if (clockLento = '0') then
EA <= S1;
end if;
end case;
end if;
end if;
end process;

-- A tecla debkey tem lgica afirmada (lembre de comparar com teclas da placa alvo,
--	bem como com o que o projeto especifica como polaridade para teclas)
debkey <= '1' when (EA = S2) else
          '0';

-- Divisor do clock de entrada para gerar um clock lento, baseado no parmetro DIVISION_RATE
process (reset, clock)
    variable count : integer;
begin
    if (clock'event and clock = '1') then -- borda de subida do relgio externo
        if (reset = '1') then
            EADiv <= S1;
            clockLento <= '0';
        else
            case EADiv is
                when S1 => count := 0;
                    EADiv <= S2;
                when others =>
                    if (count < DIVISION_RATE) then
                        count := count + 1;
                        EADiv <= S2;
                    else
                        EADiv <= S1;
                        clockLento <= not(clockLento);
                    end if;
            end case;
        end if;
    end if;
end process;

end Debounce;