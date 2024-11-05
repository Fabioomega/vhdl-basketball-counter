--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:34:55 10/29/2024
-- Design Name:   
-- Module Name:   /home/fabioomega/ISE/Counter/counter_tb.vhd
-- Project Name:  Counter
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: counter
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY counter_tb IS
END counter_tb;
 
ARCHITECTURE behavior OF counter_tb IS 
 
   --Inputs
   signal load_button : std_logic := '0';
   signal start : std_logic := '0';
   signal reset : std_logic := '0';
   signal clk : std_logic := '0';
   signal chaves: std_logic_vector(6 downto 0) := "0000111";

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: entity work.counter generic map (clk_frequency => 2) PORT MAP (
          load_button => load_button,
          start => start,
          reset => reset,
          clk => clk,
          chaves => chaves
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
	
	reset <= '1', '0' after 10ns;
   
   load_button <= '1' after 15ns;
END;
