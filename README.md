# docker_tang <a href='https://github.com/padhi-homelab/docker_tang/actions?query=workflow%3A%22Docker+CI+Release%22'><img align='right' src='https://img.shields.io/github/workflow/status/padhi-homelab/docker_tang/Docker%20CI%20Release?logo=github&logoWidth=24&style=flat-square'></img></a>

<a href='https://microbadger.com/images/padhihomelab/tang'><img src='https://img.shields.io/microbadger/layers/padhihomelab/tang/latest?logo=docker&logoWidth=24&style=for-the-badge'></img></a>
<a href='https://hub.docker.com/r/padhihomelab/tang'><img src='https://img.shields.io/docker/image-size/padhihomelab/tang/latest?label=size%20%5Blatest%5D&logo=docker&logoWidth=24&style=for-the-badge'></img></a>
<a href='https://hub.docker.com/r/padhihomelab/tang'><img src='https://img.shields.io/docker/image-size/padhihomelab/tang/testing?label=size%20%5Btesting%5D&logo=docker&logoWidth=24&style=for-the-badge'></img></a>

A multiarch [tang] Docker image, based on [Alpine Linux].

|        386         |       amd64        |       arm/v6       |       arm/v7       |       arm64        |      ppc64le       |       s390x        |
| :----------------: | :----------------: | :----------------: | :----------------: | :----------------: | :----------------: | :----------------: |
| :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |


## Usage

```
docker run --detach \
           -p 8080:8080 \
           -it padhihomelab/tang
```

Runs `tang` server on port 8080.

_<More details to be added soon>_


[Alpine Linux]: https://alpinelinux.org/
[tang]:         https://github.com/latchset/tang

# Quick-start
To start a one-shot container simply run
`docker run -it --rm -p 8080:8080/tcp padhihomelab/tang`  
where the standard server port, `8080`, will be exposed on your host machine.

## Persist data 💾
The "quick-start command" will not persist its data (located at `/data` within the container) beyond the lifetime of the container.  
To link the tang server's data with a persistent volume on the host run:  
```docker run -it --rm -p 8080:8080 --volume "/home/myUser/whatever":"/data" padhihomelab/tang```  
Or, if you want to work with docker volumes, docker will automatically create an anonymous volume.
You can access the volume by its ID, which is returned by `docker inspect [insert container ID obtained from the list]` in the section `Mounts`.
## Change port
To expose tang on a different port on your host machine, e.g. 1234, change the `-p` parameter:  
`-p 1234:8080`
## Run quietly in the background
Simply add the `--detach` flag:  
`docker run -it --rm -p 8080:8080 --volume "/wherever/on/host":"/data" --detach padhihomelab/tang`
## Write files as specific user
Just pass the `DOCKER_UID` environment variable to the `docker run` command.
This will make the container write files as the current user, i.e. the user executing this command:  
`docker run -it --rm -p 8080:8080 --volume "/home/myUser/whatever":"/data" padhihomelab/tang -e DOCKER_UID=$(id -u)`  
To find out if file permissions might be a concern for you, you might consider [Do I ever need to override the UID, GID etc.? Why are these variables exposed?](https://github.com/padhi-homelab/docker_alpine-base/#do-i-ever-need-to-override-the-uid-gid-etc-why-are-these-variables-exposed)
💾
