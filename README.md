# docker_tang <a href='https://github.com/padhi-homelab/docker_tang/actions?query=workflow%3A%22Docker+CI+Release%22'><img align='right' src='https://img.shields.io/github/actions/workflow/status/padhi-homelab/docker_tang/docker-release.yml?branch=main&logo=github&logoWidth=24&style=flat-square'></img></a>

<a href='https://hub.docker.com/r/padhihomelab/tang'><img src='https://img.shields.io/docker/image-size/padhihomelab/tang/latest?label=size%20%5Blatest%5D&logo=docker&logoWidth=24&style=for-the-badge'></img></a>
<a href='https://hub.docker.com/r/padhihomelab/tang'><img src='https://img.shields.io/docker/image-size/padhihomelab/tang/testing?label=size%20%5Btesting%5D&logo=docker&logoWidth=24&style=for-the-badge'></img></a>

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
