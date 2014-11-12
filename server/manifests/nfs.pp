# NFS setup

class server::nfs {

	case $operatingsystem {
		"Ubuntu" : { package { ["nfs-common"] : ensure => present }	}
		'OpenSuSE' : { package { ['nfs-client','nfs-kernel-server','nfswatch'] : ensure => present }  }
		'CentOS' : { package { ['nfs4-acl-tools', 'nfs-utils-lib'] : ensure => present } }
		}

	define fstab_mount ( $source = '', $mount_check = "mounted", $mount_options = "rw,bg,noatime,nodiratime,acregmax=30,acdirmin=15,acdirmax=30,nfsvers=3" ) {
		file { $name : ensure => directory, notify => Mount[$name] }
		mount { $name :
			device => $source,
			fstype => "nfs", dump => 0, pass => 0, options => $mount_options,
	                atboot => true, ensure => $mount_check, 
			require => $::operatingsystem ? {
                        'OpenSuSE' => [ Package[nfs-client], Baseos::Services::Daemons[rpcbind] ],
                        'CentOS'   => [ Package[nfs-utils], Baseos::Services::Daemons[rpcbind] ],
                        'Ubuntu'   => Package[nfs-common],
			}
		}
	} # End of fstab_mount

	file { "/etc/nfsmount.conf" : ensure => present, source => "puppet:///modules/server/nfs/nfsmount.conf", mode => 644 }

	# Valid check can be "unmounted", "absent"
	# ex.  fstab_mount { "/archive" 		: source => "nfs-server01:/archive", check => "absent" }

	if $operatingsystem == "OpenSuSE" { 
		fstab_mount { "/nfsshare01"		: source => "nfs-server02:/nfsshare01" }
	}

	if $operatingsystem == "CentOS" { 	
		fstab_mount { "/nfsshare02"		: source => "nfs-server02:/nfsshare02" }
	}
	
	if $operatingsystem == "Ubuntu" {
		fstab_mount { "/nfsshare03"		: source => "nfs-server03:/nfsshare03",	mount_options => "rw,bg" }
	} # End of Ubuntu

} # End of server::nfs
