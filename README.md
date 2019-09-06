# Easy Jupyter

Run Jupyter notebooks on your machine and in the cloud with one command.

## Why Easy Jupyter?

Jupyter is great but maintaining a stable installation and environment can be painful - especially when you want to use more advanced functionality. Easy Jupyter gives you a clean, up-to-date and feature-rich environment + running server in one command.

**Make Jupyter Great (Again)**

With Easy Jupyter, you get:
 - Kernels for Python 3, Python 2 (coming soon), R and Julia.
 - Seamless PDF export with improved templates for easy project submission.
 - Pre-configured extensions for spell-check, python in markdown, live markdown previews etc
 - Themes which improve the look and feel of notebooks.
 - Pre-configured compatibility with Google Colab to run Colab notebooks with local resources.

**Run Jupyter in the Cloud**

Move Easy Jupyter from local to cloud execution with one command to access more CPUs, GPUs and RAM. Easy Jupyter will:

- Help you manage the life-cycle of your AWS instance with minimal AWS know-how.
- Keep your environment and config completely consistent across local and remote servers.
- Allow you to connect to the remote Jupyter server without any manual authentication/routing.
- Provide two way file sync to make moving data and code painless.

**Run Large Experiments on Cloud Clusters**

Easy Jupyter includes tools which make it easy to launch and connect to [Ray](https://github.com/ray-project/ray) clusters. [Ray](https://github.com/ray-project/ray) is a powerful tool for running Python jobs on clusters of machines. [Ray-Tune](https://ray.readthedocs.io/en/latest/tune.html) makes it easy to run experiments/searches over large parameter spaces on many machines - great for ML/Modeling.

## 1. Installation

**NOTE: Easy Jupyter is Mac/Linux only**. This will change soon.

- Install Docker and launch the docker Daemon.
  - The best way to install Docker is via the docker Desktop app. Find the mac install link [here](https://docs.docker.com/docker-for-mac/install/)
  - To launch the Docker daemon with the Mac app, simply open the application and wait until the status in the menu bar shows that docker has launched.
  - Note that the number of cores/RAM can be set under advanced preferences in the Docker menu bar app. These settings control the resources available to Jupyter.

- Clone this repository and cd into it: `git clone git@github.com:JoshBroomberg/easy-jupyter.git && cd easy-jupyter`

- Run `bash install.sh && source ~/.bash_profile`. This will install the execution shim into your bash profile and reload your terminal.

  - If you get a permission error, you may need to make this file executable with `chmod +x ./install.sh`.
  - You need to run `source ~/.bash_profile` in every terminal window which was open prior to install. It may be easier to simply restart the terminal.


- You can now use the `easy-jupyter` command line function to interact with Jupyter. Run `easy-jupyter test-config` to check that everything is set up right!

- If the test step doesn't work, restart your terminal and try again.

## 2. Running Jupyter Locally

For the commands below to work, you must have the docker daemon turned on. You should see a Docker icon in your menu bar.

- Run `easy-jupyter notebook` to run Jupyter notebook locally. The server will be available at `localhost:8888`.
- Run `easy-jupyter lab` to run Jupyter Lab locally. It will be available in the same location.

NOTE: just like with Jupyter, the directory in which you run these commands will become the root directory for your notebook server. Any changes you make from the notebooks/server will reflect instantly in this directory. *This isn't true when running on AWS, see section 4 below*.

## 3. Running Jupyter on AWS

**NOTE: Running on AWS will incur costs. You should only use AWS if you are comfortable incurring these costs. Pricing for instance types per hour can be found [here](https://aws.amazon.com/ec2/pricing/on-demand/).**

### 3A: Setup an AWS Account and Provide Access (Once Off)

- Create an AWS account and/or log in to your AWS console. Navigate to IAM and create a user with **Programmatic Access** and **Administrator Permissions**.
  - There is a guide for this [here](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html#id_users_create_console).
  - Don't forget to write down the access key and secret key in a safe place for the next step.


- Create a file at `~/.aws/credentials` with content which follows the format below. You can run `nano ~/.aws/credentials`, paste in the text below and then press `ctrl+o`, `enter`, `ctrl+x`.

```
[default]
aws_access_key_id = AKID1234567890
aws_secret_access_key = MY-SECRET-KEY
```

### 3B: Initializing an AWS instance

- To switch to AWS run `easy-jupyter aws-here`. This will create a new AWS instance of type t2.micro in the us-east-1 region. COMING SOON: command line options for instance size and region.

- Running this command will set your current folder as the **AWS working directory** and replicate its content onto the AWS instance. You should run `aws-here` in the folder which you want to be your active work folder for this AWS session.

- Running `easy-jupyter notebook` will now run Jupyter on AWS and but make it available at `localhost:8888`.

### 3B: Data Management/Workflow on AWS

When running on AWS, all changes are persisted to the remote VM and not your local computer. When you first start the AWS instance, the Jupyter workspace will mirror the folder you ran the `aws-here` command in. As you make changes on AWS, or locally, use the commands below to manage your files:

- Run `easy-jupyter pull-from-aws` to pull new file versions from AWS to your work directory. All local file versions will be overridden if the same file exists on the remote host.
  - This command will always pull the **AWS working directory** - the remote version of the folder where `aws-here` was called.
  - This command pulls **the files** in the folder but not the outer folder so the files will placed directly in your local working directory.


- Run `easy-jupyter push-to-aws` to sync the local working directory folder to AWS. All remote versions will be overridden.

**Suggested Workflow**:

- Create a project folder to use throughout the use/push/pull cycle.
- Do any local setup you want (usually nothing) and then run `aws-here` to replicate the work folder into AWS and set it as the active working directory.
- When you have done some work on the AWS instance, use `pull-from-aws` to persist the work back to your local folder.
- If you then make changes locally use `push-to-aws` to update any remote files before resuming work.

### 3C: Tearing-down AWS instances

- You MUST stop/destroy your AWS instance to stop incurring costs at the end of a session.

- Run `easy-jupyter stop-aws` to stop the instance but preserve remote files. Stopping will stop most charges except a small amount for data storage.

- Run `easy-jupyter destroy-aws` to delete the instance and delete all remote files.

### 3D: Switching back to local without stopping AWS

If you want to run locally without stopping the AWS instance, do the following:

- Stop the Jupyter process on AWS with ctrl + C (as usual)

- Then run `easy-jupyter pause-aws`.

- Finally, run `easy-jupyter notebook` to start a local notebook server in your current location. As normal, the directory where you run this command will become the active working directory.

- You can then switch back to the already running AWS instance with `easy-jupyter aws-here`. The location where this command is run will become your active remote directory as usual.

## 4. Terminal

If you need a terminal within the Jupyter server context - for example to download datasets using wget - you can run the command `easy-jupyter terminal`

**NOTE:** In order for the command below to work, you need to be running the notebook/lab server in a different terminal tab using the standard `easy-jupyter` commands.

**NOTE:** Changes you make to files in the Jupyter Working Directory will be saved. But changes you make to the environment from this terminal **will not** persist after you shut down the container. Python packages or config changes should be made using the instructions below.

## 5. Customizing Jupyter

Easy Jupyter uses a pre-built image to run Jupyter. In order to install new packages or change how Jupyter is 'installed', you will need to create a new image. We provide commands which make this very straight forward:

- When you make a change using the instructions below, you will need to run `easy-jupyter build-image` **once** per machine. Your changes will then be used on every future run of Jupyter on that machine.

- **NOTE:** as stated above, you will need to run the build command once per machine. This means each time you run `destroy-aws` and then `aws-here` (creating a new AWS instance) you will need to run the `build-image` command.

- We hope to improve this in the future to allow all machines to use the same image version.

**Switching back to the vanilla image...**

- To switch back to the original version of the image, run `easy-jupyter destroy-image`. This will remove your local, custom image.

- Per the logic above, you need to run this once per machine. So, if you ran the destroy locally, you will need to run it again after activating AWS (if you built your custom image for AWS). It may be easiest to simply destroy and recreate the AWS machine for a clean start.

- You should revert your changes to the Dockerfile and/or requirements.txt if you no longer need them. Feel free to copy the latest available Dockerfile from [here](https://raw.githubusercontent.com/JoshBroomberg/easy-jupyter/master/src/docker/Dockerfile) and `requirements.txt` from [here](https://raw.githubusercontent.com/JoshBroomberg/easy-jupyter/master/src/docker/requirements.txt).

### 5A: Adding new python packages

- Add the package to the `requirements.txt` file located at `~/.easy_jupyter/docker/requirements.txt`. Use the standard `name==version` format for adding packages.
- You can create formatted requirements file contents from your local python env by running `pip freeze` and then copy-paste the output to the file.
- Rebuild your image with `easy-jupyter build`.

### 5B: Customizing the Runtime

- You can edit the docker file at `~/.easy_jupyter/docker/Dockerfile` to make changes to the core installation of Jupyter or change anything else about the configuration of the runtime. Any changes here will also require rebuilds.

### 5C: Customizing Jupyter Config

- A copy of the standard Jupyter Config files are provided (with tweaks) in the folder: `~/.easy_jupyter/jupyter_config`. This folder is mounted onto the jupyter container at run time so changes here **do not require rebuilds**.

   1. Changes made from the Jupyter UI - like activating extensions - are persisted beyond the container life-cycle and will be used on the next run.

   2. Changes made to the files in this folder are used by Jupyter at run time. For example, you could add a new nbconvert template in this folder and use it in server. You must restart the server for changes in the config to take effect.

## 6. Themes

This package uses the [Jupyter Themes](https://github.com/dunovank/jupyter-themes) package to change the appearance of Jupyter. This allows granular control of color, font size, menu options etc.

In order to deactivate styling, run the notebook server as normal and then run this command in a separate terminal tab:

```
docker exec -it jupyter_server jt -r
```

In order to customize the styling, use any of the options from the extensive README on the package and run the command below using the same procedure as above (jupyter running in one tab):

```
docker exec -it jupyter_server jt [your JT options]
```

This command is useful for setting the font sizes for code, text and output respectively.

```
docker exec -it jupyter_server jt -t grade3 -fs 12 -tfs 12 -ofs 13
```

## 7. Ray Clusters

Coming Soon...
