# How to create your Bootcamp Starter Environment
#### By Alex Merced of AlexMercedCoder.com

## Side-Note:

If ever doing backend work and for some reason even if this tool doesn't do the trick you can use REPLit.com to do work in any language. Just keep in mind when running any dev servers make sure to bind the host to 0.0.0.0. Just look how in the particular frameworks documentation usually as simple as passing a flag with the command that starts the dev server.

## Pre-requisites

You will need to install Visual Studio Code and Docker for your operating system.

You'll know you have docker installed if the command `docker --version` returns a version number

## Step 1 - Install the Remote-Containers Extension in VSCode

The remote containers VSCode extension allows us to use docker to open a folder using one of their images or a custom dockerfile. This will create a sort of imaginary computer that exists when you open that folder with all the software you'll need for that cohort.

Notes:
- Once setup, it'll always open the container when opening this folder in VSCode
- The files saved in the folders are yours and will exist even when the container is shut off
- if you create files outside of that folder, install new software, update settings in the container, it will all reset itself the next time the container is on (like resetting a video game, think of the folder as your memory card between playing sessions)

## Step 2 - Create Files

Open VScode to an empty folder, call it something like `bootcamp_workspace` as that's what it will be.

Create two files `init_userdb.sql` and `DOCKERFILE`

`init_userdb.sql`
```sql
CREATE USER student WITH SUPERUSER PASSWORD 'student';
CREATE DATABASE student;
```

`DOCKERFILE`
* Make sure in the GIT section to replace the name and email with your name and email
```docker
## Starting from Ubuntu
FROM ubuntu

## Create a Non-Root User
RUN apt-get update && apt-get -y install sudo && apt-get install wget -y && apt-get install curl -y
RUN useradd -m student && echo "student:student" | chpasswd && adduser student sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

## Switch to Non-Root User
USER student

## INSTALL POSTGRES
RUN DEBIAN_FRONTEND="noninteractive" TZ="Europe/London" sudo apt install tzdata
RUN sudo apt install postgresql -y

## Setup Postgres User and Database for docker user
USER postgres
COPY init_userdb.sql /home/postgres/
RUN service postgresql start && psql -f /home/postgres/init_userdb.sql && service postgresql stop

## SWITCH back to docker user
USER student

## Install MongoDB
RUN sudo apt-get install gnupg -y
RUN wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
RUN sudo apt update -y
RUN echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list
RUN sudo apt-get update && sudo apt-get install -y mongodb-org
RUN sudo mkdir -p /data/db && sudo chmod 777 /data/db

WORKDIR /home/student/

## Install Node
RUN sudo curl -sL https://deb.nodesource.com/setup_16.x -o nodesource_setup.sh
RUN sudo bash nodesource_setup.sh
RUN sudo apt install nodejs -y

## Install Git
RUN sudo apt install git -y
RUN git config --global user.name "Alex Merced"
RUN git config --global user.email example-email@alexmerced.dev

## Install Ruby (Will install 2.7)
RUN sudo apt install ruby-full -y

## Install Python3
RUN sudo apt-get install python3 python3-dev -y

## Start Container
ENTRYPOINT bash
```

## Opening the Directory

Click on the gear in the bottom left corner of VSCode and click open command pallette and lookup remote-container command to open a directory in a container, open the current folder using the dockerfile and then just... wait, it will take a long while for it to build the image but it only needs to build it once.

Once it's done building whenever you open this folder, it'll automatically open the container and mount the folder as if it were inside the container.

You could also run the container and attach an instance of VSCode to the running container, there is a remote-container extension option for that.

## Starting Database Servers

- `sudo service postgresql start` for postgresql

- `mongod` for mongo
