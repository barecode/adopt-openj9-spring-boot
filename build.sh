#!/bin/bash
docker build -t petclinic-openjdk-hotspot -f Dockerfile.openjdk .
docker build -t petclinic-openjdk-openj9 -f Dockerfile.openj9 .
