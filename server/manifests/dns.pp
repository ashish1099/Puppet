# Server::dns

class server::dns { 
	
	package { "bind" : ensure => present }
	service { "named.service" : ensure => running, enable => true }

	define conf (
			$directory 		= "/var/lib/named",
			$managed_keys_directory = "/var/lib/named/dyn/",
			$dump_file	 	= "/var/log/named_dump.db",
			$statistics_file 	= "/var/log/named.stats",
			$forwarders		= [],
			$forward		= "only",
			$listen_on_v6		= "none",
			$zones			= {},
			$revip			= undef,
			$ns_addr		= undef,
			$ns_ipaddr		= undef, ) {

	File { ensure => present, require => Package["bind"], notify => Service["named.service"] }

	# Configuration files
	file { $name : ensure => present, content => template("server/dns/named_conf.erb") }	
	file { "/etc/named.d/rndc-access.conf" : ensure => present }
	
	# Zone files
	$master_dir = "/var/lib/named/master"

	} # End of server::dns::conf defination

#TODO
#	# serial => 2014072901
#	define zone_conf (
#			$ttl 			= "1d",
#			$serial			= '', 
#			$refresh		= "3h",
#			$retry			= "1h",
#			$expiry			= "1w",
#			$minimum		= "1d",
#			$root			= "root.$dns_domain.com"
#			$dns_domain		= '',
#			$reverse		= false,
#			) {
#	
#	file { $name : ensure => present, content => template("server/dns/zones.erb") }
#	} # End of zone_conf
#
#	zone_conf { '/var/lib/named/master/example.com' : serial => "2014072901", dns_domain => $hostaddress
	# Root Zone
	conf { '/etc/named.conf' :
			ns_ipaddr	=> $ipaddress,
			forwarders 	=> ["8.8.8.8; 208.67.222.222"],
			zones 		=> { 
			'.' 			=> [ 'type hint', 'file "root.hint"'],
			# Forward Zone
			'localhost'	 	=> [ 'type master', 'file "localhost.zone"'],
			'example.com' 		=> [ 'type master', 'file "master/king.com"'],
			# Reverse Zone
			'0.0.127.in-addr.arpa' => [ 'type master', 'file "127.0.0.zone"'],
			'1.1.196.in-addr.arpa' => [ 'type master', 'file "master/db.com.king"'],
			 } # End of Zones
		} # End of conf 
} # End of DNS
