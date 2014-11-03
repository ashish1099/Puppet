# Ganeti Installation and setup.

class ganeti::packages inherits ganeti {

	yum::yum_repo { "ganeti" 	: reponame => 'CentOS-$releasever - Ganeti', baseurl => 'http://jfut.integ.jp/linux/ganeti/7/$basearch', gpgcheck => 0 } # End of OS
	yum::yum_repo { "elrepo" 	: reponame => 'CentOS-$releasever - ElRepo', baseurl => 'http://elrepo.org/linux/elrepo/el7/$basearch', gpgcheck => 0 } # End of OS

	package { [ "ganeti", "python-psutil", "python-simplejson", "python-bitarray", "bridge-utils", "pyOpenSSL", "lvm2", "socat", "libvirt", "qemu-kvm-tools", "qemu-kvm", 
		"seavgabios-bin", "curl", "drbd84-utils", "kmod-drbd84", "drbd84-utils-sysvinit", "perl" ] : ensure => present, require => Yum::Yum_repo["ganeti", "elrepo"] }

} # End of Ganeti::packages
