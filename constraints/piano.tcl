# Pin assignments (Quartus Prime Tcl script)
# Usage:  quartus_sh -t pin_assignments.tcl
#   or in Quartus: Tools > Tcl Scripts... > select this file > Run
#
# Change PROJECT_NAME to match your .qpf project name.

load_package project

set PROJECT_NAME "your_project_name"

if {[is_project_open]} {
    set opened_here 0
} else {
    project_open $PROJECT_NAME
    set opened_here 1
}

# { node_name  pin_location }
set pin_list {
    {hex1[0]   PIN_G18}
    {hex1[1]   PIN_F22}
    {hex1[2]   PIN_E17}
    {hex1[3]   PIN_L26}
    {hex1[4]   PIN_L25}
    {hex1[5]   PIN_J22}
    {hex1[6]   PIN_H22}

    {hex2[0]   PIN_M24}
    {hex2[1]   PIN_Y22}
    {hex2[2]   PIN_W21}
    {hex2[3]   PIN_W22}
    {hex2[4]   PIN_W25}
    {hex2[5]   PIN_U23}
    {hex2[6]   PIN_U24}

    {keys[0]   PIN_AF21}
    {keys[1]   PIN_AC22}
    {keys[2]   PIN_AE21}
    {keys[3]   PIN_AF15}
    {keys[4]   PIN_AF16}
    {keys[5]   PIN_AE15}
    {keys[6]   PIN_AE16}
    {keys[7]   PIN_Y16}

    {rawclk    PIN_Y2}
    {speaker   PIN_AE25}
}

foreach entry $pin_list {
    set node [lindex $entry 0]
    set pin  [lindex $entry 1]

    # Location
    set_location_assignment $pin -to $node

    # I/O standard (2.5 V for all pins)
    set_instance_assignment -name IO_STANDARD "2.5 V" -to $node
}

# Current strength / slew rate are left at their defaults (8mA, slew 2),
# so no explicit assignments are needed. To set them explicitly, uncomment:
# foreach entry $pin_list {
#     set node [lindex $entry 0]
#     set_instance_assignment -name CURRENT_STRENGTH_NEW "8MA" -to $node
# }

export_assignments

if {$opened_here} {
    project_close
}

puts "Pin assignments applied successfully."
