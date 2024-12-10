--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:27:56 11/26/2024
-- Design Name:   
-- Module Name:   /home/ianan/HDL/vhdl-basketball-counter/basketball_counter_v2/tb_quarter_counter.vhd
-- Project Name:  basketball_counter_v2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: quarter_counter
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
 
ENTITY tb_quarter_counter IS
END tb_quarter_counter;
 
ARCHITECTURE behavior OF tb_quarter_counter IS 
 

   --Inputs
   signal clk : std_logic := '0';
   signal enable : std_logic := '0';
   signal state : STATE := REP;
   signal reset : std_logic := '0';
   signal valor_carregado : integer := 3;

 	--Outputs
   signal quarter : integer;
   signal quarter_enable : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: entity work.quarter_counter PORT MAP (
          clk => clk,
          enable => enable,
          state => state,
          reset => reset,
          quarter => quarter,
          valor_carregado => valor_carregado,
          quarter_enable => quarter_enable
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
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
      valor_carregado <= 3;
      wait for clk_period * 5;

      -- Testa CONTA (contagem CRESCENTE)
      state <= CONTA;
      enable <= '1';
      wait for clk_period * 5;

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
