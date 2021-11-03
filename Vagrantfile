# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  if Vagrant.has_plugin? "vagrant-vbguest"
    config.vbguest.no_install  = true
    config.vbguest.auto_update = false
    config.vbguest.no_remote   = true
  end

  #config.vm.define :clienteUbuntu do |clienteUbuntu|
    #clienteUbuntu.vm.box = "bento/ubuntu-20.04"
    #clienteUbuntu.vm.network :private_network, ip: "192.168.100.2"
    #clienteUbuntu.vm.hostname = "clienteUbuntu"
  #end

  #config.vm.define :servidorUbuntu do |servidorUbuntu|
    #servidorUbuntu.vm.box = "bento/ubuntu-20.04"
    #servidorUbuntu.vm.network :private_network, ip: "192.168.100.3"
    #servidorUbuntu.vm.provision "shell", path: "script.sh"
    #servidorUbuntu.vm.hostname = "servidorUbuntu"
  #end
  
  # Maquinas virtuales Miniproyecto1
  
  #Maquina virtual 1 - Load Balancer
  config.vm.define :virtualMachine1 do |virtualMachine1|
    virtualMachine1.vm.box = "bento/ubuntu-18.04"
    virtualMachine1.vm.network :private_network, ip: "192.168.100.4"
    virtualMachine1.vm.hostname = "virtualMachine1"
    virtualMachine1.vm.provision "shell", path: "scriptlb.sh"
  end
   
  #Maquina virtual 2 - web1
  config.vm.define :virtualMachine2 do |virtualMachine2|
    virtualMachine2.vm.box = "bento/ubuntu-18.04"
    virtualMachine2.vm.network :private_network, ip: "192.168.100.5"
    virtualMachine2.vm.hostname = "virtualMachine2"
    virtualMachine2.vm.provision "shell", path: "scriptvm02.sh"
  end
  
  #Maquina virtual 3 - web2
  config.vm.define :virtualMachine3 do |virtualMachine3|
    virtualMachine3.vm.box = "bento/ubuntu-18.04"
    virtualMachine3.vm.network :private_network, ip: "192.168.100.6"
    virtualMachine3.vm.hostname = "virtualMachine3"
    virtualMachine3.vm.provision "shell", path: "scriptvm03.sh"
  end

  
end


