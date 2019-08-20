# Easy Jupyter

Run Jupyter notebooks without the pain of a messy python/conda environment. This repo provides an easy way to run Jupyter tools inside clean, flexible docker containers. It also makes it easy to run on your machine as well as on an AWS instance of any size.

The solution below will allow you to:

 - Launch a notebook server with one command - Python3, R and Julia are supported out the box.
 - Persist your work to your hard drive - no additional work required.
 - Install your own Python packages - install once, use forever.
 - Connect to Jupyter from Google Colab - for added power with the Colab interface and tools.
 - Run Jupyter on AWS instances with 2-64 cores and 1Gb to 1Tb of RAM.

## 1. Initial setup

- Install Docker and launch the docker Daemon. Note that the number of cores/RAM can be set under preferences in Docker. The resource constraints of docker will affect the resources available to Jupyter.
- Clone this repository and place it into a location where you are comfortable keeping it for as long as you will use this project (we keep scripts in the repo rather than installing anything into bin folders).
- cd into the repository on your local machine: `$ cd /path/to/repo`
- Run `bash ./bin/install.sh`. This will install the execution shim into your bash profile file. (You may need to make this file executable with `chmod +x ./bin/install.sh)`.
- Restart your terminal before proceeding.
- You can now use the `easy-jupyter` command line function to interact with Jupyter. Run `easy-jupyter test-config` to check that everything is set up right!.

## 2. Running Jupyter Locally

For the commands below to work, you must have the docker daemon turned on.

- Run `easy-jupyter run-notebook` to run Jupyter notebook locally. It should be available at `localhost:8888`.
- You can also run `easy-jupyter run-lab` to run Jupyter Lab locally.

NOTE: the directory in which you run these commands will become the root directory for your notebook server. Any changes you make from the notebooks/server will persist in this directory. This isn't true for AWS, see section 4 below.

## 3. Customizing the Docker Image

By default, the runner scripts will pull a pre-built image from DockerHub. However, you may want to change your image to install new packages or change the runtime. You will need to rebuild the image for changes of this kind to be used by the runner commands.

After following the instructions in the subsection below, run `easy-jupyter build`. This will rebuild the image. Following this, your image will be used by the runner commands. To switch back, you will need to destroy the image using the standard docker interface for deleting local images: see [here](https://lmgtfy.com/?q=deleting+docker+images)

### 3A: Adding new python packages

- Add the package to the `requirements.txt` file in the repo.
- Rebuild your image with `bash bin/build.sh` (you must be in the repo folder to do this)

### 3B: Customizing the server

You may use the docker file to make changes to the core installation of Jupyter or change anything else about the configuration of the runtime. Any changes here will also require rebuilds.

## 4. Running on AWS

NOTE: you must run all the commands below in the same terminal window and you should stay in the same project folder in that window for the complete life-cycle of the run. This allows for automatic data syncing.

### 4A: Initializing an AWS instance
- To switch to AWS run `easy-jupyter use-aws`. This will create a new AWS instance of type t2.micro in the us-east-1 region. All data in your current folder will be loaded into your work environment on the remote instance.
  - To change the region of your instance you will need to go into the source of the use-aws command in scripts.
  - To change the instance size, use the AWS console - navigate to EC2 in the correct region, find the aws-sandbox instance and change the type by right clicking on the instance. The instance must be stopped for this change to work.

- Following this command, the run commands will run jupyter on AWS but make it available at localhost:8888. All changes are saved in the remote host.

### 4B: Data Management on AWS

- Run `easy-jupyter pull-from-aws` to pull the new file versions from AWS to your local folder. All local versions will be overridden.
- Run `easy-jupyter push-to-aws` to sync new local files to the remote. All remote versions will be overridden.

### 4C: Switching back to local

- When you're doneRun `easy-jupyter use-local` to switch back to your machine.

### 4D: Tearing-down up AWS instances

- You MUST run `easy-jupyter stop-aws` (stops the instance, preserving files) and/or `easy-jupyter destroy-aws` (deletes the instance, deleting all files) when you are done working to avoid incurring charges for the EC2 box. Stopping will stop most charges except a small amount for data storage.
