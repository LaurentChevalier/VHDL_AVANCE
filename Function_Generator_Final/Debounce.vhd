LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;

ENTITY Debounce IS PORT 
(	 
	MCLK		: in std_logic;
	RST_N		: in std_logic;
	button 		: in std_logic;
	OUTPUT 		: out std_logic
);
END ENTITY;

ARCHITECTURE ARCH of Debounce is	

	type state_type is (s0, s1, s2);
	SIGNAL TEMP0, TEMP1, button_latched: std_logic;
	SIGNAL Counter : unsigned(31 downto 0) ;
	signal state   : state_type;
	

BEGIN

	PROCESS (RST_N, MCLK)
	BEGIN
		IF RST_N='0' THEN
			OUTPUT<='0';
			state<= s0;
		ELSIF rising_edge(MCLK) THEN 
			button_latched<=button;
			
			case state is
				when s0=>
					OUTPUT<='0';
					TEMP0<= button_latched;
					Counter<=(OTHERS=>'0');-- permet de mettre les autres bits à 0
					
					--Change state
					state<= s1;
					
				when s1=>
					Counter<=Counter + 1;
					--If Counter = 2500000 then
					  If Counter = 5500000 then
						TEMP1<=button_latched;
					--change state
					state<=s2;
					END IF;
				when s2=>
					If TEMP0='1' and TEMP1='0' then
						OUTPUT<='1';
						
		end if;
		--change state
						state<=s0;
			
			end case;
		end if;
	end process;

END ARCH;