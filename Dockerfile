FROM ubuntu:20.04

# Prerequisites
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y curl git unzip xz-utils zip libglu1-mesa openjdk-8-jdk wget

# Set up new user
RUN useradd -ms /bin/bash developer
USER developer
WORKDIR /home/developer

# Prepare Android directories and system variables
RUN mkdir -p Android/sdk/cmdline-tools
ENV ANDROID_SDK_ROOT="/home/developer/Android/sdk"
RUN mkdir -p .android && touch .android/repositories.cfg

# Set up Android SDK
RUN wget -O commandlinetools.zip https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip
RUN unzip commandlinetools.zip && rm commandlinetools.zip
RUN mv cmdline-tools Android/sdk/cmdline-tools/tools
ENV PATH="$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/cmdline-tools/tools/bin"
RUN cd Android/sdk/cmdline-tools/tools/bin && yes | ./sdkmanager --licenses
RUN cd Android/sdk/cmdline-tools/tools/bin && ./sdkmanager "build-tools;30.0.0" "patcher;v4" "platform-tools" "platforms;android-30" "sources;android-30"
ENV PATH "$PATH:/home/developer/Android/sdk/platform-tools"

# Download Flutter SDK
RUN git clone https://github.com/flutter/flutter.git
ENV PATH "$PATH:/home/developer/flutter/bin"

# Run basic check to download Dark SDK
RUN flutter doctor