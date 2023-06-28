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

Shows the processes runniong inside the container.

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

<!-- LOOK INSIDE A CONTAINER -->

#### Look inside a container

List processes inside a container

```sh
docker container top <container_name>
```

Shows meta data about how the container was started as a JSON.

```sh
docker container inspect <container_name>
```

Streaming view of life performance data about the container for our containers when leaving the container name blank.

```sh
docker container stats [<container_name>]
```

With option "-it" you can get inside the container. "-t" gives us a pseudo-tty and simulates a real terminal whereas "-i" is keeping the session open to receive terminal input. Then at the end of the command you can pass a command which will be executed in the container shell. Bash will just starts a shell where you can type commands.

```sh
docker container run -it --publish 80:80 --name nginx nginx bash
```

After exiting out of the container the container stops. You can start the container with

```sh
docker container start ai <container_name>
```

Run a command or login in a running container:

```sh
docker container exec -it <container_name> bash
```

After exiting out the container still runs because the docker container exec runs an additional process on the running container so its not gonna affect the root process of the running container deamon.

Not in every container there is "bash" installed. So you have to make sure you are runnoing the appropriate shell. For example the alpine image uses "sh"

```sh
docker container run -it <container_name> sh
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- NETWORKING -->

### Networking

"docker container run -p" exposes the port on the host machine amon of a lot other things which we will talk about here.

<ul>
    <li>
        Each container is connected to a private virtual network "bridge" -> default
    </li>
    <li>
        Each virual network routes through NAT firewall which is actually the docker deamon configuring the host IP adress on its default interface so that the containers can get out to the internet or to the rest of the network.
    </li>
    <li>
        All containers on a virtual network can talk to each other without -p 
    </li>
    <li>
        Best practice is to create a new virtual network for each app:
        <ul>
            <li>
                network "my_web_app" for mysql and php/apache containers
            </li>
            <li>
                network "my_api" for mongo and nodejs containers
            </li>
        </ul>
        <ul><li><li></ul>
    </li>
    <li>
        Batteries included, but removable
        <ul>
            <li>
                Deafults work well in many cases, but easy to swap out parts to customize it.
            </li>
        </ul>
    </li>
    <li>
        Make new virtual networks
    </li>
    <li>
        Atach containers to more than one virtual network (or none)
    </li>
    <li>
        Skip virtual networks and use host IP (--net=host)
    </li>
    <li>
        Use different Docker network drivers to gain new abilities.
    </li>
    <li>
        ... much more
    </li>
</ul>

Create a container and bind it to port 8080 on host and 80 of the container

```sh
docker container run -p 80:80 --name webhost -d nginx
```

Publishing ports is allways in the 80:80 -> HOST:CONTAINER format ..

```sh
docker container port webhost
```

```sh
80/tcp -> 0.0.0.0:80
```

Shows the ports of a container in a nice and easy format.

Show ip of an container

```sh
docker container inspect --format '{{ .NetworkSettings.IPAddress }}' webhost
```

<!-- DOCKER NETWORKING CLI MANAGEMENT -->

#### Docker networking CLI Management

```sh
docker network ls
```

Running this command you see all the networks which where created. There are:

| NETWORK ID   | NAME   | DRIVER | SCOPE |
| ------------ | ------ | ------ | ----- |
| 1fe8f12e5ed4 | bridge | bridge | local |
| 41a27c073d2f | host   | host   | local |
| 9cd60cce5443 | none   | null   | local |

There is the default network which is called bridge or docker0 (depending on the os where the docker engine is running). Its the default network that bridges through the NAT firewall to the physical network the host is connected to.

```sh
docker network inspect <network_name>
```

Shows among others the containers attached to that network. The networks automatically assign ip adresses. You can see the Subnet and the Gateway for the network.

The host network is a special network that skips the virtul networking of docker and attaches the container directly to the host interface. It prevents the security boundaries of the containerization and from protecting the interface of that container but it also can improve the performance.

Tne "none" network is kind of the equivalent with having an interface on your computer that is not attached to anything. It removes eth0 and only leaves you with localhost interface in container.

```sh
docker network create <network_name>
```

Spans a new virtual network to attach containers to. If you dont specify a driver it creates the network with the "bridge" driver because thats the default driver. Its a simple driver that simply creates a virtual network locally with its own subnet arround the 172.17... A network driver is a built in or third party extension that give you virtual network features.

```sh
docker container run -d --name <container_name> <container_image> --network <network_name>
```

Creates a container in the specified network. But we dont have to start new containers. We can just plug in and unplug containers from netwroks.

```sh
docker network connect <network_id> <container_id>
docker network disconnect <network_id> <container_id>
```

This command dynamically creates a new NIC in a container on an existing virtual network.

If you are running all the applications on a single server, you are able to really protect them. Because in the phyical world where we creating virtual machines and hosts in a network, we would often over expose the ports and networking on our application servers so in these cases, if you have your app contsainers in one network together you ony gona be exposing the ports on your host that you specifically use the -p and everything else is a little safer within that protected firewall in the virtual network.

When you create a new network, the networks get automatically a new feature which is automatic DNS resolution for all the containers on that virtul network from all tzhe other containers on that virtual network using their container names. So if i create a new container on that same network, they are able to find each other regardless what the ip adress is, with their container names.

<!-- DOCKER NETWORKING -->

#### Docker networking

Dont use ip adresses. Just DNS names because docker changes ip adresse dynamically. Docker deamon has a built in DNS server that container use by default. Docker defaults the hostname to the containers name but it can be changed by setting an alias.

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
