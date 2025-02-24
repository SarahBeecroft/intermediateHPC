---
title: "Basics of Singularity"
teaching: 10
exercises: 20
questions:
objectives:
- Download container images
- Run commands from inside a container
- Discuss what are the most popular image registries
keypoints:
- Singularity can run both Singularity and Docker container images
- Execute commands in containers with `singularity exec`
- Open a shell in a container with `singularity shell`
- Download a container image in a selected location with `singularity pull`
- You should not use the `latest` tag, as it may limit workflow reproducibility
- The most commonly used registries are Docker Hub, Red Hat Quay and BioContainers
---


### Get ready for the hands-on
We will `cd` into the directory for this part of the tutorial.

```
cd intro_singularity
```
{: .bash}


> ## Are you running on a shared HPC system?
>
> If you're running this tutorial on a shared system (*e.g.* on Setonix at Pawsey), you should use one of the compute nodes rather than the login node.  You can get this setup by using an interactive scheduler allocation, for instance on Setonix with Slurm:
>
> ```
> salloc -n 1 -t 4:00:00 --account=courses01
> module avail singularity
> module load singularity/xxx
> ```
> {: .bash}
>
> ```
> salloc: Granted job allocation 3453895
> salloc: Waiting for resource configuration
> salloc: Nodes z052 are ready for job
> ```
> {: .output}
{: .callout}

### Executing a command in a Docker container

Singularity is able to download and run Docker images.  
Let's try and download a Ubuntu container from the [**Docker Hub**](https://hub.docker.com), *i.e.* the main registry for Docker containers:

```
singularity exec docker://ubuntu:16.04 cat /etc/os-release
```
{: .bash}

```
INFO:    Converting OCI blobs to SIF format
INFO:    Starting build...
Getting image source signatures
Copying blob sha256:22e816666fd6516bccd19765947232debc14a5baf2418b2202fd67b3807b6b91
 25.45 MiB / 25.45 MiB [====================================================] 1s
Copying blob sha256:079b6d2a1e53c648abc48222c63809de745146c2ee8322a1b9e93703318290d6
 34.54 KiB / 34.54 KiB [====================================================] 0s
Copying blob sha256:11048ebae90883c19c9b20f003d5dd2f5bbf5b48556dabf06c8ea5c871c8debe
 849 B / 849 B [============================================================] 0s
Copying blob sha256:c58094023a2e61ef9388e283026c5d6a4b6ff6d10d4f626e866d38f061e79bb9
 162 B / 162 B [============================================================] 0s
Copying config sha256:6cd71496ca4e0cb2f834ca21c9b2110b258e9cdf09be47b54172ebbcf8232d3d
 2.42 KiB / 2.42 KiB [======================================================] 0s
Writing manifest to image destination
Storing signatures
INFO:    Creating SIF file...
INFO:    Build complete: /data/singularity/.singularity/cache/oci-tmp/a7b8b7b33e44b123d7f997bd4d3d0a59fafc63e203d17efedf09ff3f6f516152/ubuntu_16.04.sif

NAME="Ubuntu"
VERSION="16.04.6 LTS (Xenial Xerus)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 16.04.6 LTS"
VERSION_ID="16.04"
HOME_URL="http://www.ubuntu.com/"
SUPPORT_URL="http://help.ubuntu.com/"
BUG_REPORT_URL="http://bugs.launchpad.net/ubuntu/"
VERSION_CODENAME=xenial
UBUNTU_CODENAME=xenial
```
{: .output}

Note that the prefix `docker://` is required to point Singularity to Docker Hub.

### Download and use images via SIF file names

All examples so far have identified container images using their registry name specification, *e.g.* `docker://ubuntu:16.04` or similar.

An alternative option to handle images is to download them to a known location, and then refer to their full directory path and file name.

Let's use `singularity pull` to save the image to a specified path (output might differ depending on the Singularity version you use):

```
singularity pull docker://ubuntu:16.04
```
{: .bash}

By default, the image is saved in the current directory:

```
ls
```
{: .bash}

```
ubuntu_16.04.sif
```
{: .output}

Then you can use this image file by:

```
singularity exec ./ubuntu_16.04.sif echo "Hello World"
```
{: .bash}

```
Hello World
```
{: .output}

You can specify the storage location with the `--dir` flag:

```
mkdir -p sif_lib
singularity pull --dir sif_lib docker://library/ubuntu:16.04
```
{: .bash}

Being able to specify download locations allows you to keep the local set of images organised and tidy, by making use of a directory tree. It also allows for easy sharing of images within your team in a shared resource.  In general, you will need to specify the location of the image upon execution, *e.g.* by defining a dedicated variable:

```
export CONTAINER="sif_lib/ubuntu_16.04.sif"
singularity exec $CONTAINER echo "Hello Again"
```
{: .bash}

```
Hello Again
```
{: .output}


> ## Using the *latest* tag
>
> The practice of using the `latest` tag can be handy for quick typing, but is dangerous when it comes to reproducibility of your workflow, as under the hood the *latest* tag could point to different images over time.
{: .callout}

### Open up an interactive shell

Sometimes it can be useful to open a shell inside a container, rather than to execute commands, *e.g.* to inspect its contents.

Achieve this by using `singularity shell`:

```
singularity shell docker://ubuntu:16.04
```
{: .bash}

```
Singularity> 
```
{: .output}

Remember to type `exit`, or hit `Ctrl-D`, when you're done!

> ## Contextual help on Singularity commands
>
> Use `singularity help`, optionally followed by a command name, to print help information on features and options.
{: .callout}


### Popular registries (*aka* image libraries)

Bioinformaticians should keep in mind the container registry [Red Hat Quay](https://quay.io) by Red Hat, that hosts thousands of applications in this domain of science.  These mostly come out of the [BioContainers](https://biocontainers.pro) project, that aims to provide automated container builds of all of the packages made available through [Bioconda](https://bioconda.github.io).


> ## Pull and run a Python container ##
>
> How would you pull the following container image from Docker Hub, `python:3-slim`?
>
> Once you've pulled it, enquire the Python version inside the container by running `python --version`.
>
> > ## Solution
> >
> > Pull:
> >
> > ```
> > singularity pull docker://python:3-slim
> > ```
> > {: .bash}
> >
> > Get Python version:
> >
> > ```
> > singularity exec ./python_3-slim.sif python --version
> > ```
> > {: .bash}
> >
> > ```
> > Python 3.10.2
> > ```
> > {: .output}
> {: .solution}
{: .challenge}
