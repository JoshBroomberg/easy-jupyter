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

## 3. Customizing Jupyter

A copy of the standard Jupyter Config is provided (with some tweaks) as part of this repo in the `jupyter_config` folder. This folder is mounted onto the jupyter container at run time such that changes made in the Jupyter settings (like activating extensions) are persisted beyond the container life-cycle. You can also manually change the settings here - for example adding a new nbconvert template - and then restart the container to have those changes loaded into Jupyter.

## 4. Customizing the Docker Image

By default, the runner scripts will pull a pre-built image from DockerHub. However, you may want to change your image to install new packages or change the runtime. You will need to rebuild the image for changes of this kind to be used by the runner commands.

After following the instructions in the subsection below, run `easy-jupyter build`. This will rebuild the image. Following this, your image will be used by the runner commands **but only in local runs**. Running a custom image in AWS is not yet supported.

To switch back to the original version of the image, you will need to destroy your custom image using the standard docker interface for deleting local images: see [here](https://lmgtfy.com/?q=deleting+docker+images)

### 4A: Adding new python packages

- Add the package to the `requirements.txt` file in the repo. Use the standard name==version format for this. You can create formatted requirements file contents from your local env with `pip freeze` and then copy-paste the output to the file.
- Rebuild your image with `easy-jupyter build`.

### 4B: Customizing the server

You may use the docker file to make changes to the core installation of Jupyter or change anything else about the configuration of the runtime. Any changes here will also require rebuilds.

## 5. Running on AWS

NOTE: You should stay in the same active folder in your terminal for the complete life-cycle of the run. This allows for automatic data syncing.

### 5A: Initializing an AWS instance

- Create an AWS account and/or log in to your AWS console. Navigate to IAM and create a user with Administrator Access permissions. You should give this user programmatic AWS access when asked and write does the access key and secret code.
- Create a file at `~/.aws/credentials` with content which follows the format below. You can do `touch ~/.aws/credentials` and then `nano ~/.aws/credentials`.

```
[default]
aws_access_key_id = AKID1234567890
aws_secret_access_key = MY-SECRET-KEY
```

- To switch to AWS run `easy-jupyter use-aws`. This will create a new AWS instance of type t2.micro in the us-east-1 region.
  - To change the region of your instance you will need to go into the source of the `use-aws` command in scripts.
  - To change the instance size, use the AWS console - navigate to EC2 in the correct region, find the aws-sandbox instance and change the type by right clicking on the instance. The instance must be stopped for this change to work. You can also change the default size in the source code of this repo.

- Running this command will also replicate your current work folder onto the AWS instance. For now, you cannot skip this step so you should run `use-aws` in a folder which you want to be uploaded and/or a blank folder. This will also make it easier to pull files back from the AWS instance later. See the data management section below for more detail.

- Following this command, the run commands will run Jupyter on AWS but make it available at localhost:8888. You must still do the run command before connecting to AWS. The `use-aws` command prepares the environment but does not run Jupyter.

### 5B: Data Management/Workflow on AWS

When running on AWS, all changes are persisted to the remote VM and not your local computer. By default, the top-level Jupyter workspace will mirror the folder you first ran the `use-aws` command in. Following the initial `use-aws`, you can do to further commands to manage data:

- Run `easy-jupyter pull-from-aws` to pull the new file versions from AWS to your current directory. All local file versions will be overridden if the same file exists on the remote host. This command will download the files from active workspace folder on the VM (the last folder pushed via `push-to-aws`/`use-aws`). Note `pull-from-aws` pulls **the files** in the workspace but not the outer folder so the files will be replicated into the top level of your current directory. This works nicely with the suggested workflow below.

- Run `easy-jupyter push-to-aws` to sync the current folder and its contents to the remote. All remote versions will be overridden. The push command will reset the active workspace for Jupyter to use the folder that was just pushed. This means you can use `push-to-aws` to change the remote instance to a new workspace. You will need to restart Jupyter if you do change the active workspace in this way.

**Suggested Workflow**: create one project folder to use throughout the use/push/pull cycle. Do any local setup you want (usually nothing) and then run `use-aws` to replicate the work folder into AWS and set it as the active workspace. When you have done some work on the AWS instance, use `pull-from-aws` to persist the work back to your local folder. If you then make changes locally use `push-to-aws` to update any remote files before resuming work.



### 5C: Switching back to local

- When you're doneRun `easy-jupyter use-local` to switch back to your machine.

### 5D: Tearing-down AWS instances

- You MUST run `easy-jupyter stop-aws` (stops the instance, preserving files) and/or `easy-jupyter destroy-aws` (deletes the instance, deleting all files) when you are done working to avoid incurring charges for the EC2 box. Stopping will stop most charges except a small amount for data storage.
