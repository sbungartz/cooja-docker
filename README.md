# cooja-docker
A docker container that has all the dependencies to run the [Contiki][contiki] Cooja simulator with the native *Cooja-Motes*.

## Usage

### Start GUI
On a Linux host you can start the cooja GUI like this:
```bash
sudo docker run -it --rm -e DISPLAY --net=host sbungartz/cooja ant run
```
Using `-e DISPLAY` to pass on the `$DISPLAY` environment variable and `--net=host` to expose the X11 unix socket 
(and all other sockets of course) will allow the Java app in the container to show the GUI window on your host system.

Now you could for example try to run a Simulation with a cooja host mote.

### Work with project files
To work with project files on your host system you should mount it into the container.
You can just mount your own home directory to the exact same path in the container, so all paths stay the same:
```bash
sudo docker run -it --rm -e DISPLAY --net=host -v "$HOME:$HOME" sbungartz/cooja ant run
```
**TODO** UID / GID only accidentally match on host and container. Test with setting uid/gid in `docker run`.

### Run headless simulation
Say you want to run the simulation from `simulation.csc` in your current working directory on your host system (somewhere in `$HOME`).
You can do that using:
```bash
sudo docker run -it --rm -v "$HOME:$HOME" sbungartz/cooja ant run -Dargs="-nogui=$PWD/simulation.csc"
```
Note that you don't need `-e DISPLAY` or `--net=host` when running without GUI.

To get some data out of there write a [simulation script][simscript] that writes something to one or more output files.
Unfortunately it places these into the working directory of Cooja, which is inside the container.
So you could pass an environment variable with the directory where you want to put your output files.
Running our docker command from the simulation directory, we might just want to put them into this directory.
So we can pass this environment variable using
```bash
sudo docker run -it --rm -v "$HOME:$HOME" -e RUNDIR="$PWD"  sbungartz/cooja ant run -Dargs="-nogui=$PWD/simulation.csc"
```
In our simulation script we can now access this variable with
```javascript
importPackage(java.lang);
rundir = System.getenv().get('RUNDIR')
```


[contiki]: https://github.com/contiki-os/contiki
[simscript]: https://github.com/contiki-os/contiki/wiki/Using-Cooja-Test-Scripts-to-Automate-Simulations
