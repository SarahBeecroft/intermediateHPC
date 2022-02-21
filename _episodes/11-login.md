---
title: "Logging on to the server"
teaching: 5
exercises: 10
questions:
objectives:
- Get setup on the server
---

### Logging on to the server
Your user name (s-NUMBER) and password will be supplied, along with the IP address of the server. Within a terminal window, use the ssh command to connect. 

```bash
ssh s-NUMBER@146.XXX.XX.XX
```

Enter your password when prompted. If asked to accept any credentials, type `yes` and hit enter

If you are unable to login, please first check your password was typed correctly. If you are still unable to login, please ask for assistance.


### Downloading the lesson material
There are some materials for the lessons which are hosted on github. In order to access those on Zeus, you will need to clone the git repo, then change directory. You can list the contents of the directory with `ls`

```bash
cd /mnt/s-ws/s-NUMBER
git clone https://github.com/SarahBeecroft/intermediateHPC.git
cd intermediateHPC/exercises
ls
```
