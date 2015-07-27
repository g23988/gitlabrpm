#!/bin/bash

yum install curl openssh-server postfix cronie
service postfix start
chkconfig postfix on
lokkit -s http -s ssh





major_version='6'
os='centos'
host='localhost'
yum install -d0 -e0 -y curl
#Package curl-7.19.7-40.el6_6.4.x86_64 already installed and latest version

yum_repo_path=/etc/yum.repos.d/gitlab_gitlab-ce.repo
yum_repo_config_url="https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/config_file.repo?os=${os}&dist=${major_version}&name=${host}&source=script"
#https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/config_file.repo?os=centos&dist=6&name=localhost&source=script

curl -f "${yum_repo_config_url}" > $yum_repo_path

yum install -y pygpgme --disablerepo='gitlab_gitlab-ce'
pypgpme_check=`rpm -qa | grep -qw pygpgme`

yum install -y yum-utils --disablerepo='gitlab_gitlab-ce'
yum_utils_check=`rpm -qa | grep -qw yum-utils`

yum -q makecache -y --disablerepo='*' --enablerepo='gitlab_gitlab-ce'

:<<eof
這是當下那個url的資訊
[gitlab_gitlab-ce]
name=gitlab_gitlab-ce
baseurl=https://packages.gitlab.com/gitlab/gitlab-ce/el/6/$basearch
repo_gpgcheck=1
gpgcheck=0
enabled=1
gpgkey=https://packages.gitlab.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt

[gitlab_gitlab-ce-source]
name=gitlab_gitlab-ce-source
baseurl=https://packages.gitlab.com/gitlab/gitlab-ce/el/6/SRPMS
repo_gpgcheck=1
gpgcheck=0
enabled=1
gpgkey=https://packages.gitlab.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
eof

yum install gitlab-ce

gitlab-ctl reconfigure

