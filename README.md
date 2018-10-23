# Adopt OpenJ9 for Spring Boot performance!

This repostory contains the Dockerfiles for demo'ing the difference for Spring Boot workloads between OpenJDK with Hotspot and [Eclipse OpenJ9](https://www.eclipse.org/openj9/). We use Spring Petclinic as the examplar. The demo can be easily modified to build any git-based project by updating the Dockerfiles.

To build the images:
```
git clone 
cd adopt-openj9-spring-boot
./build.sh
```

This will build two Docker images: `petclinic-openjdk-hotspot` and `petclinic-openjdk-openj9`.

Now, start the Docker stats monitor:

```
docker stats
```

Next, run the two Docker images. This is best done in two new terminal windows that are visible on the screen.

```
docker run -p 8080:8080 --name hotspot petclinic-openjdk-hotspot
docker run -p 8089:8080 --name openj9 petclinic-openjdk-openj9
```

You can see from the `docker stats` that the `CPU %` and `MEM USAGE` are significantly lower for the `openj9` container than the `hotspot` container.



Created for the EclipseCon Europe 2018 talk [Adopt Open J9 for Spring Boot performance!](https://www.eclipsecon.org/europe2018/sessions/adopt-open-j9-spring-boot-performance)
