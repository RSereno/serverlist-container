#
# Stage 1: Build stage
#
FROM maven:3.8.4-openjdk-11 AS build

WORKDIR /app
# Clone the source code from GitHub
RUN git clone https://github.com/RSereno/BedrockConnect.git
# Change to the cloned directory
WORKDIR /app/BedrockConnect/serverlist-server
# Build the jar file
RUN mvn clean package -Djar.name=bedrock-connect.jar

# Show Version
RUN apk add --no-cache curl && \
   BEDROCKCONNECT_VERSION=$(curl -sX GET "https://api.github.com/repos/RSereno/BedrockConnect/releases/latest" \
        | awk '/tag_name/{print $4;exit}' FS='[""]') && \
        echo "Version build of BedrockConnect: $BEDROCKCONNECT_VERSION"; \
apk del curl

#
# Stage 2: Execution stage
#
FROM openjdk:11-jre-slim

# Set default environment variables
ENV useDB=false
ENV featured_servers=false
ENV allowUIServerManagement=false

# Set the working directory
WORKDIR /app

# Copy the BedrockConnect jar and configuration files
COPY ./config/custom_servers.json ./config/servertext_en.json ./config/

# Copy the jar file from the build stage
COPY --from=build /app/BedrockConnect/target/bedrock-connect.jar .


# Expose the BedrockConnect port
EXPOSE 19132/udp

# Copy entrypoint script
COPY entrypoint.sh /app/entrypoint.sh

# Make entrypoint script executable
RUN chmod +x /app/entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/app/entrypoint.sh"]
