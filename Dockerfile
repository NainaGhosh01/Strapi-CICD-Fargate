# Use Node 18 official image
FROM node:18

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy all the project files
COPY . .

# Build the Strapi Admin panel
RUN npm run build

# Expose the port Strapi runs on
EXPOSE 1337

# Start Strapi in production mode
CMD ["npm", "run", "start"]
