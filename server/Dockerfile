FROM node:20-slim

WORKDIR /app

# Install pnpm
RUN npm install -g pnpm

# Copy monorepo root files
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./

# Copy packages
COPY packages/ ./packages/
COPY server/ ./server/

# Install all dependencies
RUN pnpm install --frozen-lockfile

# Build shared packages first, then server
RUN pnpm --filter @paperclipai/shared build || true
RUN pnpm --filter @paperclipai/db build || true  
RUN pnpm --filter @paperclipai/adapter-utils build || true
RUN pnpm --filter @paperclipai/adapter-openclaw build || true
RUN pnpm --filter @paperclipai/server build

WORKDIR /app/server

EXPOSE 3100

CMD ["node", "dist/index.js"]
