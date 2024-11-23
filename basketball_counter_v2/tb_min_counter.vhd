--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:19:45 11/22/2024
-- Design Name:   
-- Module Name:   /home/lanzuolo/vhdl-basketball-counter/basketball_counter_v2/tb_min_counter.vhd
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
use work.constants.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_min_counter IS
END tb_min_counter;
 
ARCHITECTURE behavior OF tb_min_counter IS 
 
    -- Component Declaration for the Unit Under Test (UUT)

   --Inputs
   signal clk : std_logic := '0';
   signal enable : std_logic := '0';
   signal reset : std_logic := '0';
   signal state : STATE := REP;

 	--Outputs
   signal passed_min : std_logic;
   signal output_min : integer range 0 to 59;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: entity work.min_counter PORT MAP (
          clk => clk,
          enable => enable,
          reset => reset,
          state => state,
          passed_min => passed_min,
          output_min => output_min
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
	enable <= '1';

END;