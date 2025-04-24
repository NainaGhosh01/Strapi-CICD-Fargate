FROM node:18-bullseye

# Set working directory
WORKDIR /app

# Install required system dependencies
RUN apt-get update && apt-get install -y build-essential libsqlite3-dev

# Copy package files and install dependencies
COPY my-strapi/package*.json ./
RUN npm install

# Rebuild native modules like better-sqlite3
RUN npm rebuild

# Copy the rest of the code
COPY my-strapi/ .

# Build Strapi for production
RUN npm run build

# Expose Strapi port
EXPOSE 1337

# Start Strapi in production
CMD ["npm", "run", "start"]