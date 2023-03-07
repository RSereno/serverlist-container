FROM openjdk:latest

# Set default environment variables
ENV useDB=false
ENV featured_servers=false
ENV allowUIServerManagement=false

# Set the working directory
WORKDIR /app

# Copy the BedrockConnect jar and configuration files
COPY config/custom_servers.json config/servertext_en.json ./config/
ADD https://github.com/Pugmatt/BedrockConnect/releases/latest/download/BedrockConnect-1.0-SNAPSHOT.jar /app

# Expose the BedrockConnect port
EXPOSE 19132/udp

# Set entrypoint script to display startup message
ENTRYPOINT ["sh", "-c", "echo \"[$(date)] Starting $CONTAINER_NAME container with the following variables:\" && echo \"useDB=$useDB\" && echo \"featured_servers=$featured_servers\" && echo \"allowUIServerManagement=false\n\n\" && exec \"$@\"", "--"]

# Define the command to run
# CMD if [ "$useDB" = true ]; then java -Xms512M -Xmx512M -jar BedrockConnect-1.0-SNAPSHOT.jar nodb=false user_servers=false custom_servers=/app/config/custom_servers.json language=/app/config/servertext_en.json featured_servers="$featured_servers"; else java -Xms512M -Xmx512M -jar BedrockConnect-1.0-SNAPSHOT.jar nodb=true user_servers=false custom_servers=/app/config/custom_servers.json language=/app/config/servertext_en.json featured_servers="$featured_servers"; fi

# Desactivating SQL Use temporary
CMD java -Xms512M -Xmx512M -jar BedrockConnect-1.0-SNAPSHOT.jar nodb=true user_servers="$allowUIServerManagement" custom_servers=/app/config/custom_servers.json language=/app/config/servertext_en.json featured_servers="$featured_servers"


# Add exit message
#CMD ["sh", "-c", "trap 'echo \"[$(date)] Stopping $HOSTNAME container\"' EXIT && sleep infinity"]