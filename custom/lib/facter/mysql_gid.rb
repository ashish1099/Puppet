# Mysql GroupID for kernel tunning
# Added by Ashish Jaiswal
# Date : 07-11-2014

require 'facter'
Facter.add(:mysql_gid) do
  setcode do	
	if File.exists?("/usr/bin/mysql")
	Facter::Util::Resolution.exec('id -g mysql')
	end
    end
end
