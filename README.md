# docker-php
The base image for a PHP application. 

# How to build a new image/tag

To build a new image we need to execute the following command, replacing `tagname` with 
the name that you want (e.g.: `7.4.9-fpm-alpine`)
`docker build -t dokify/php:tagname .`

When the build finishes, you could upload it to the Docker Hub repository, 
to do this, first you need to login with your Docker Hub account:

`docker login`

After the login, you can now upload the new image with the tag that you have generated 
previously:

`docker push dokify/php:tagname`
