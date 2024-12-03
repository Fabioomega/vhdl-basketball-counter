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
                anodo => open
                );

        process
        begin
                wait for clk_period_half;
                clock <= not clock;
        end process;

        reset <= '1', '0' after 10ns;
		  c_segundos <= "11";
		  c_minutos <= "0001";
		  carga <= '1' after 20ns, '0' after 30ns;
		  para_continua <= '1' after 50ns, '0' after 60ns;
end;