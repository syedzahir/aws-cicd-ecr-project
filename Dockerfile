# Use an official NGINX image as the base
FROM nginx:latest

# Copy HTML files to the appropriate directory
COPY index.html /usr/share/nginx/html/

# Copy custom NGINX configuration if any
# COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80