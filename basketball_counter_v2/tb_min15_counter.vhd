--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:45:33 11/22/2024
-- Design Name:   
-- Module Name:   /home/ianan/HDL/vhdl-basketball-counter/basketball_counter_v2/tb_min15_counter.vhd
-- Project Name:  basketball_counter_v2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: min_counter
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.constants.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_min15_counter IS
END tb_min15_counter;
 
ARCHITECTURE behavior OF tb_min15_counter IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
   --Inputs
   signal clk : std_logic := '0';
   signal enable : std_logic := '0';
   signal state : STATE := REP;
   signal reset : std_logic := '0';
   signal valor_carregado : integer := 8; -- Corrigido

 	--Outputs
   signal minutos : integer; -- Corrigido
   signal min_enable : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: entity work.min_counter PORT MAP (
          clk => clk,
          enable => enable,
          state => state,
          reset => reset,
          valor_carregado => valor_carregado,
          minutos => minutos,
          min_enable => min_enable
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
	sin_entradas: process
   begin
      -- Reset
      reset <= '1';
      wait for 20 ns;
      reset <= '0';

      -- Testar REP (reset do contador)
      state <= REP;
      wait for clk_period * 5;

      -- Testa LOAD (carregar valor)
      state <= LOAD;
      valor_carregado <= 12;
      wait for clk_period * 5;

      -- Testa CONTA (contagem decrescente)
      state <= CONTA;
      enable <= '1';
      wait for clk_period * 16;

      -- Teste PARADO (pausa)
      state <= PARADO;
      enable <= '0';
      wait for clk_period * 5;

      -- Retorna estado REP (renício)
      state <= REP;
      wait for clk_period * 5;

      wait;
   end process;

END;
