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

package constants is

	type STATE is (REP, CONTA, LOAD, PARADO);
	-- constant cycles_for_1_cent : integer := 4;
	constant cycles_for_1_cent : integer := 500_000;

end constants;

package body constants is
end constants;