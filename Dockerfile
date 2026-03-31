# Stage 1: Install all dependencies (including dev)
FROM node:22-alpine AS builder
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci

# Stage 2: Production-only image
FROM node:22-alpine
ENV NODE_ENV=production
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --omit=dev && npm cache clean --force
COPY index.js ./
USER node
EXPOSE 3000
CMD ["node", "index.js"]
