# draw.io Interception Docker

This repo is for a Docker container which creates and runs draw.io with some
modifications for interception of some commands.

## Setup, Install, and Running

The only requirement is Docker. All configuration is handled through the
`main.js` and `modals.js` files. 

1. Install Docker (https://www.docker.com/)
2. Download this repo
   (https://github.com/MarsCapone/drawio-docker/archive/master.zip)
3. Unzip it and enter the directory.
4. Build the container.
   ```
   docker --no-cache --rm -it casperc/drawio --network=host .
   ```
5. Run the container, making sure to mount the `main.js`, and `modals.js` files.
   When running the container, you must decide which port it is going to run on.
   ```
   docker run --rm --name="draw" \
      -p <host-port>:8080 \
      -p 8443:8443 \
      -v /full/path/to/main.js>:/usr/local/tomcat/webapps/draw/js/interception/main.js \
      -v /full/path/to/modals.js>:/usr/local/tomcat/webapps/draw/js/interception/modals.js \
      -it casperc/drawio
   ```

The build script is included in `build.sh`. The run script is included in
`run.sh`.

## Configuration

There are two sections that need configuration, the `onpage` modal display, and
the edge text configuration.

### Modal Display

As there is no longer an file to edit, modals that were going to be included in
HTML, now need to be included as string elements of the array `Modals` in
`modals.js`. Some examples are provided in the file.

In order to utilise the modal control, the data action of any given node should
be:

```
data:action/customjs,{"fun": "<function_name>", "args": <list_of_args> }
```

`<function_name>` can be any function that is a member of the `Interception`
object. `<list_of_args>` should be an array of arguments that will be provided
to the function.

#### Default Action

The default action is to display a modal from the `Modals` array by referencing
the `id` of the modal. 

```
data:action/customjs,{"fun": "onpage","args":["include"]}
```

This example runs the `Interception.onpage` function, which displays the modal
with the id `include`.

### Edge Text Interception

In order to configure edge texts in `ex` mode, you must modify the `main.js`
file. This exposes the `Interception` object. 

The function `Interception.edge(e, b)` is run for each visible edge in ex-mode.

An example is provided in `main.js`.

In order to utilise this function, edges should have text in the form:

```
edge-text::Custom content goes here
```



