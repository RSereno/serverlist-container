#!/bin/sh

# Start BedrockConnect
echo "[$(date)] Starting  $CONTAINER_NAME container...with the following variables:\" && echo \"useDB=$useDB\" && echo \"featured_servers=$featured_servers\" && echo \"allowUIServerManagement=false\n\n\"
java -Xms512M -Xmx512M -jar bedrock-connect.jar nodb=true user_servers=false custom_servers=/app/config/custom_servers.json language=/app/config/servername.json featured_servers=$FEATURED_SERVERS

echo "BedrockConnect container stopped."
