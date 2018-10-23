# Adopt OpenJ9 for Spring Boot performance!

This repostory contains the Dockerfiles for demoing the difference for Spring Boot workloads between OpenJDK with Hotspot and [Eclipse OpenJ9](https://www.eclipse.org/openj9/). We use [Spring Petclinic](https://github.com/spring-projects/spring-petclinic) as the examplar. The demo can be easily modified to build any git-based project by updating the Dockerfiles to clone a different repository.

To build the images:

```
git clone https://github.com/barecode/adopt-openj9-spring-boot.git
cd adopt-openj9-spring-boot
./build.sh
```

This will build two Docker images: `petclinic-openjdk-hotspot` and `petclinic-openjdk-openj9`. The only difference between these images is the base layer used for Java.

Now, start the Docker stats monitor:

```
docker stats
```

The `docker stats` monitor will give real-time stats of the running Docker containers. Assuming you have no other running Docker containers, the view will initally be empty.

Next, run the two Docker images. This is best done in two new terminal windows that are visible on the screen. Once the containers start, you will see it in the `docker stats` window.

```
docker run -p 8080:8080 --name hotspot petclinic-openjdk-hotspot
docker run -p 8089:8080 --name openj9 petclinic-openjdk-openj9
```

You can see from the `docker stats` that the `CPU %` and `MEM USAGE` are significantly lower for the `openj9` container than the `hotspot` container.

You can access both instances of Petclinic as the container internal port 8080 is mapped to different host ports.

`hotspot` - `http://localhost:8080/`

`openj9` - `http://localhost:8089/`


That's it!


Created for the EclipseCon Europe 2018 talk [Adopt Open J9 for Spring Boot performance!](https://www.eclipsecon.org/europe2018/sessions/adopt-open-j9-spring-boot-performance)
