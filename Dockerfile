# Stage 1 - Install dependencies and build the app
FROM debian:latest AS build-env
# Install flutter dependencies
RUN apt-get update
RUN apt-get install -y curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback lib32stdc++6 python3
RUN apt-get clean
# Clone the flutter repo
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
# Set flutter path
# RUN /usr/local/flutter/bin/flutter doctor -v
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"
# Enable flutter web
RUN flutter channel stable
RUN flutter upgrade
# Run flutter doctor
RUN flutter doctor -v
# Trigger a first build to download dependencies
RUN flutter build web || true
# Copy files to container and build
WORKDIR /app
COPY . /app
# Get dependencies
RUN flutter pub get
# Use html renderer for compatibility with fl_chart
# Change to canvaskit in the future when compatibility is restored
RUN flutter build web --web-renderer html --release
# Stage 2 - Create the run-time image
FROM nginx
COPY --from=build-env /app/build/web /usr/share/nginx/html