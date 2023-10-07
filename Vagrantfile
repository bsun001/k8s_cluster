
VAGRANTFILE_API_VERSION = "2"


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # General Vagrant VM configuration.

  config.vm.box = "centos/8"

  config.ssh.insert_key = false

  config.vm.synced_folder ".", "/vagrant", disabled: true
  
  config.vbguest.auto_update = false


# KubeMaster

 config.vm.define "kubemaster" do |master|

   master.vm.hostname = "kubemaster"
   
   master.vm.network :forwarded_port, guest: 22, host: 2201, id: "ssh"

   master.vm.network :private_network, ip: "192.168.56.101"

   master.vm.provider :virtualbox do |v|

     v.memory = 2048
     v.cpus = 2
     v.linked_clone = true

   end

 end



# Worker1

 config.vm.define "worker1" do |node|

   node.vm.hostname = "worker1"
   
   node.vm.network :forwarded_port, guest: 22, host: 2202, id: "ssh"

   node.vm.network :private_network, ip: "192.168.56.102"

   node.vm.provider :virtualbox do |v|

     v.memory = 2048
     v.cpus = 2
     v.linked_clone = true

   end


 end



# Worker2

 config.vm.define "worker2" do |node|

   node.vm.hostname = "worker2"
   
   node.vm.network :forwarded_port, guest: 22, host: 2203, id: "ssh"

   node.vm.network :private_network, ip: "192.168.56.103"

   node.vm.provider :virtualbox do |v|

     v.memory = 2048
     v.cpus = 2
     v.linked_clone = true

   end

 end

end