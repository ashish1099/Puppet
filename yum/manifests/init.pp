# Depoying local repository of all operating system.

class yum {	

define yum_repo( 
		$baseurl, $reponame, $type = false, $mirrorlist = false, $gpgkey = false, $failovermethod = false, $gpgcheck = 1 ) {
	
		$repo_filepath = $operatingsystem ? { 'OpenSuSE' => "/etc/zypp/repos.d/$name.repo", 'CentOS' => "/etc/yum.repos.d/$name.repo" } 
		$repo_update = $operatingsystem ? { 'OpenSuSE' => "zypper_update", 'CentOS' => "yum_update" }
		file { $repo_filepath : ensure => present, content => template("yum/repo_$operatingsystem.erb"), mode => 644, notify => Exec[$repo_update] }
} # End of yum_repo

case $operatingsystem {

"OpenSUSE" : { 	
	$repodir = "/etc/zypp/repos.d"
	$repofile = "$repodir/$name.repo"
	$update_command = 'zypper update --auto-agree-with-licenses --no-confirm' 		

        file { $repodir : source => "puppet:///modules/yum/empty", recurse => true, purge => true, force => true }
	exec { "zypper_update" : command => $update_command, unless => "test -f $repofile", require => File[$repodir] }

	case $operatingsystemrelease 	{			
		"13.1" : { 
		yum_repo { "oss" 	: baseurl => "ftp://ftp5.gwdg.de/pub/linux/suse/opensuse/distribution/13.1/repo/oss/", reponame => "openSuSE 13.1 OSS", 
							type => 'yast2' }
		yum_repo { "non-oss" 	: baseurl => "ftp://ftp5.gwdg.de/pub/linux/suse/opensuse/distribution/13.1/repo/non-oss/", reponame => "openSuSE 13.1 Non-OSS",	
							type => 'yast2' }
			} # End of 13.1
	} # End of systemrelease
} # End of OpenSUSE
	
"CentOS" : {
	$repodir = "/etc/yum.repos.d"
	$repofile = "$repodir/$name.repo"
	$update_command = 'yum -y update'  

        file { $repodir : source => "puppet:///modules/yum/empty", recurse => true, purge => true, force => true }
	exec { "yum_update" : command => $update_command, timeout => 0, unless => "test -f $repofile", require => File[$repodir] }

	case  $operatingsystemrelease {
		"6.5" : {
		yum_repo { "os"		: reponame => 'CentOS-$releasever - Base', baseurl => 'http://repos:10000/centos6.5/os/$basearch',  
							gpgkey => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6' 	} # End of OS

		yum_repo { "updates" 	: reponame => 'CentOS-$releasever - Updates', baseurl => 'http://repos:10000/centos6.5/updates/$basearch', 		
							gpgkey => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6' } # End of Updates

		yum_repo { "extras" 	: reponame => 'CentOS-$releasever - Extras', baseurl => 'http://repos:10000/centos6.5/extras/$basearch', 
							gpgkey => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6'	} # End of extras

		yum_repo { "epel" 	: reponame => 'Extra Packages for Enterprise Linux 6 - $basearch', baseurl => 'http://repos:10000/fedora/epel/6/$basearch', 
							gpgkey => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6', failovermethod => "priority" } # End of EPEL		
			} # End of 6.5

		"7.0.1406" : {
		yum_repo { "os" 	: reponame => 'CentOS-$releasever - Base', baseurl => 'ftp://ftp5.gwdg.de/pub/linux/centos/7.0.1406/os/$basearch', i
							gpgkey => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7' 	} # End of OS

		yum_repo { "updates" 	: reponame => 'CentOS-$releasever - Updates', baseurl => 'ftp://ftp5.gwdg.de/pub/linux/centos/7.0.1406/updates/$basearch', 
							gpgkey => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7' } # End of Updates

		yum_repo { "extras" 	: reponame => 'CentOS-$releasever - Extras', baseurl => 'ftp://ftp5.gwdg.de/pub/linux/centos/7.0.1406/extras/$basearch', 
							gpgkey => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7'	} # End of extras

		yum_repo { "epel" 	: reponame => 'Extra Packages for Enterprise Linux 7 - $basearch', baseurl => 'http://ftp.riken.jp/Linux/fedora/epel/7/$basearch', 
							gpgkey => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7', failovermethod => "priority" } # End of EPEL		
			} # End of 7.0
				} # End of systemrelease
			} #End of CentOS
	} # End of Operatingsystem
} # End of yum class
