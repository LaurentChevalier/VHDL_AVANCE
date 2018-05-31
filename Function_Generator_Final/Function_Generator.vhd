-- Quartus Prime VHDL Template
-- Four-State Moore State Machine

-- A Moore machine's outputs are dependent only on the current state.
-- The output is written only when the state changes.  (State
-- transitions are synchronous.)

library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Function_Generator is

	port(
		clk		 : in	std_logic;
		buttons : in unsigned(5 downto 0);
		input	 : in	std_logic;--
		--reset	 : in	std_logic;--
		outputsig	 : out	std_logic_vector(1 downto 0);
		LED 		: out unsigned(7 downto 0)
	);

end entity;

architecture rtl of Function_Generator is

Component mapll is
	port (
		refclk   : in  std_logic := '0'; --  refclk.clk
		rst      : in  std_logic := '0'; --   reset.reset
		outclk_0 : out std_logic;        -- outclk0.clk
		locked   : out std_logic         --  locked.export
	);
	end Component;

Component Debounce is
	port (
		MCLK		: in std_logic;
		RST_N		: in std_logic;
		button 		: in std_logic;
		OUTPUT 		: out std_logic
	);
	end Component;

Component Square_wave is
	port(	 
		MCLK		: in std_logic;
		RST_N		: in std_logic;
		frequency : in integer;
		square_on : in std_logic;
		OUTPUT 		: out std_logic
	);
	end Component;
	
Component Square_Duty_wave is
	port(	 
		MCLK		: in std_logic;
		RST_N		: in std_logic;
		frequency : in integer;
		square_duty_on : in std_logic;
		duty		: in integer;
		OUTPUT 		: out std_logic
	);
	end Component;	

	-- Build an enumerated type for the state machine
	--type state_type is (s0, s1, s2, s3);

	-- Register to hold the current state
	--signal state   : state_type;
	
	SIGNAL reset, deb_RST_N, deb_Range, deb_Plus, deb_Minus, deb_Dutyp, deb_Dutym, outputout, outputsquareduty, outputsquare :std_logic;
	SIGNAL RST_N, USER_BP, DUM, MCLK 	: std_logic;
	SIGNAL counter: unsigned(7 downto 0);
	SIGNAL multiply_range: integer;
	SIGNAL frequency: integer;
	SIGNAL duty: integer;
	SIGNAL square: std_logic;
	SIGNAL squareduty: std_logic;

begin


PROCESS (reset, MCLK)
	BEGIN
reset <= buttons(0);
outputsig(0) <= outputsquareduty;
squareduty<='1';

IF reset='0' THEN
		counter<=(OTHERS=>'0');	
		frequency<=100;
		duty<=50;
		multiply_range<=1;	
		ELSIF rising_edge(MCLK) THEN
		
			IF (frequency <=1) then
				frequency<=1;
			END IF;
		
			IF deb_Range = '1' THEN
				--counter <= counter + 1; //only for debug purpose
				IF multiply_range < 4 THEN
				multiply_range<= multiply_range+1;
				ELSIF multiply_range >= 4 THEN
				multiply_range<= 1;
				END IF;
			END IF;
			IF deb_Plus = '1' THEN
				--counter <= counter + 1;
				IF multiply_range = 1 THEN
				frequency<=frequency+1;
				ELSIF multiply_range = 2 THEN
				frequency<=frequency+10;
				ELSIF multiply_range = 3 THEN
				frequency<=frequency+100;
				ELSIF multiply_range = 4 THEN
				frequency<=frequency+1000;
				END IF;
			END IF;
			IF deb_Minus = '1' THEN
				--counter <= counter - 1;
				IF multiply_range = 1 THEN
				frequency<=frequency-1;
				ELSIF multiply_range = 2 THEN
				frequency<=frequency-10;
				ELSIF multiply_range = 3 THEN
				frequency<=frequency-100;
				ELSIF multiply_range = 4 THEN
				frequency<=frequency-1000;
				END IF;
			END IF;
			IF deb_Dutyp = '1' THEN
				IF (duty <100) THEN
				duty<=duty+10;
				ELSE
				END IF;
				--counter <= counter - 1;
				--square<='1';
				--outputout <= outputsquare;
				--outputsig(0) <= outputout;
			END IF;
			IF deb_Dutym = '1' THEN
				IF (duty >10) THEN
				duty<=duty-10;
				ELSE
				END IF;				
				--counter <= counter + 1;
				--squareduty<='1';
				--outputout <= outputsawtooth;
				--outputsig(0) <= outputout;
			END IF;
		END IF;	
		LED <= counter;
	END PROCESS;	
--	
inst0: mapll port map (
			clk,
			NOT reset,
			MCLK,
			DUM

		);
inst1: Debounce port map (
		MCLK,
		reset,
		buttons(0),
		deb_RST_N
	);
	
inst2: Debounce port map (
		MCLK,
		reset,
		buttons(1),
		deb_Range
	);
	
inst3: Debounce port map (
		MCLK,
		reset,
		buttons(2),
		deb_Plus
	);
	
inst4: Debounce port map (
		MCLK,
		reset,
		buttons(3),
		deb_Minus
	);
	
inst5: Debounce port map (
		MCLK,
		reset,
		buttons(4),
		deb_Dutyp
	);
	
inst6: Debounce port map (
		MCLK,
		reset,
		buttons(5),
		deb_Dutym
	);
inst7: Square_wave port map (
		MCLK,
		reset,
		frequency,
		square,
		outputsquare
	);
inst8: Square_Duty_wave port map (
		MCLK,
		reset,
		frequency,
		squareduty,
		duty,
		outputsquareduty
	);	

end rtl;