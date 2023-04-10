Vagrant.configure("2") do |config|
  config.vm.box = "almalinux/9"

  config.vm.provision :shell, inline: <<-EOF
    systemctl enable firewalld
    systemctl start firewalld

    dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    dnf -y install docker-ce docker-ce-cli containerd.io

    # Dockerからのiptables操作をオフに
    cat << EOS | tee /etc/docker/daemon.json
{
  "iptables": false
}
EOS

    chmod 600 /etc/docker/daemon.json

    # Dockerから外向きの通信をすべて許可
    firewall-cmd --direct --permanent \
      --add-rule ipv4 nat POSTROUTING 1 ! -o docker0 -s 172.17.0.0/16 -j MASQUERADE

    # Dockerから185.199.0.0/16への通信をDROP
    # テストのためGitHub Pagesでホストされているmizzy.orgへのアクセスをDROP
    firewall-cmd --direct --permanent \
      --add-rule ipv4 filter FORWARD 1 -i docker0 -d 185.199.0.0/16 -j DROP

    firewall-cmd --reload

    systemctl enable docker
    systemctl start docker
  EOF
end
