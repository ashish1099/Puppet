# Ganeti Installation and setup.

class ganeti ( 
		$cluster_hostname, 
		$cluster_ipaddr, 
		$master = false, 
		$host_address, 
		$ip_address, 
		$pv_name = undef, 
		$vg_name = "xenvg" ) {

	require yum
	include ganeti::packages,
		ganeti::nodes,

	if $master {
	# Initialize Cluster
		exec { "cluster_init" : 
			command => "gnt-cluster init --vg-name $vg_name --master-netdev eth0 --enabled-hypervisors kvm --nic-parameters link=br0 -H kvm:kernel_path= $cluster_hostname",
			unless => "gnt-cluster verify", 
			require => [ Interfaces::Bridge_interface["br0"], Exec["modprobe"], File["/root/.ssh", "/etc/modprobe.d/drbd.conf"] ]
		}
	} # End of master

	# Services which should run
        baseos::services::daemons { 'libvirtd' 		: service_ensure => running, service_enable => true, service_require => "Package['libvirt']" }
        baseos::services::daemons { 'ganeti'   		: service_ensure => running, service_enable => true, service_require => "Package['ganeti']" }
        baseos::services::daemons { 'ganeti-rapi' 	: service_ensure => running, service_enable => true, service_require => "Package['ganeti']" }
        baseos::services::daemons { 'ganeti-confd'	: service_ensure => running, service_enable => true, service_require => "Package['ganeti']" }
        baseos::services::daemons { 'ganeti-luxid'	: service_ensure => running, service_enable => true, service_require => "Package['ganeti']" }
        baseos::services::daemons { 'ganeti-noded' 	: service_ensure => running, service_enable => true, service_require => "Package['ganeti']" }
        baseos::services::daemons { 'ganeti-wconfd' 	: service_ensure => running, service_enable => true, service_require => "Package['ganeti']" }
        baseos::services::daemons { 'ganeti-kvmd' 	: service_ensure => running, service_enable => true, service_require => "Package['ganeti']" }

	file { "/etc/modprobe.d/drbd.conf" : ensure => present, source => "puppet:///modules/ganeti/drbd.conf" }
	file { "/etc/modules-load.d/drbd.conf" : ensure => present, content => "drbd" }
	file { "/root/.ssh" : ensure => directory }
	file_line { 'add_drbd' : path => "/etc/lvm/lvm.conf", line => '    filter = ["r|/dev/cdrom|", "r|/dev/drbd[0-9]+|" ]', match => '/dev/cdrom' }
	exec { "modprobe" : command => "modprobe drbd", require => [ Package["kmod-drbd84"], File["/etc/modprobe.d/drbd.conf"] ] }
	
      	# Configure eth0 
        interfaces::physical_interface { "eth0" : mac_address => $macaddress_eth0, bootproto => "none", bridge => "br0" }

	# Configure br0
        interfaces::bridge_interface { "br0" : ipaddr => $ip_address, netmask => "255.255.255.0", bootproto => static, require => Interfaces::Physical_interface["eth0"] }

} # End of Ganeti
