FROM node:18

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

# Create .tmp folder for SQLite
RUN mkdir -p .tmp

# Build Strapi admin panel
RUN npm run build

EXPOSE 1337

CMD ["npm", "run", "develop"]
