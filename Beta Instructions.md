# Beta Instructions

## Welcome

Thanks for your interest in helping to test Easy Jupyter!

All the instructions you need to install and run (along with the code itself) are here: https://github.com/JoshBroomberg/easy-jupyter.

It is working well on my machine, but obviously I expect you to run into bugs or weird/unexpected design during install and operation. Please email/chat me with any feedback/problems.

Generally, I want this to be a pain-free experience for beginners and to given more experienced people the freedom they need to do their thing. So:

- If something requires hacking to make it work, that's a bug.
- If you are constrained, that's a bug.
- If you don't understand the docs, that's a bug.

Just a note: you will need Docker to run this which means you will need to install it if you don't have it. You will also automatically pull the image when you first run the notebook commands. Together this will be ~4Gb of data download. So only do this if you're on uncapped wifi.

## Re-installing new versions

To re-install Easy Jupyter, follow the steps below:

- `rm -rf ~/.easy_jupyter`
- `cd <path to the repo on your computer>` (this is the location in which you cloned the repo, something like: `~/Downloads/easy-jupyter`.
- `bash install.sh`
- `source ~/.bash_profile`.
- `easy-jupyter test-config` to test that it worked!

I will include an update command in a future releases to make this less annoying.
