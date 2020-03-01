# rest.li docker image

### A Docker image that runs rest.li quickstart example.

If you want to play around with LinkedIn [rest.li](http://rest.li) framework, what are you going to do? Well, google -> docs -> [Step by Step Tutorial](https://linkedin.github.io/rest.li/start/step_by_step); chances are that you wont get far.

For me (ubuntu 16.04, gradle 2.10) it fails at _Step 1 Define Data Schema_ (btw it seems that the `.pdl` format got depracated in favor of a newer? JSON based `.pdsc`). If you fix this then it'll fail at `build` complaining about a wrapper already present or something like that.

Enough for me, time to abandon the tutorials and go straight to the sources. Luckily there is a good set of examples, and the [quickstart](https://github.com/linkedin/rest.li/tree/master/examples/quickstart) one seems trivial.

To make things a bit more "repeatable" and not pollute the local machine with java stuff, I built a docker image that gets the quickstart up and running.

> :warning: The docker image gets and runs stuff (SDKMAN, gradle, rest.li, ...) installed from the internet, be sure to trust the sources before running it locally.

## Using the docker image

Start the image with a simple:

```
make start
```

it'll build the docker image (which compiles and runs the server), run the image (bind port 8080), and tail the logs. The server is ready when you see a line like this one:

```
[...]:INFO:oejs.AbstractConnector:Started SelectChannelConnector@0.0.0.0:8080
```

at that point you can GET some data:

```
$ curl -v http://127.0.0.1:8080/fortunes/1
*   Trying 127.0.0.1...
* Connected to 127.0.0.1 (127.0.0.1) port 8080 (#0)
> GET /fortunes/1 HTTP/1.1
> Host: 127.0.0.1:8080
> User-Agent: curl/7.47.0
> Accept: */*
>
< HTTP/1.1 200 OK
< Content-Type: application/json
< X-RestLi-Protocol-Version: 1.0.0
< Content-Length: 38
< Server: Jetty(8.y.z-SNAPSHOT)
<
* Connection #0 to host 127.0.0.1 left intact
{"fortune":"Today is your lucky day."}
```

To try the client simply call it on the container:

```
$ docker exec -it rest-li-tutorial /home/restli/.sdkman/candidates/gradle/current/bin/gradle startFortunesClien
:api:generateDataTemplateConfiguration
There are 1 data schema input files. Using input root folder: /home/restli/rest.li/examples/quickstart/api/src/main/pegasus
:api:generateDataTemplate UP-TO-DATE
:api:compileMainGeneratedDataTemplateJava UP-TO-DATE
:api:mainCopyPdscSchemas UP-TO-DATE
:api:processMainGeneratedDataTemplateResources UP-TO-DATE
:api:mainGeneratedDataTemplateClasses UP-TO-DATE
:api:mainDataTemplateJar UP-TO-DATE
:api:generateMainGeneratedRestRestClient UP-TO-DATE
:api:compileMainGeneratedRestJava UP-TO-DATE
:api:processMainGeneratedRestResources UP-TO-DATE
:api:mainGeneratedRestClasses UP-TO-DATE
:api:mainRestClientJar UP-TO-DATE
:client:compileJava UP-TO-DATE
:client:processResources UP-TO-DATE
:client:classes UP-TO-DATE
:client:startFortunesClient
SLF4J: Failed to load class "org.slf4j.impl.StaticLoggerBinder".
SLF4J: Defaulting to no-operation (NOP) logger implementation
SLF4J: See http://www.slf4j.org/codes.html#StaticLoggerBinder for further details.
Today is your lucky day.

BUILD SUCCESSFUL

Total time: 9.148 secs

This build could be faster, please consider using the Gradle Daemon: https://docs.gradle.org/2.12/userguide/gradle_daemon.html
```

Other useful commands:

* `make clear-docker` to stop and remove the image.
* `make attach-docker` to get a prompt on the running container.
