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
		anodo : out std_logic_vector (3 downto 0);
		leds : out std_logic_vector (7 downto 0)
	);
end top;

architecture Behavioral of top is
	signal cur_state : STATE;
	signal next_state : STATE;

	signal cents : integer range 0 to 99;
	signal seconds : integer range 0 to 59;
	signal minutes : integer range 0 to 15;
	signal quarter : integer range 0 to 4;

	signal passed_cent : std_logic;
	signal passed_sec : std_logic;
	signal passed_min : std_logic;

	signal loaded_secs : integer range 0 to 59;
	signal reserved_loaded_secs : integer range 0 to 59;
	signal loaded_min : integer range 0 to 15;
	signal reserved_loaded_min : integer range 0 to 15;
	signal loaded_quarters : integer range 0 to 3;
	signal reserved_loaded_quarters : integer range 0 to 3;

	signal d_para_continua : std_logic;
	signal d_novo_quarto : std_logic;
	signal d_carga : std_logic;

	signal fim_quarto : std_logic;

	type sec_table is array (0 to 3) of integer range 0 to 59;

	constant c_seconds_to_secs : sec_table := (
		0, 15, 30, 45
	);

	type ROM is array (0 to 99) of std_logic_vector (7 downto 0);

	constant conv_to_BCD : ROM := (
		"00000000", "00000001", "00000010", "00000011", "00000100",
		"00000101", "00000110", "00000111", "00001000", "00001001",
		"00010000", "00010001", "00010010", "00010011", "00010100",
		"00010101", "00010110", "00010111", "00011000", "00011001",
		"00100000", "00100001", "00100010", "00100011", "00100100",
		"00100101", "00100110", "00100111", "00101000", "00101001",
		"00110000", "00110001", "00110010", "00110011", "00110100",
		"00110101", "00110110", "00110111", "00111000", "00111001",
		"01000000", "01000001", "01000010", "01000011", "01000100",
		"01000101", "01000110", "01000111", "01001000", "01001001",
		"01010000", "01010001", "01010010", "01010011", "01010100",
		"01010101", "01010110", "01010111", "01011000", "01011001",
		"01100000", "01100001", "01100010", "01100011", "01100100",
		"01100101", "01100110", "01100111", "01101000", "01101001",
		"01110000", "01110001", "01110010", "01110011", "01110100",
		"01110101", "01110110", "01110111", "01111000", "01111001",
		"10000000", "10000001", "10000010", "10000011", "10000100",
		"10000101", "10000110", "10000111", "10001000", "10001001",
		"10010000", "10010001", "10010010", "10010011", "10010100",
		"10010101", "10010110", "10010111", "10011000", "10011001");

	signal d1 : std_logic_vector(5 downto 0);
	signal d2 : std_logic_vector(5 downto 0);
	signal d3 : std_logic_vector(5 downto 0);
	signal d4 : std_logic_vector(5 downto 0);

	signal cent_bcd : std_logic_vector(7 downto 0);
	signal sec_bcd : std_logic_vector(7 downto 0);

	type one_hot_table_type is array(0 to 4) of std_logic_vector(3 downto 0);

	constant one_hot_table : one_hot_table_type := (
		"0001", "0010", "0100", "1000", "1111"
	);

begin

	-- Debouncers
	para_continua_debouncer : entity work.Debounce port map(
		clock => clock,
		reset => reset,
		key => para_continua,
		debkey => d_para_continua
		);
	-- d_para_continua <= para_continua;

	novo_quarto_debouncer : entity work.Debounce port map(
		clock => clock,
		reset => reset,
		key => novo_quarto,
		debkey => d_novo_quarto
		);
	-- d_novo_quarto <= novo_quarto;

	carga_debouncer : entity work.Debounce port map(
		clock => clock,
		reset => reset,
		key => carga,
		debkey => d_carga
		);
	-- d_carga <= carga;
	--------------------------------------------

	loaded_secs <= c_seconds_to_secs(to_integer(unsigned(c_segundos)));
	loaded_min <= to_integer(unsigned(c_minutos));
	loaded_quarters <= to_integer(unsigned(c_quarto));

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
		valor_carregado => reserved_loaded_secs
		);

	passed_min <= '1' when (seconds = 0) and (passed_sec = '1') else
		'0';

	min15_counter : entity work.min15_counter port map (
		clk => clock,
		enable => passed_min,
		state => cur_state,
		reset => reset,
		valor_carregado => reserved_loaded_min,
		minutos => minutes
		);

	quarter_counter : entity work.quarter_counter port map (
		clk => clock,
		enable => d_novo_quarto,
		state => cur_state,
		reset => reset,
		quarter => quarter,
		valor_carregado => reserved_loaded_quarters
		);

	fim_quarto <= '1' when (minutes = 0) and (seconds = 0) and (cents = 0) else
		'0';

	load_time : process (clock, reset, cur_state, d_carga)
	begin
		if reset = '1' then
			reserved_loaded_secs <= 0;
			reserved_loaded_min <= 0;
			reserved_loaded_quarters <= 0;
		elsif clock'event and clock = '1' then
			if cur_state = LOAD and d_carga = '1' then
				reserved_loaded_secs <= loaded_secs;
				reserved_loaded_min <= loaded_min;
				reserved_loaded_quarters <= loaded_quarters;
			end if;
		end if;
	end process;

	State_reg_proc :
	process (clock, reset)
	begin
		if reset = '1' then
			cur_state <= REP;
		elsif clock'event and clock = '1' then
			cur_state <= next_state;
		end if;
	end process;

	process (cur_state, d_carga, d_para_continua, quarter, fim_quarto, d_novo_quarto)
	begin
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
	end process;

	cent_bcd <= conv_to_BCD(cents);
	sec_bcd <= conv_to_BCD(seconds);

	d4 <= '1' & cent_bcd(3 downto 0) & '1';
	d3 <= '1' & cent_bcd(7 downto 4) & '1';
	d2 <= '1' & sec_bcd(3 downto 0) & '0';
	d1 <= '1' & sec_bcd(7 downto 4) & '1';

	display_driver : entity work.dspl_drv port map (
		clock => clock,
		reset => reset,
		d4 => d4,
		d3 => d3,
		d2 => d2,
		d1 => d1,
		an => anodo,
		dec_ddp => DSPL_sete_seg
		);

	leds(7 downto 4) <= one_hot_table(quarter);
	leds(3 downto 0) <= std_logic_vector(to_unsigned(minutes, 4));

end Behavioral;