---
title: linux git server 구축
date: 2023-03-06 15:04:00 +0900
categories: [server]
tags: [linux git server]
published: true
---

## 조건

- 이미 제공 받은 계정이 있음: user01
- OS: Amazon Linux
- ssh 접속
- 하나의 계정으로 여러 개발자들이 사용(config git name/email은 각각 설정)

## ssh 설정

### local에서 git-bash 설치 후, 다음 명령어로 키 생성

```shell
ssh-keygen
```

두 개의 파일이 생기는데 id_rsa(개인키), id_rsa.pub(공용키) 공용키를 서버에 업로드

### server에서 .ssh 폴더 생성

```shell
mkdir ~/.ssh
```

### 업로드한 공용키를 등록

cat id_rsa.pub >> ~/.ssh/authorized_keys

> ssh 연결 설정은 끝

## git 설치

```shell
sudo yum install git
```

## 저장소 만들기

```shell
sudo mkdir -p /git
sudo chown -R user01:user01 /git/
cd /git
git init --bare sample.git
```

## local에서 저장소 생성 및 remote push

```shell
md sample
cd sample
git init
git remote add origin ssh://user01@{서버주소}:{포트}/git/sample.git
git push -u origin master
```

## git clone

```shell
git clone ssh://user01@{서버주소}:{포트}/git/sample.git
git config user.name "이름"
git config user.email "이메일"
```
