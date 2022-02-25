---
title: "Share files with the host"
teaching: 5
exercises: 15
questions:
objectives:
- Mount host directories in a container
- Pass specific variables to the container
- Run a real-world bioinformatics application in a container
keypoints:
- By default Singularity mounts the host current directory, and uses it as the container working directory
- Map additional host directories in the containers with the flag `-B`, or the variable SINGULARITY_BINDPATH
- By default Singularity passes all host variables to the container
- Pass specific shell variables to containers by prefixing them with SINGULARITYENV_
---


### Access to directories in the host machine

What directories can we access from the container?

First, let us assess what the content of the root directory `/` looks like from outside *vs* inside the container, to highlight the fact that a container runs on his own filesystem:

```
ls /
```
{: .bash}

```
askapbuffer  bin   dev  group  lib    media  opt     proc  run   scratch  srv  tempddn  usr  xcatpost astro boot  etc  home   lib64  mnt    pawsey  root  sbin  selinux  sys  tmp      var
```
{: .output}


Now let's look at the root directory when we're in the container

```
singularity exec docker://ubuntu:16.04 ls /
```
{: .bash}

```
bin  boot  data  dev  environment  etc	home  lib  lib64  media  mnt  opt  proc  root  run  sbin  singularity  srv  sys  tmp  usr  var
```
{: .output}


> ## In which directory is the container running?
>
> For reference, let's check the host first:
>
> ```
> pwd
> ```
> {: .bash}
>
> ```
> /scratch/pawsey0001/sbeecroft/intermediateHPC/exercises/intro_singularity
> ```
> {: .output}
>
> Now inspect the container.  (**Hint**: you need to run `pwd` in the container)
>
> > ## Solution
> >
> > ```
> > singularity exec docker://ubuntu:16.04 pwd
> > ```
> > {: .bash}
> >
> > ```
> > /scratch/pawsey0001/sbeecroft/intermediateHPC/exercises/intro_singularity
> > ```
> > {: .output}
> >
> > Host and container working directories match!
> {: .solution}
{: .challenge}


> ## Can we see the content of the current directory inside the container?
>
> Hopefully yes ...
>
> > ## Solution
> >
> > ```
> > singularity exec docker://ubuntu:16.04 ls
> > ```
> > {: .bash}
> >
> > ```
> > python_3-slim.sif  sbatch_pull_big_images.sh  sif_lib  ubuntu_16.04.sif
> > ```
> > {: .output}
> >
> > Indeed we can!
> {: .solution}
{: .challenge}


> ## And by the way, can we write inside a container?
> 
> Try and create a file called `example` in the container root directory.  (**Hint**: run `touch /example` inside the container).
> 
> > ## Solution
> > 
> > ```
> > singularity exec docker://ubuntu:16.04 touch /example
> > ```
> > {: .bash}
> > 
> > ```
> > touch: cannot touch '/example': Read-only file system
> > ```
> > {: .output}
> > 
> > We have just learn something more on containers: by default, they are **read-only**.  How can we get a container to write files then?  Read on...
> {: .solution}
{: .challenge}


To summarise what we've learnt in the previous examples, we may say that a container ships an application and its dependencies by encapsulating them in an isolated, read-only filesystem.  In order for a container to access directories from the host filesystem (and write files), one needs to explicitly bind mount them.  The main exception here is the current work directory, which is bind mounted by default.


### Bind mounting host directories

Singularity has the runtime flag `--bind`, `-B` in short, to mount host directories.

There is a long syntax, which allows to map the host dir onto a container dir with a different name/path, `-B hostdir:containerdir`.  
There is also a short syntax, that just mounts the dir using the same name and path: `-B hostdir`.

Let's use the latter syntax to mount `$TUTO` into the container and re-run `ls`.

```
singularity exec -B $TUTO docker://ubuntu:16.04 ls $TUTO/../_episodes
```
{: .bash}

```
11-zeus_login.md  12-singularity-intro.md  13-bio-example-host.md  14-break.md	21-blast.md  22-workflow-engines.md  31-break.md
```
{: .output}

Also, we can write files in a host dir which has been bind mounted in the container:

```
singularity exec -B $TUTO docker://ubuntu:16.04 touch $TUTO/../_episodes/example
singularity exec -B $TUTO docker://ubuntu:16.04 ls $TUTO/../_episodes/example
```
{: .bash}

```
/home/ubuntu/singularity-containers/_episodes/example
```
{: .output}

Now we are talking!

If you need to mount multiple directories, you can either repeat the `-B` flag multiple times, or use a comma-separated list of paths, *i.e.*

```
-B dir1,dir2,dir3
```
{: .bash}

Also, if you want to keep the runtime command compact, you can equivalently specify directories to be bind mounted using the environment variable `SINGULARITY_BINDPATH`:

```
export SINGULARITY_BINDPATH="dir1,dir2,dir3"
```
{: .bash}


### How about sharing environment variables with the host?

By default, shell variables are inherited in the container from the host:

```
export HELLO=world
singularity exec docker://ubuntu:16.04 bash -c 'echo $HELLO'
```
{: .bash}

```
world
```
{: .output}

There might be situations where you want to isolate the shell environment of the container; to this end you can use the flag `-C`, or `--containall`:  
(Note that this will also isolate system directories such as `/tmp`, `/dev` and `/run`)

```
export HELLO=world
singularity exec -C docker://ubuntu:16.04 bash -c 'echo $HELLO'
```
{: .bash}

```

```
{: .output}

If you need to pass only specific variables to the container, that might or might not be defined in the host, you can define variables that start with `SINGULARITYENV_`; this prefix will be automatically trimmed in the container:

```
export SINGULARITYENV_CIAO=mondo
singularity exec -C docker://ubuntu:16.04 bash -c 'echo $CIAO'
```
{: .bash}

```
mondo
```
{: .output}

From Singularity 3.6.x on, there's an alternative way to define variables that are specific to the container, using the flag `--env`:

```
singularity exec --env CIAO=mondo docker://ubuntu:16.04 bash -c 'echo $CIAO'
```
{: .bash}

```
mondo
```
{: .output}