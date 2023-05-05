#!/bin/sh

# Get the current version of BedrockConnect
CURRENT_VERSION=$(java -jar BedrockConnect-*.jar --version | awk '{print $2}')

# Get the latest version of BedrockConnect from GitHub
LATEST_VERSION=$(curl -sX GET "https://api.github.com/repos/Pugmatt/BedrockConnect/releases/latest" | grep tag_name | cut -d '"' -f 4)

# Compare the versions and update the jar file if necessary
if [ "$CURRENT_VERSION" != "$LATEST_VERSION" ]; then
    echo "Updating BedrockConnect to version $LATEST_VERSION"
    curl -o BedrockConnect.jar -sL "https://github.com/Pugmatt/BedrockConnect/releases/download/$LATEST_VERSION/BedrockConnect.jar"
fi

# Start BedrockConnect
echo "[$(date)] Starting  $CONTAINER_NAME container...with the following variables:\" && echo \"useDB=$useDB\" && echo \"featured_servers=$featured_servers\" && echo \"allowUIServerManagement=false\n\n\"
java -Xms512M -Xmx512M -jar BedrockConnect-*.jar nodb=true user_servers=false custom_servers=/app/config/custom_servers.json language=/app/config/servername.json featured_servers=$FEATURED_SERVERS

echo "BedrockConnect container stopped."
