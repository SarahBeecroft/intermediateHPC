---
title: "Share files with the host"
teaching: 5
exercises: 15
questions:
objectives:
- Mount host directories in a container
keypoints:
- By default Singularity mounts the host current directory, and uses it as the container working directory
- Map additional host directories in the containers with the flag `-B`, or the variable SINGULARITY_BINDPATH
---


### Access to directories in the host machine

What directories can we access from the container?

First, let us assess what the content of the root directory `/` looks like from outside *vs* inside the container, to highlight the fact that a container runs on his own filesystem:

```bash
ls /
```

```output
bin  boot  dev  etc  home  lib  lib64  mnt  opt  pe  proc  root  run  sbin  scratch  selinux  software  srv  sys  tmp  usr  var

```

Now let's look at the root directory when we're in the container

```bash
singularity exec docker://ubuntu:16.04 ls /
```

```output
bin  boot  data  dev  environment  etc	home  lib  lib64  media  mnt  opt  proc  root  run  sbin  singularity  srv  sys  tmp  usr  var
```

## In which directory is the container running?
For reference, let's check the host first:

```bash
pwd
```

```output
/scratch/courses/cou001/intermediateHPC/exercises/intro_singularity
```

Now let's inspect the container.  (**Hint**: you need to run `pwd` in the container)

```bash
singularity exec docker://ubuntu:16.04 pwd
```

```output
/scratch/pawsey0001/sbeecroft/intermediateHPC/exercises/intro_singularity
```
Host and container working directories match!

By default on Setonix, Singularity mounts the host current directory, and uses it as the container working directory. So your $PWD is always accessible inside the container on Setonix. You can also read and write files in the $PWD. However, if you need to read/write files that are located somewhere other than $PWD, you need to use **bind mounting**. 


## Worked example
Try and create a file called `example` in the container root directory.  (**Hint**: run `touch /example` inside the container).

```bash
singularity exec docker://ubuntu:16.04 touch /example
```

```output
touch: cannot touch '/example': Read-only file system
```

To summarise: a container ships an application and its dependencies by encapsulating them in an isolated, read-only filesystem.  In order for a container to access directories from the host filesystem (and write files), one needs to explicitly bind mount them.  The main exception here is the current work directory, which is bind mounted by default.


### Bind mounting host directories

Singularity has the runtime flag `--bind`, `-B` in short, to mount host directories.

There is a long syntax, which allows to map the host dir onto a container dir with a different name/path, `-B hostdir:containerdir`.  
There is also a short syntax, that just mounts the dir using the same name and path: `-B hostdir`.

Let's use the latter syntax to mount a directory into the container and re-run `ls`.

```
singularity exec -B $MYSCRATCH/intermediateHPC/_episodes docker://ubuntu:16.04 ls $MYSCRATCH/intermediateHPC/_episodes
```


```
11-setonix_login.md  12-singularity-intro.md  13-modules.md  14-singularity-intro.md	15-sharing-files.md
```


Also, we can write files in a host dir which has been bind mounted in the container:

```bash
singularity exec -B $MYSCRATCH/intermediateHPC/_episodes docker://ubuntu:16.04 touch $MYSCRATCH/intermediateHPC/_episodes/example.txt
singularity exec -B $MYSCRATCH/intermediateHPC/_episodes docker://ubuntu:16.04 ls $MYSCRATCH/intermediateHPC/_episodes/
```

```output
/home/ubuntu/singularity-containers/_episodes/example.txt
```

Now we are talking!

If you need to mount multiple directories, you can either repeat the `-B` flag multiple times, or use a comma-separated list of paths, *i.e.*

```bash
-B dir1,dir2,dir3
```

Also, if you want to keep the runtime command compact, you can equivalently specify directories to be bind mounted using the environment variable `SINGULARITY_BINDPATH`:

```bash
export SINGULARITY_BINDPATH="dir1,dir2,dir3"
```
