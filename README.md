# OMSCS GIOS Devenv
This project was created to provide a Dockerized development environment which supports debugging
on M1 and intel Macs, as well as Linux (not tested). It is a convenience script which was used to forward
ports for the debugger, automatically mount project directories, etc.

## Features
- Automated wireshark capture of container traffic with `devenv --capture`

## Quickstart
Build the docker image
```console
make build
```

Add the project to your path
```console
DEVENV_PROJ=
export PATH="$DEVENV_PROJ:$PATH"
```

```console
devenv --start
devenv -- make
```

# Start the debugger on remote
```bash
devenv -- ROSETTA_DEBUGSERVER_PORT=8888 ./gfserver_main
```

This command will connect to the remote debug server included with Rosetta over port 8888 (already forwarded as part
of the script).
```bash
ASAN_OPTIONS=detect_leaks=0 \
LSAN_OPTIONS=verbosity=1:log_threads=1 \
gdb \
-ex 'set architecture i386:x86-64' \
-ex 'file gfserver_main' \
-ex 'target remote localhost:8888'
```
