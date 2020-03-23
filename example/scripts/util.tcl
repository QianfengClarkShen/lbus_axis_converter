proc addip {ipName displayName} {
	set vlnv_version_independent [lindex [get_ipdefs -all -filter "NAME == $ipName"] end]
	return [create_bd_cell -type ip -vlnv $vlnv_version_independent $displayName]
}
