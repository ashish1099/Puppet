# Install perl modules from cpan

class cpan {

	require basepackages	
	define cmie ( ) {
		$cpan_ver = $operatingsystemrelease ? { default => "cpan", "13.2" => "cpan13.2" }
		exec { "$name" : command => "cpanm --mirror http://repos:10000/perl/$cpan_ver/ --mirror-only $name", require => Package["make", "perl-App-cpanminus" ], unless => "perldoc -l $name" }
	} # End of cmie_cpan
} #End of perl
