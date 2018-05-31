set_global_assignment -entity "mapll" -library "lib_mapll" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "mapll" -library "lib_mapll" -name IP_TOOL_VERSION "17.1"
set_global_assignment -entity "mapll" -library "lib_mapll" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_mapll" -name SPD_FILE [file join $::quartus(sip_path) "mapll.spd"]

set_global_assignment -library "lib_mapll" -name MISC_FILE [file join $::quartus(sip_path) "mapll_sim/mapll.vho"]
