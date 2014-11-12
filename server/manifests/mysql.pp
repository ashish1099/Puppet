# Mariadb server installation and configuration

class server::mysql(
		$innodb_buffer_pool_size,
		$key_buffer_size,
		$myisam_max_sort_file_size ) 
	inherits baseos {
	
	package { "mariadb" : ensure => present }
	file { "/etc/my.cnf" : ensure => present, content => template("server/mysql/cnf.erb"), require => Package["mariadb"] }

	exec { "setup_mysql" : command => "mysql_install_db --user=mysql --defaults-file=/etc/my.cnf", 
					require => [ File["/etc/my.cnf"], Package["mariadb"], Sysctl["vm.hugetlb_shm_group", "vm.nr_hugepages", "kernel.shmmax", "kernel.shmall"] ], 
					refreshonly => true, 
					subscribe => File["/etc/my.cnf"],
					notify => Baseos::Services::Daemons[mysql] }

	$args=1
	$shmmax_variable = inline_template("<%= $args*1024*1024*1024	%>")
	$shmall_variable = inline_template("<%= $shmmax_variable/4096	%>")
	$huge_variable   = inline_template("<%= $args*1024*1024/2048	%>")
	
	# Server Tunning
	sysctl { "vm.hugetlb_shm_group"	:	val => $mysql_gid }
	sysctl { "vm.nr_hugepages"	:	val => $huge_variable }
	sysctl { "kernel.shmmax"	:	val => $shmmax_variable }
	sysctl { "kernel.shmall"	:	val => $shmall_variable }

        baseos::local_line { 'mysql_soft' :     file => "/etc/security/limits.conf", line => '@mysql           soft    memlock         unlimited' }
        baseos::local_line { 'mysql_hard' :     file => "/etc/security/limits.conf", line => '@mysql           hard    memlock         unlimited' }

	baseos::services::daemons { 'mysql' :  service_ensure => running, service_enable => true, service_require => "Package['mariadb']" }

} # End of server::mysql
