# USB (PS/2)
 set_property PACKAGE_PIN C17 [get_ports CLK_MOUSE]                        
    set_property IOSTANDARD LVCMOS33 [get_ports CLK_MOUSE]
    set_property PULLUP true [get_ports CLK_MOUSE]
 set_property PACKAGE_PIN B17 [get_ports DATA_MOUSE]                    
    set_property IOSTANDARD LVCMOS33 [get_ports DATA_MOUSE]    
    set_property PULLUP true [get_ports DATA_MOUSE]
     
# Clock signal
set_property PACKAGE_PIN W5 [get_ports CLK]       
    set_property IOSTANDARD LVCMOS33 [get_ports CLK]
set_property PACKAGE_PIN U18 [get_ports RESET]     
    set_property IOSTANDARD LVCMOS33 [get_ports RESET]
 
# 7Seg display 
set_property PACKAGE_PIN W7 [get_ports LED_OUT[0]]                    
    set_property IOSTANDARD LVCMOS33 [get_ports LED_OUT[0]]
set_property PACKAGE_PIN W6 [get_ports LED_OUT[1]]     
    set_property IOSTANDARD LVCMOS33 [get_ports LED_OUT[1]]
set_property PACKAGE_PIN U8 [get_ports LED_OUT[2]]     
    set_property IOSTANDARD LVCMOS33 [get_ports LED_OUT[2]]
set_property PACKAGE_PIN V8 [get_ports LED_OUT[3]]     
    set_property IOSTANDARD LVCMOS33 [get_ports LED_OUT[3]]
set_property PACKAGE_PIN U5 [get_ports LED_OUT[4]]              
    set_property IOSTANDARD LVCMOS33 [get_ports LED_OUT[4]]
set_property PACKAGE_PIN V5 [get_ports LED_OUT[5]]
    set_property IOSTANDARD LVCMOS33 [get_ports LED_OUT[5]]
set_property PACKAGE_PIN U7 [get_ports LED_OUT[6]]              
    set_property IOSTANDARD LVCMOS33 [get_ports LED_OUT[6]]
set_property PACKAGE_PIN V7 [get_ports LED_OUT[7]]                    
    set_property IOSTANDARD LVCMOS33 [get_ports LED_OUT[7]]

set_property PACKAGE_PIN U2 [get_ports SEG_SELECT[0]]                    
    set_property IOSTANDARD LVCMOS33 [get_ports SEG_SELECT[0]]
set_property PACKAGE_PIN U4 [get_ports SEG_SELECT[1]]              
    set_property IOSTANDARD LVCMOS33 [get_ports SEG_SELECT[1]]
set_property PACKAGE_PIN V4 [get_ports SEG_SELECT[2]]     
    set_property IOSTANDARD LVCMOS33 [get_ports SEG_SELECT[2]]
set_property PACKAGE_PIN W4 [get_ports SEG_SELECT[3]]
    set_property IOSTANDARD LVCMOS33 [get_ports SEG_SELECT[3]]
   
   
# LEDS
set_property PACKAGE_PIN L1 [get_ports LIGHTS[15]]
    set_property IOSTANDARD LVCMOS33 [get_ports LIGHTS[15]]
set_property PACKAGE_PIN P1 [get_ports LIGHTS[14]]
    set_property IOSTANDARD LVCMOS33 [get_ports LIGHTS[14]]
set_property PACKAGE_PIN N3 [get_ports LIGHTS[13]]
    set_property IOSTANDARD LVCMOS33 [get_ports LIGHTS[13]]
set_property PACKAGE_PIN P3 [get_ports LIGHTS[12]]
    set_property IOSTANDARD LVCMOS33 [get_ports LIGHTS[12]]
set_property PACKAGE_PIN U3 [get_ports LIGHTS[11]]
    set_property IOSTANDARD LVCMOS33 [get_ports LIGHTS[11]]
set_property PACKAGE_PIN W3 [get_ports LIGHTS[10]]
    set_property IOSTANDARD LVCMOS33 [get_ports LIGHTS[10]]
set_property PACKAGE_PIN V3 [get_ports LIGHTS[9]]
    set_property IOSTANDARD LVCMOS33 [get_ports LIGHTS[9]]
