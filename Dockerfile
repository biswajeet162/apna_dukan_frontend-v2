# Build stage
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

# Copy files and pre-fetch dependencies
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get --no-analytics

# Copy the rest of the code and build
COPY . .
RUN flutter config --no-analytics
RUN flutter build web --release

# Run stage
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

