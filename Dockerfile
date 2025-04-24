# Use Node.js base image
FROM node:18

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the app
COPY . .

# Build the Strapi project (creates /dist folder)
RUN npm run build

# Expose Strapi default port
EXPOSE 1337

# Run the compiled Strapi app
CMD ["node", "dist/server.js"]
