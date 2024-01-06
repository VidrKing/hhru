#export GITLAB_HOME=/srv/gitlab
#docker stop gitlab
#docker rm gitlab
#docker run --detach \
#  --hostname vidrking.ru \
#  --publish 443:443 --publish 80:80  \
#  --name gitlab \
#  --restart always \
#  --volume $GITLAB_HOME/config:/etc/gitlab \
#  --volume $GITLAB_HOME/logs:/var/log/gitlab \
#  --volume $GITLAB_HOME/data:/var/opt/gitlab \
#  --shm-size 256m \
#  gitlab/gitlab-ce:latest
#docker-compose build
#docker-compose up -d
#docker stop sameersbn/gitlab
#docker rm sameersbn/gitlab
#docker pull sameersbn/gitlab
#docker run sameersbn/gitlab


#sudo apt-get update
#sudo apt-get install -y curl openssh-server ca-certificates tzdata perl
#curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash
#sudo GITLAB_ROOT_PASSWORD="0000" EXTERNAL_URL="http://vidrking.ru" apt install gitlab-ce

docker ps
sudo docker-compose up
docker ps