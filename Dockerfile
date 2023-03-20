FROM openjdk:17-alpine

# Set default environment variables
ENV useDB=false
ENV featured_servers=false
ENV allowUIServerManagement=false
ENV BEDROCKCONNECT_VERSION=latest

# Set the working directory
WORKDIR /app

# Copy the BedrockConnect jar and configuration files
COPY ./config/custom_servers.json ./config/servertext_en.json ./config/

RUN apk add --no-cache wget

# Get latest version of bedrock jar
RUN apk add --no-cache curl && \
    if [ "$BEDROCKCONNECT_VERSION" = "latest" ]; then \
        BEDROCKCONNECT_VERSION=$(curl -sX GET "https://api.github.com/repos/Pugmatt/BedrockConnect/releases/latest" \
        | awk '/tag_name/{print $4;exit}' FS='[""]') && \
        echo "Latest version of BedrockConnect is $BEDROCKCONNECT_VERSION"; \
    fi && \
    curl -o /app/BedrockConnect.jar -sL "https://github.com/Pugmatt/BedrockConnect/releases/download/$BEDROCKCONNECT_VERSION/BedrockConnect-1.0-SNAPSHOT.jar" && \
    apk del curl

# Expose the BedrockConnect port
EXPOSE 19132/udp

# Set the entrypoint
ENTRYPOINT ["sh", "-c", "echo \"[$(date)] Starting  $CONTAINER_NAME container with the following variables:\" && echo \"useDB=$useDB\" && echo \"featured_servers=$featured_servers\" && echo \"allowUIServerManagement=false\n\n\" && java -Xms512M -Xmx512M -jar BedrockConnect.jar nodb=true user_servers=false custom_servers=/app/config/custom_servers.json language=/app/config/servertext_en.json featured_servers=$featured_servers && echo BedrockConnect container stopped."]
