----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:15:20 11/26/2024 
-- Design Name: 
-- Module Name:    top - Behavioral 
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
use IEEE.STD_LOGIC_1164.all;
use work.constants.all;
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
	port (
		clock, reset : in std_logic;
		para_continua, novo_quarto, carga : in std_logic;
		c_quarto : in std_logic_vector (1 downto 0);
		c_minutos : in std_logic_vector (3 downto 0);
		c_segundos : in std_logic_vector (1 downto 0);
		DSPL_sete_seg : out std_logic_vector (7 downto 0);
		anodo : out std_logic_vector (3 downto 0)
	);
end top;

architecture Behavioral of top is
	signal cur_state : STATE;
	signal next_state : STATE;

	signal cents : integer range 0 to 99;
	signal seconds : integer range 0 to 59;
	signal minutes : integer range 0 to 59;
	signal quarter : integer range 1 to 4;

	signal passed_cent : std_logic;
	signal passed_sec : std_logic;
	signal passed_min : std_logic;
	signal passed_quarter : std_logic;

	signal loaded_secs : integer range 0 to 59;
	signal loaded_min : integer range 0 to 15;
	signal loaded_quarters : integer range 1 to 4;

	signal d_para_continua : std_logic;
	signal d_novo_quarto : std_logic;
	signal d_carga : std_logic;

	signal fim_quarto : std_logic;

	type sec_table is array (0 to 3) of integer range 0 to 59;

	constant c_seconds_to_secs : sec_table := (
		0, 15, 30, 45
	);

	type quarter_table is array (0 to 3) of integer range 1 to 4;

	constant c_quarter_to_quarters : quarter_table := (
		1, 2, 3, 4
	);

begin

	-- Debouncers
	-- para_continua_debouncer : entity work.Debounce port map(
	-- 	clock => clock,
	-- 	reset => reset,
	-- 	key => para_continua,
	-- 	debkey => d_para_continua
	-- 	);
	d_para_continua <= para_continua;

	-- novo_quarto_debouncer : entity work.Debounce port map(
	-- 	clock => clock,
	-- 	reset => reset,
	-- 	key => novo_quarto,
	-- 	debkey => d_novo_quarto
	-- 	);
	d_novo_quarto <= novo_quarto;

	-- carga_debouncer : entity work.Debounce port map(
	-- 	clock => clock,
	-- 	reset => reset,
	-- 	key => carga,
	-- 	debkey => d_carga
	-- 	);
	d_carga <= carga;
	--------------------------------------------

	loaded_secs <= c_seconds_to_secs(to_integer(unsigned(c_segundos)));
	loaded_min <= to_integer(unsigned(c_minutos));
	loaded_quarters <= c_quarter_to_quarters(to_integer(unsigned(c_quarto)));

	cent_counter : entity work.cent_counter generic map (
		counts_to_cent => cycles_for_1_cent
		)
		port map(
			reset => reset,
			clk => clock,
			state => cur_state,
			passed_cent => passed_cent
		);

	sec_counter : entity work.sec_counter port map (
		clk => clock,
		enable => passed_cent,
		reset => reset,
		state => cur_state,
		output_cents => cents
		);

	passed_sec <= '1' when (cents = 0) and (passed_cent = '1') else
		'0';

	min_counter : entity work.min_counter port map (
		clk => clock,
		enable => passed_sec,
		reset => reset,
		state => cur_state,
		output_secs => seconds,
		valor_carregado => loaded_secs
		);

	passed_min <= '1' when (seconds = 0) and (passed_sec = '1') else
		'0';

	min15_counter : entity work.min15_counter port map (
		clk => clock,
		enable => passed_min,
		state => cur_state,
		reset => reset,
		valor_carregado => loaded_min,
		minutos => minutes
		);

	passed_quarter <= '1' when (minutes = 0) and (passed_min = '1') else
		'0';

	quarter_counter : entity work.quarter_counter port map (
		clk => clock,
		enable => passed_quarter,
		state => cur_state,
		reset => reset,
		quarter => quarter,
		valor_carregado => loaded_quarters
		);

	fim_quarto <= '1' when (minutes = 0) and (seconds = 0) and (cents = 0) and (quarter = 4) else
		'0';

	process (clock, reset)
	begin
		if reset = '1' then
			cur_state <= REP;
			next_state <= REP;
		elsif clock'event and clock = '1' then
			case cur_state is
				when REP =>
					if d_carga = '1' then
						next_state <= LOAD;
					elsif d_para_continua = '1' and quarter < 4 then
						next_state <= CONTA;
					else
						next_state <= REP;
					end if;
				when CONTA =>
					if d_para_continua = '1' or fim_quarto = '1' then
						next_state <= PARADO;
					else
						next_state <= CONTA;
					end if;
				when LOAD =>
					if d_para_continua = '1' then
						next_state <= CONTA;
					else
						next_state <= LOAD;
					end if;
				when PARADO =>
					if d_novo_quarto = '1' and fim_quarto = '1' then
						next_state <= REP;
					elsif d_para_continua = '1' and fim_quarto = '0' then
						next_state <= CONTA;
					elsif d_carga = '1' then
						next_state <= LOAD;
					else
						next_state <= PARADO;
					end if;
			end case;
		end if;
		cur_state <= next_state;
	end process;

end Behavioral;