set_property PACKAGE_PIN V13 [get_ports LIGHTS[8]]
    set_property IOSTANDARD LVCMOS33 [get_ports LIGHTS[8]]
set_property PACKAGE_PIN V14 [get_ports LIGHTS[7]]
    set_property IOSTANDARD LVCMOS33 [get_ports LIGHTS[7]]
set_property PACKAGE_PIN U14 [get_ports LIGHTS[6]]
    set_property IOSTANDARD LVCMOS33 [get_ports LIGHTS[6]]
set_property PACKAGE_PIN U15 [get_ports LIGHTS[5]]
    set_property IOSTANDARD LVCMOS33 [get_ports LIGHTS[5]]
set_property PACKAGE_PIN W18 [get_ports LIGHTS[4]]
    set_property IOSTANDARD LVCMOS33 [get_ports LIGHTS[4]]
set_property PACKAGE_PIN V19 [get_ports LIGHTS[3]]
    set_property IOSTANDARD LVCMOS33 [get_ports LIGHTS[3]]
set_property PACKAGE_PIN U19 [get_ports LIGHTS[2]]
    set_property IOSTANDARD LVCMOS33 [get_ports LIGHTS[2]]
set_property PACKAGE_PIN E19 [get_ports LIGHTS[1]]
    set_property IOSTANDARD LVCMOS33 [get_ports LIGHTS[1]]
set_property PACKAGE_PIN U16 [get_ports LIGHTS[0]]
    set_property IOSTANDARD LVCMOS33 [get_ports LIGHTS[0]]
    
# Switches
set_property PACKAGE_PIN R2 [get_ports SWITCHES[15]]
    set_property IOSTANDARD LVCMOS33 [get_ports SWITCHES[15]]
set_property PACKAGE_PIN T1 [get_ports SWITCHES[14]]
    set_property IOSTANDARD LVCMOS33 [get_ports SWITCHES[14]]
set_property PACKAGE_PIN U1 [get_ports SWITCHES[13]]
    set_property IOSTANDARD LVCMOS33 [get_ports SWITCHES[13]]
set_property PACKAGE_PIN W2 [get_ports SWITCHES[12]]
    set_property IOSTANDARD LVCMOS33 [get_ports SWITCHES[12]]
set_property PACKAGE_PIN R3 [get_ports SWITCHES[11]]
    set_property IOSTANDARD LVCMOS33 [get_ports SWITCHES[11]]
set_property PACKAGE_PIN T2 [get_ports SWITCHES[10]]
    set_property IOSTANDARD LVCMOS33 [get_ports SWITCHES[10]]
set_property PACKAGE_PIN T3 [get_ports SWITCHES[9]]
    set_property IOSTANDARD LVCMOS33 [get_ports SWITCHES[9]]
set_property PACKAGE_PIN V2 [get_ports SWITCHES[8]]
    set_property IOSTANDARD LVCMOS33 [get_ports SWITCHES[8]]
set_property PACKAGE_PIN W13 [get_ports SWITCHES[7]]
    set_property IOSTANDARD LVCMOS33 [get_ports SWITCHES[7]]
set_property PACKAGE_PIN W14 [get_ports SWITCHES[6]]
    set_property IOSTANDARD LVCMOS33 [get_ports SWITCHES[6]]
set_property PACKAGE_PIN V15 [get_ports SWITCHES[5]]
    set_property IOSTANDARD LVCMOS33 [get_ports SWITCHES[5]]
set_property PACKAGE_PIN W15 [get_ports SWITCHES[4]]
    set_property IOSTANDARD LVCMOS33 [get_ports SWITCHES[4]]
set_property PACKAGE_PIN W17 [get_ports SWITCHES[3]]
    set_property IOSTANDARD LVCMOS33 [get_ports SWITCHES[3]]
set_property PACKAGE_PIN W16 [get_ports SWITCHES[2]]
    set_property IOSTANDARD LVCMOS33 [get_ports SWITCHES[2]]
set_property PACKAGE_PIN V16 [get_ports SWITCHES[1]]
    set_property IOSTANDARD LVCMOS33 [get_ports SWITCHES[1]]
set_property PACKAGE_PIN V17 [get_ports SWITCHES[0]]
    set_property IOSTANDARD LVCMOS33 [get_ports SWITCHES[0]]