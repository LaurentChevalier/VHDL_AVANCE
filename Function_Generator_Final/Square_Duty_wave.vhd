LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;

ENTITY Square_Duty_wave IS PORT 
(	 
	MCLK		: in std_logic;
	RST_N		: in std_logic;
	frequency :in integer;
	square_duty_on : in std_logic;
	duty		: in integer;
	OUTPUT 		: out std_logic
);
END ENTITY;

ARCHITECTURE ARCH of Square_Duty_wave is	

	type state_type is (ST0, ST1, ST2);
	SIGNAL outputsig: std_logic;
	SIGNAL Counter : integer ;
	--signal clock_freq: integer;
	signal squareduty: std_logic;
	signal STATE   : state_type;
	signal period: integer;
	signal freq: integer;
	signal dut: integer;
	

BEGIN

	PROCESS (RST_N, MCLK)
	BEGIN
	--clock_freq<=100000000;
	freq<=frequency;
	dut<=duty;
	squareduty<=square_duty_on;
	--duty<=80;
	--freq<=100;
	--period<=((100000000/freq)/2);
	period<=((100000000/freq));
	--period<=50000000;
	OUTPUT<=outputsig; 
		IF RST_N='0' THEN
			squareduty <= '0';
			--outputsig<= '0';
		ELSIF rising_edge(MCLK) THEN 
		

case STATE is

				when ST0=>
					Counter<=0;
					if squareduty='1' then
					STATE<=ST1;
					END if;
					
				when ST1=>
					outputsig<='1';
					Counter <=Counter + 1;
					if Counter = period*dut/100 then
						Counter<=0;
						STATE<=ST2;
					END IF;

					IF squareduty='0' then
						STATE<=ST0;
					END IF;
					
				when ST2=>
					outputsig<='0';
					Counter<=Counter + 1;
					IF Counter=period*(100-dut)/100 then
						Counter<=0;
						STATE<=ST1;
					END IF;
				
					IF squareduty='0' then
						STATE<=ST0;
					END IF;
					
			end case;
				
		
		end if;
	end process;

END ARCH;