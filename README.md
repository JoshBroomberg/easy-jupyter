# Easy Jupyter

Run Jupyter notebooks without the pain of a messy python/conda environment. This repo provides an easy way to run Jupyter tools
inside clean, flexible docker containers.

The solution below will allow you to:
 - Launch a notebook server with one command - Python3, R and Julia are supported out the box.
 - Persist your work to your hard drive - no additional work required.
 - Install your own Python packages - install once, use forever. 
 - Connect to Jupyter from Google Colab - for added power with the Colab interface and tools.

## 1. Initial setup

- Install Docker and launch the docker Daemon. Note that the number of cores/RAM can be set under preferences in Docker.
  The resource constraints of docker will affect the resources available to Jupyter.
- Clone this repository and place it into a location where you are comfortable keeping it for as long as you will use this project (we keep scripts in the repo rather than installing anything into your default bin folders).
- cd into the repository on your local machine: `$ cd /path/to/repo`
- Build the docker image by running `$ bash bin/build.sh` (You may need to make this file executable `chmod +x bin/build.sh)`. 
- Add the following line to your bash profile or equivalent: `export PATH=$PATH:{/path/to/repo}/bin`. Replace `{/path/to/repo}` with the literal path to your repo.
  You'll normally find this at `~/.bash_profile`. Don't forget to append '/bin' to the end of the path to your repo.
- Restart your terminal before proceeding.

## 2. Running

- To run Jupyter Notebook run this command in a terminal window: `run-jupyter-notebook`
- To run Jupyter Lab run this command in a terminal window: `run-jupyter-lab`

NOTE: the directory in which you run this command will become the root directory for your notebook server. Any changes you make from the notebooks/server
 will be persisted to this folder.

## 3. Adding new packages

- Add the package to the `requirements.txt` file in the repo.
- Rebuild your image with `bash bin/build.sh` (you must be in the repo folder to do this)
