# Easy Jupyter

Save yourself the pain of a messy python environment. Run Jupyter Notebooks and Lab inside pre-configured docker.
The images below allow you to install your own packages and to connect to Jupyter from Google Colab.

## 1. Initial setup

- Install Docker and launch the docker Daemon. Note that the number of cores/RAM can be set under preferences in Docker.
  The resource constraints of docker will affect the resources available to Jupyter.
- Clone this repository and place it into a location where you are comfortable keeping it for as long as you will use this project (we keep scripts in the repo rather than installing anything into your default bin folders).
- cd into the repository on your local machine: `$ cd /path/to/repo`
- Build the docker image by running `$ bash bin/build.sh` (You may need to make this file executable `chmod +x bin/build.sh)`. 
- Add the following line to your bash profile or equivalent: `export PATH=$PATH:/path/to/repo}/bin`.
  You'll normally find this at `~/.bash_profile`. Don't forget to append '/bin' to the end of the path to your repo.
- Restart your terminal before proceeding.

## 2. Running

- To run Jupyter Notebook run this command in a terminal window: `run-jupyter-notebook`
- To run Jupyter Lab run this command in a terminal window: `run-jupyter-lab`
