# Stage 1: Install all dependencies (including dev)
FROM node:25-alpine AS builder
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci

# Stage 2: Production-only image
FROM node:25-alpine
RUN apk update && apk upgrade --no-cache && rm -rf /var/cache/apk/*
ENV NODE_ENV=production
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --omit=dev \
    && npm cache clean --force \
    && rm -rf /usr/local/lib/node_modules/npm /usr/local/bin/npm /usr/local/bin/npx
COPY index.js ./
USER node
EXPOSE 3000
CMD ["node", "index.js"]
