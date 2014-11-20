# Perl version
# Added by Ashish Jaiswal
# Date : 24-02-2014

require 'facter'
Facter.add(:perl_local_version) do
  setcode do	
	Facter::Util::Resolution.exec('perl -v  | awk "NR==2{print $9}" | grep -o [0-9].[0-9][0-9].[0-9]')
    end
end
