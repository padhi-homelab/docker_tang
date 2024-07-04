# docker_tang

[![build status](https://img.shields.io/github/actions/workflow/status/padhi-homelab/docker_tang/docker-release.yml?label=BUILD&branch=main&logo=github&logoWidth=24&style=flat-square)](https://github.com/padhi-homelab/docker_tang/actions)
[![testing size](https://img.shields.io/docker/image-size/padhihomelab/tang/testing?label=SIZE%20%5Btesting%5D&logo=docker&logoColor=skyblue&logoWidth=24&style=flat-square)](https://hub.docker.com/r/padhihomelab/tang/tags)
[![latest size](https://img.shields.io/docker/image-size/padhihomelab/tang/latest?label=SIZE%20%5Blatest%5D&logo=docker&logoColor=skyblue&logoWidth=24&style=flat-square)](https://hub.docker.com/r/padhihomelab/tang/tags)
  
[![latest version](https://img.shields.io/docker/v/padhihomelab/tang/latest?label=LATEST&logo=linux-containers&logoWidth=20&labelColor=darkmagenta&color=gold&style=for-the-badge)](https://hub.docker.com/r/padhihomelab/tang/tags)
[![image pulls](https://img.shields.io/docker/pulls/padhihomelab/tang?label=PULLS&logo=data:image/svg%2bxml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz4KPHN2ZyB3aWR0aD0iODAwcHgiIGhlaWdodD0iODAwcHgiIHZpZXdCb3g9IjAgMCAzMiAzMiIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KICA8ZyBmaWxsPSIjZmZmIj4KICAgIDxwYXRoIGQ9Ik0yMC41ODcsMTQuNjEzLDE4LDE3LjI0NlY5Ljk4QTEuOTc5LDEuOTc5LDAsMCwwLDE2LjAyLDhoLS4wNEExLjk3OSwxLjk3OSwwLDAsMCwxNCw5Ljk4djYuOTYzbC0uMjYtLjA0Mi0yLjI0OC0yLjIyN2EyLjA5MSwyLjA5MSwwLDAsMC0yLjY1Ny0uMjkzQTEuOTczLDEuOTczLDAsMCwwLDguNTgsMTcuNGw2LjA3NCw2LjAxNmEyLjAxNywyLjAxNywwLDAsMCwyLjgzMywwbDUuOTM0LTZhMS45NywxLjk3LDAsMCwwLDAtMi44MDZBMi4wMTYsMi4wMTYsMCwwLDAsMjAuNTg3LDE0LjYxM1oiLz4KICAgIDxwYXRoIGQ9Ik0xNiwwQTE2LDE2LDAsMSwwLDMyLDE2LDE2LDE2LDAsMCwwLDE2LDBabTAsMjhBMTIsMTIsMCwxLDEsMjgsMTYsMTIuMDEzLDEyLjAxMywwLDAsMSwxNiwyOFoiLz4KICA8L2c+Cjwvc3ZnPgo=&logoWidth=20&labelColor=teal&color=gold&style=for-the-badge)](https://hub.docker.com/r/padhihomelab/tang)

---

A multiarch [tang] Docker image, based on [Alpine Linux].

|        386         |       amd64        |       arm/v6       |       arm/v7       |       arm64        |      ppc64le       |       s390x        |
| :----------------: | :----------------: | :----------------: | :----------------: | :----------------: | :----------------: | :----------------: |
| :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |


## Usage

```
docker run -p 1234:8080 -it padhihomelab/tang
```

Runs `tang` server on port `1234`.

You might also want to use:
- the `--detach` to run the container in background
- the `--rm` to cleanup the container filesystem after `docker` exits
- a `docker compose` workflow instead (see: [services/tang])

## IPv4 vs IPv6

By default, the `tang` server only listens on IPv4.
You may, however, also listen on IPv6 by creating a container
with `ENABLE_IPv6=1` set:

```
docker run -e ENABLE_IPv6=1 ...
```

You may even disable listening on IPv4 entirely,
and only listen on IPv6 instead:

```
docker run -e ENABLE_IPv4=0 -e ENABLE_IPv6=1 ...
```

## Persistent Database

To persist tang's database beyond the lifetime of a container,
you could bind mount a host filesystem directory at `/db`:

```
docker run -v /path/to/tang/db:/db \
           -p 1234:8080 \
           -it padhihomelab/tang
```

This container drops `root` privilege at startup,
and runs `tang` as an unprivileged user with `DOCKER_UID` id.
So, the files in `/path/to/tang/db` that are written by `tang`
are owned by the `$DOCKER_UID` user id within the container.  
For your host system user to be able to access them,
you may override the `DOCKER_UID` variable when starting the container:

```
docker run -v /path/to/tang/db:/db \
           -e DOCKER_UID=$(id -u) \
           -p 1234:8080 \
           -it padhihomelab/tang
```

For more information on this topic,
please see the `alpine-base` image documentation:
[Do I ever need to override the UID, GID etc.? Why are these variables exposed?](https://github.com/padhi-homelab/docker_alpine-base/#do-i-ever-need-to-override-the-uid-gid-etc-why-are-these-variables-exposed)



[Alpine Linux]:  https://alpinelinux.org/
[tang]:          https://github.com/latchset/tang
[services/tang]: https://github.com/padhi-homelab/services/tree/master/tang
