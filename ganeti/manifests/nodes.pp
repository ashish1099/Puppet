# Managing ganeti nodes

class ganeti::nodes inherits ganeti {

	# remove ALL unmanaged host resources
	resources { 'host': purge => true }
		
	# Get hostname only
	$host_address_alias = regsubst($host_address,'^(\w+)\.(\D+)\.(\D+)\.(\D+)$','\1')

	# Apply proper hostname and ipaddress
	host { $host_address : ip => $ip_address, host_aliases => $host_address_alias }
	
	# LVM Setup
	physical_volume { $pv_name : ensure => present }
	volume_group { $vg_name : ensure => present, physical_volumes => $pv_name }

	# Some common IPs and Hostnames across ganeti nodes
	host { $cluster_hostname : ip => $cluster_ipaddr, host_aliases => regsubst($cluster_hostname,'^(\w+)\.(\D+)\.(\D+)\.(\D+)$','\1') }
	host { 'localhost.localdomain' : ip => "127.0.0.1", host_aliases => "localhost" }

} # End of ganeti::nodes
