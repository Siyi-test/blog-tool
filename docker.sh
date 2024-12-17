sudo yum install -y yum-utils
if [ $? -ne 0 ]; then
  echo "yum-utils install failed"
  exit 1
fi
echo "Configuring docker Alibaba Cloud image... "
sudo yum-config-manager \
  --add-repo \
  https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
if [ $? -ne 0 ]; then
  echo "Docker image warehouse configuration failed"
  exit 1
fi
echo "Updating yum package index..."
sudo yum makecache fast
if [ $? -ne 0 ]; then
  echo "yum package index update failed"
  exit 1
fi
echo "Installing docker..."
sudo yum install docker-ce docker-ce-cli containerd.io
if [ $? -ne 0 ]; then
  echo "Docker installation failed"
  exit 1
fi
echo "Starting docker..."
sudo systemctl start docker
if [ $? -ne 0 ]; then
  echo "Docker failed to start "
  exit 1
else
  echo "Docker launched successfully"
fi
echo "Setting docker to boot automatically..."
sudo systemctl enable docker
if [ $? -ne 0 ]; then
  echo "Docker failed to set up self-boot"
  exit 1
fi
sudo mkdir -p /etc/docker
if [ $? -ne 0 ]; then
  echo "mkdir -p /etc/docker failed"
  exit 1
fi
sudo tee /etc/docker/daemon.json <<-'EOF'
{
    "registry-mirrors": [
        "https://registry.docker-cn.com",
        "http://hub-mirror.c.163.com",
        "https://dockerhub.azk8s.cn",
        "https://mirror.ccs.tencentyun.com",
        "https://registry.cn-hangzhou.aliyuncs.com",
        "https://docker.mirrors.ustc.edu.cn",
        "https://docker.m.daocloud.io",
        "https://noohub.ru",
        "https://huecker.io",
        "https://dockerhub.timeweb.cloud",
        "https://hub.atomgit.com/repos",
        "https://docker.1panel.live",
        "https://hub.rat.dev"
    ]
}
EOF
if [ $? -ne 0 ]; then
  echo "tee /etc/docker/daemon.json failed"
  exit 1
fi
sudo systemctl daemon-reload
if [ $? -ne 0 ]; then
  echo "systemctl daemon-reload failed"
  exit 1
fi
sudo systemctl restart docker
if [ $? -ne 0 ]; then
  echo "systemctl restart docker failed"
  exit 1
fi