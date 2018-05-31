LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;

ENTITY Square_wave IS PORT 
(	 
	MCLK		: in std_logic;
	RST_N		: in std_logic;
	frequency :in integer;
	square_on : in std_logic;
	OUTPUT 		: out std_logic
);
END ENTITY;

ARCHITECTURE ARCH of Square_wave is	

	type state_type is (ST0, ST1, ST2);
	SIGNAL outputsig: std_logic;
	SIGNAL Counter : integer ;
	--signal clock_freq: integer;
	signal square: std_logic;
	signal STATE   : state_type;
	signal period: integer;
	signal freq: integer;
	

BEGIN

	PROCESS (RST_N, MCLK)
	BEGIN
	--clock_freq<=100000000;
	freq<=frequency;
	square<=square_on;
	--freq<=100;
	period<=((100000000/freq)/2);
	--period<=50000000;
	OUTPUT<=outputsig; 
		IF RST_N='0' THEN
			square <= '0';
			--outputsig<= '0';
		ELSIF rising_edge(MCLK) THEN 
		
-- Signal Generation First Version		
--		--outputsig<= '1';
--		
--		--If counter is zero, toggle sq_wave_reg 
--			if Counter = 0 THEN
--				outputsig<= not outputsig;
--				
--				--Generate 1Hz Frequency
--				Counter <= (clock_freq/2)-1;  
--			
--			--Else count down
--			else 
--				Counter <= Counter - 1; 
--			end if; 

-- Signal Generation NEW WAY	
case STATE is

				when ST0=>
					Counter<=0;
					if square='1' then
					STATE<=ST1;
					END if;
					
				when ST1=>
					outputsig<='1';
					Counter <=Counter + 1;
					if Counter = period then
						Counter<=0;
						STATE<=ST2;
					END IF;

					IF square='0' then
						STATE<=ST0;
					END IF;
					
				when ST2=>
					outputsig<='0';
					Counter<=Counter + 1;
					IF Counter=period then
						Counter<=0;
						STATE<=ST1;
					END IF;
				
					IF square='0' then
						STATE<=ST0;
					END IF;
					
			end case;
				
		
		end if;
	end process;

END ARCH;