# HP RAID CONTROLLER SLOT 
# Added by Ashish Jaiswal
# Date : 27-03-2014

require 'facter'

Facter.add(:hp_controller_slot) do 
	setcode do
	if Facter.value(:manufacturer) == "HP"
		if File.exists?("/usr/sbin/hpacucli")
		if `rpm -qa hpacucli`.empty?
			%x{rpm -i http://repos:10000/downloads/hpacucli-9.40-12.0.x86_64.rpm > /dev/null && hpacucli ctrl all show | grep Slot | cut -d " " -f 6}.chop
		else
			%x{hpacucli ctrl all show | grep Slot | cut -d " " -f 6}.chop
		end
			end # End of /usr/sbin/hpacucli
		end # End of :manufacturer
	end # End of setcode
end # End of :hp_controller_slot
