Ganeti Puppet
=============

I have written a puppet manifest to automate the installation of ganeti, Using this will get the cluster up and running.

Currently it has configured with KVM hypervisor.
You have to add cluster_hostname and cluster_ipaddr in ganeti/manifest/init.pp
```class ganeti (
                $cluster_hostname = cluster.example.com ,
                $cluster_ipaddr = 192.168.1.5,
```

To start with add a entry like this in your site.pp or else to your appropriate ENC

Usage
-----

To setup a Master Node
`node ganeti01 { class { 'ganeti' : host_address => $fqdn, ip_address => "196.168.1.10", pv_name => ["/dev/sdb1"], master => true } }`

To setup a Secondary Node
```node ganeti02 { class { 'ganeti' : host_address => $fqdn, ip_address => "196.168.1.20", pv_name => ["/dev/sdb1"], master => false } }```


