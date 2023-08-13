# Use the official Node.js 18.16.0 image as the base image
FROM node:18.16.0

# Set working directory
WORKDIR /app

# Install necessary packages and utilities
RUN apt-get update && apt-get install -y \
    default-jdk \
    unzip \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables for Android SDK
ENV ANDROID_HOME /app/android-sdk
ENV PATH $PATH:$ANDROID_HOME/cmdline-tools/tools/bin:$ANDROID_HOME/platform-tools

# Download and install Android SDK command-line tools
RUN mkdir -p $ANDROID_HOME/cmdline-tools \
    && cd $ANDROID_HOME/cmdline-tools \
    && wget -q https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip -O cmdline-tools.zip \
    && unzip -q cmdline-tools.zip \
    && mv cmdline-tools latest \
    && rm cmdline-tools.zip

# Accept Android licenses
RUN yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --licenses

# Install Android build tools and platform
RUN $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager "build-tools;30.0.3" "platforms;android-30"

# Copy package.json and package-lock.json to the working directory
COPY package.json package-lock.json ./

# Install npm
RUN npm install

# ... (previous steps)

# Copy the rest of the app files, including gradlew script
COPY . .

WORKDIR /app/android

# Make the gradlew script executable
RUN chmod +x gradlew

# Build the APK using Gradle
RUN ./gradlew assembleRelease

