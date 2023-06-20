<!-- TABLE OF CONTENTS -->

#readme-top

<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#use-docker">Use Docker</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->

## About The Project

<!-- GETTING STARTED -->

## Getting Started

### Prerequisites

### Installation

```sh
https://docs.docker.com/engine/install/ubuntu/
```

```sh
https://docs.docker.com/config/daemon/start/
```

```sh
https://docs.docker.com/engine/install/linux-postinstall/#configure-docker-to-start-on-boot-with-systemd
```

```sh
https://askubuntu.com/questions/1379425/system-has-not-been-booted-with-systemd-as-init-system-pid-1-cant-operate
```

```sh
sudo systemctl start docker
```

```sh
sudo dockerd
```

```sh
docker run hello-world
```

## Use Docker

<!-- USE DOCKER -->

Show current docker version on your machine

```sh
docker version
```

The command returns information about the docker client (cli) and the docker server (engine) which is running as a deamon/service on your machine. The cli is talking to the engine and then the cli returns the values whic it gots from the engine. Make sure you have the latest versions as possible installed.

Show configuration information for the engine

```sh
docker info
```

Show a list of docker commands.

```sh
docker
```

At the top of the list you will see the management commands. So you can use the management command format.

```sh
docker <command> <sub-command> (options)
```

<!-- IMAGE VS CONTAINER -->

### Difference between image and container

<ul>
    <li>
        An image is the application we want to run
    </li>
    <li>
        A container ist the instance of that image running as a process
    </li>
    <li>
        You can have many containers running off the same image
    </li>
    <li>
        Dockers default image "registry" is called Docker Hub <a target="_blank" href="https://hub.docker.com">hub.docker.com</a>
    </li>
</ul>

<!-- RUN NGINX CONTAINER -->

### Run a nginx container

```sh
docker container run --publish 80:80 --detach --name webhost nginx
```

The docker engine looks for an image called nginx and downloads the latest nginx docker image from docker. Then it starts the image as a new process in a new container. The publish part exposes the local port 80 on the local machine and routes all traffic from it to the executable running inside that container on port 80 and since nginx is a webserver it serves the nginx startpage in my browser. "--detach" tells doker to run the container in the background. With option --detach we will get back the unique container id of our container. Every time you run a new container you will get a new container id. With "--name" you can specify a name for the container and it will not get a random one.

```sh
docker container ls
```

Lists all containers

```sh
docker container stop <container_id>
```

```sh
docker container ls -a
```

Lists all containers also the ones which are stopped. Every time you execute "docker container run" the engine starts a "new" container with new id.

```sh
docker container stop <id_or_name>
```

Stops the specific container (you can also type the first few digits)

```sh
docker container logs <container_name>
```

Shows logs for a specific container.

```sh
docker container top <container_name>
```

Shows the process runniong inside the container.

```sh
docker container --help
```

Shows all possible commands we can try on the container.

```sh
docker container rm <container_id> <container_id> <container_id>
```

Removes all stopped containers specified or at the same time. You cant remove running containers - you should use "-f" option instead.

```sh
docker container rm -f <container_id> <container_id> <container_id>
```

<!-- WHAT HAPPENS WHEN WE RUN THE NGINX CONTAINER -->

#### What happens when we run the nginx container

What happens in "docker container run"?

<ol>
    <li>
        Looks for the local imgage in the image cache
    </li>
    <li>
        if it doesnt find any image there it looks in the remote image repository (deafult is docker hub)
    </li>
    <li>
        Donwload the latest version (eg nginx:latest by default if not specified) and stores it in the image cache.
    </li>
    <li>
        Creates a new container based on that image and prepares to start.
    </li>
    <li>
        Gives it a virtual IP on private network inside docker engine.
    </li>
    <li>
        Opens up port 80 on host and forwards to port 80 in container.
    </li>
    <li>
        Starts container by using the CMD in the image Dockerfile.
    </li>
</ol>

<!-- CONTAINER VS VM -->

#### Container vs VM

Its just a process

```sh
docker top
```

Display the running processes of a container

```sh
ps aux
```

Shows the host proces

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ROADMAP -->

## Roadmap

- [x] Check if disk space on CIFS share is sufficient before running the backup command
- [ ] Logfile monitoring with grafana
  - [ ] Specify requirements

See the [open issues](https://github.com/hkiepe/docker/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LICENSE -->

## License

Distributed under the XXX. See `XXXLICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTACT -->

## Contact

Henrik Kiepe - hkiepe@ssc-services.de

Project Link: [https://github.com/hkiepe/docker](https://github.com/hkiepe/docker)

<p align="right">(<a href="#readme-top">back to top</a>)</p>
