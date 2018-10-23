# Adopt OpenJ9 for Spring Boot performance!

This repository contains Dockerfiles for demoing the benefits of [Eclipse OpenJ9](https://www.eclipse.org/openj9/) for Spring Boot workloads.
Docker images with OpenJDK with HotSpot, and OpenJDK with OpenJ9, are used to highlight the memory, CPU and throughput performance benefits of OpenJ9.
[Spring Petclinic](https://github.com/spring-projects/spring-petclinic) is used as the examplar Spring application.

### Build the images

To build the images, clone the repository and run the `build.sh` script:

```
git clone https://github.com/barecode/adopt-openj9-spring-boot.git
cd adopt-openj9-spring-boot
./build.sh
```

The build script will produce three Docker images: `petclinic-openjdk-hotspot`, `petclinic-openjdk-openj9` and `petclinic-openjdk-openj9-warmed`.
The primary difference between these images is the base layer used for Java (HotSpot vs OpenJ9).
A further difference is for the `petclinic-openjdk-openj9-warmed` image the Spring Petclinic app is started and stopped as part of the Docker build flow.
The JVM is started to 'warm' the class cache, which results in a faster start-up time for the Docker image.


### Compare HotSpot with OpenJ9

Eclipse OpenJ9 has memory, CPU and throughput performance benefits over HotSpot.
To see the memory footprint savings and lower CPU utilization, start the Docker stats monitor:

```
docker stats
```

The `docker stats` process will give real-time statistics of the running Docker containers. If you have no running Docker containers, the view will initially be empty.

Now, run the `petclinic-openjdk-hotspot` and `petclinic-openjdk-openj9` Docker images.
This is best done in two new terminal windows so that all three terminals that are visible on the screen.
Once a container starts, you will see it in the `docker stats` window.

```
docker run --rm -p 8080:8080 --name hotspot petclinic-openjdk-hotspot
docker run --rm -p 8089:8080 --name openj9 petclinic-openjdk-openj9
```

You can see from the `docker stats` window that the `CPU %` and `MEM USAGE` of the `openj9` container are significantly lower than that of the `hotspot` container.
OpenJ9 has always focused on a small memory footprint.
Some of the design choices which contribute to the smaller memory usage include:
* size of the class meta data
* smaller default heap sizes
* less aggressive Java heap expansion

You can drive traffic to both instances of Petclinic since the internal container port is mapped to different host ports.
- Access `hotspot` on `http://localhost:8080/`
- Access `openj9` on `http://localhost:8089/`


### Faster start-up with shared classes

The third Docker image, `petclinic-openjdk-openj9-warmed`, shows the benefits of OpenJ9's shared class cache and `-Xquickstart` parameter.
The shared class cache is enabled with ``-Xshareclasses`, which stores the JIT'd classes on-disk for use on subsequent restarts.
This increases the startup time of the JVM at the expense of a slightly larger Docker image.

The Docker image is already pre-warmed as part of the Docker build (see `Dockerfile.openj9.warmed`).

Run the `petclinic-openjdk-openj9-warmed` Docker image in a new terminal window.

`docker run --rm -p 8090:8080 --name warmed petclinic-openjdk-openj9-warmed`

Note that the start-up time for the Spring Boot application is faster than the other images, on average 25-50% faster.
This will also result in a slight memory savings over the other OpenJ9 image which was not pre-warmed.

### A word on the Dockerfiles

The Dockerfiles used in this demo were intentionally created to be self-contained images.
The resulting Docker image and the steps in the Dockerfile are *not* recommended for use in production.
It is recommended that the application build process happen outside of the production Docker image.
This can be accomplished by building the application in the host OS (the most common approach), or by using [multi-stage Docker builds](https://docs.docker.com/develop/develop-images/multistage-build/).
For more details on creating optimized Spring Boot images, check out this [blog](https://openliberty.io/blog/2018/06/29/optimizing-spring-boot-apps-for-docker.html) post.

That's it! Thanks for checking out the demo.

Created for the EclipseCon Europe 2018 talk [Adopt Open J9 for Spring Boot performance!](https://www.eclipsecon.org/europe2018/sessions/adopt-open-j9-spring-boot-performance)
