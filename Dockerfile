# --- STAGE 1: Build NestJS Application ---
FROM node:18-alpine AS builder
WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

# --- STAGE 2: Production Image (Siêu nhẹ) ---
FROM node:18-alpine
WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

# Copy thư mục dist đã build từ Stage 1 sang Stage 2
COPY --from=builder /app/dist ./dist

EXPOSE 3000
CMD ["node", "dist/main.js"]