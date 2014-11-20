require 'facter'

if Facter.value(:kernel) == "Linux"
	raidcontroller_num = -1
	raidcontroller_list = []
	Facter::Util::Resolution.exec('lspci').split("\n").each do |l|
		if l =~ /^\d{2}:\d{2}.\d{1} RAID bus controller: (.*)$/
		raidcontroller_num += 1
		raidcontroller_list[raidcontroller_num] = $1 unless raidcontroller_num == -1
		end
	end

	Facter.add(:raidcontrollercount) do
	confine :kernel => :linux
	setcode do
		if raidcontroller_list.length != 0
		raidcontroller_list.length.to_s
		end
	   end
	end

	raidcontroller_list.each_with_index do |desc, i|
	if desc =~ /^Hewlett-Packard(.*)$/
		if `rpm -qa hpacucli`.empty?
			%x{rpm -i http://repos:10000/downloads/hpacucli-9.40-12.0.x86_64.rpm > /dev/null}
		else
		Facter.add(:ssd)  do 
		setcode do
		output =  Facter::Util::Resolution.exec("hpacucli ctrl slot=#{Facter.value(:hp_controller_slot)} pd all show detail")
			if output
			lines = output.split("\n")
			next "ssd"  if lines.any? {|l| l =~ /Solid State SATA/ }
			end
		   end
	     end
		end
	end # End of HP
	
	if desc =~ /^LSI Logic(.*)$/
		if `rpm -qa MegaCli`.empty?
			%x{rpm -i http://repos:10000/downloads/MegaCli-8.07.14-1.noarch.rpm 2>/dev/null }
		else
		Facter.add(:ssd) do
		setcode do
		output = Facter::Util::Resolution.exec("MegaCli64 -PDList -aALL")
			if output
			lines = output.split("\n")
			next "ssd" if lines.any? {|l| l =~ /Solid State Device/ }
			end
		    end
		end
	    end
	end # End of LSI

	Facter.add("raidcontroller#{i}") do
	confine :kernel => :linux
		setcode do
			desc
		end
	end

	end # End of raidcontroller_list.each_with_index
	
	Facter.add(:is_ssd) do
		setcode do 
		harddisk_types = %w{ssd}
		if harddisk_types.include? Facter.value(:ssd)
			"true"
		else
	   		"false"
		end
	    end
	end 
end
