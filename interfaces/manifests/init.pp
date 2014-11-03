# Bonding configuration

class interfaces {

	# Physical Interface setup	
        define physical_interface( 
				$mac_address, 
				$master = false, 
				$bridge = false, 
				$ipaddr = false, 
				$netmask = false, 
				$bootproto ) {
		file { "/etc/sysconfig/network-scripts/ifcfg-$name" : 
				ensure => present,
				content => template('interfaces/ifcfg-eth.erb')
			}
	} # End of physical_interface

	# Bonding interface setup
	define bonding_interface( 
				$bond_network, 
				$bond_netmask, 
				$bond_ipaddr, 
				$bond_options = 'mode=4 miimon=100' ) {
		file { "/etc/sysconfig/network-scripts/ifcfg-$name" :
			ensure => present,
			content => template('interfaces/ifcfg-bond.erb')
			}
		notify { "bond_notify" : message => "Please restart Network service to setup $name interface, Currently it is not managed by puppet"}
	} # End of bonding_interface

        define bridge_interface( 
				$bootproto, 
				$ipaddr, 
				$netmask ) {
                file { "/etc/sysconfig/network-scripts/ifcfg-$name" :
                        ensure => present,
                        content => template('interfaces/ifcfg-br.erb')
                        }
		exec { "bridge_up" : command => "ifup $name", onlyif => "ip addr show $name | grep DOWN", require => File["/etc/sysconfig/network-scripts/ifcfg-$name"] }
                notify { "bridge_notify" : message => "Please restart Network service to setup $name interface, Currently it is not managed by puppet"}
        } # End of bridge_interface

	# Physical
	physical_interface { "eth0" : mac_address => $macaddress_eth0, master => "bond0", bootproto => "none" }
	physical_interface { "eth1" : mac_address => $macaddress_eth1, master => "bond0", bootproto => "none" }
}
