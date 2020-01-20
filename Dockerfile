FROM openjdk:8-jdk-stretch

RUN apt-get update && \
        apt-get install -y zip && \
        apt-get clean

# Downgrade to unpriviledged user.
RUN useradd -ms /bin/bash restli
USER restli
WORKDIR /home/restli

# Install SDKMAN and use it to easily install gradle
# at a specific version (I've read gradle 2.12 works).
SHELL ["/bin/bash", "-c"]
RUN curl -s "https://get.sdkman.io" | bash && \
        source "$HOME/.sdkman/bin/sdkman-init.sh" && \
        sdk install gradle 2.12

# Get rest.li code.
RUN git clone https://github.com/linkedin/rest.li.git
WORKDIR /home/restli/rest.li/examples/quickstart/

# Workaround for bug
# https://github.com/linkedin/rest.li/issues/88
RUN sed -i 's/19\.0\.3/11.0.17/g' build.gradle

# Build rest.li api, server and client.
RUN /home/restli/.sdkman/candidates/gradle/current/bin/gradle publishRestliIdl
RUN /home/restli/.sdkman/candidates/gradle/current/bin/gradle build

# Run the server.
ENTRYPOINT /home/restli/.sdkman/candidates/gradle/current/bin/gradle JettyRunWar
