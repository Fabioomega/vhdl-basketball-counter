-- TestBench Template 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_top is
end tb_top;

architecture behavior of tb_top is

        signal clock : std_logic := '0';
        signal reset : std_logic := '0';
        signal para_continua : std_logic := '0';
        signal novo_quarto : std_logic := '0';
        signal carga : std_logic := '0';

        signal c_quarto : std_logic_vector (1 downto 0) := (others => '0');
        signal c_minutos : std_logic_vector (3 downto 0) := (others => '0');
        signal c_segundos : std_logic_vector (1 downto 0) := (others => '0');
        signal DSPL_sete_seg : std_logic_vector (7 downto 0) := (others => '0');
        signal anodo : std_logic_vector (3 downto 0) := (others => '0');

        constant clk_period_half : time := 5ns;
begin

        -- Component Instantiation
        uut : entity work.top port map (
                clock => clock,
                reset => reset,
                para_continua => para_continua,
                novo_quarto => novo_quarto,
                carga => carga,
                c_quarto => c_quarto,
                c_minutos => c_minutos,
                c_segundos => c_segundos,
                DSPL_sete_seg => open,
                anodo => open,
					 leds => open
                );

        process
        begin
                wait for clk_period_half;
                clock <= not clock;
        end process;

        reset <= '1', '0' after 95 ns, '1' after 20.700ms, '0' after 20.700095ms;
        para_continua <= '0', '1' after 110ns, '0' after 120ns,
                         '1' after 5.000110ms, '0' after 5.000120ms,
                         '1' after 10.000110ms, '0' after 10.000120ms,
                         '1' after 15.000110ms, '0' after 15.000120ms,
                         '1' after 18.000190ms, '0' after 18.000200ms, -- parada por 1 ms
                         '1' after 19.000190ms, '0' after 19.000200ms, -- parada por 1 ms
                         '1' after 21.000000ms, '0' after 21.000010ms,
                         '1' after 22.000000ms, '0' after 22.000010ms,
                         '1' after 23.000000ms, '0' after 23.000010ms
                         ;
        novo_quarto <= '0',
                       '1' after 5ms, '0' after 5.000010ms,
                       '1' after 10ms, '0' after 10.000010ms,
                       '1' after 15ms, '0' after 15.000010ms;

        c_quarto <= "10"; -- Quarto=2
        c_minutos <= "0101"; -- Minutos=5
        c_segundos <= "11"; -- Segundos =13
        carga <= '0', '1' after 21.000500ms, '0' after 21.000510ms;
end;