# Use an official Node.js image as the base
FROM node:14

# Install Android SDK and necessary dependencies
RUN apt-get update && \
    apt-get install -y openjdk-11-jdk wget unzip && \
    mkdir -p /android-sdk/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip -O /tmp/tools.zip && \
    unzip -q /tmp/tools.zip -d /android-sdk/cmdline-tools && \
    rm /tmp/tools.zip

# Set environment variables for Android
ENV ANDROID_HOME /android-sdk
ENV PATH $PATH:$ANDROID_HOME/cmdline-tools/tools/bin:$ANDROID_HOME/platform-tools

# Set the working directory
WORKDIR /app

# Expose the default React Native port
EXPOSE 8081

# Start the container with a shell
CMD [ "sh" ]
