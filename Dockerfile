FROM node:20-slim

WORKDIR /app

# Install pnpm
RUN npm install -g pnpm@9

# Copy package files
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY packages/ ./packages/
COPY server/ ./server/

# Install dependencies
RUN pnpm install --frozen-lockfile

# Build packages in dependency order
RUN pnpm --filter @paperclipai/shared build 2>/dev/null || true
RUN pnpm --filter @paperclipai/db build 2>/dev/null || true
RUN pnpm --filter @paperclipai/adapter-utils build 2>/dev/null || true
RUN pnpm --filter @paperclipai/server build

WORKDIR /app/server
EXPOSE 3100
CMD ["node", "dist/index.js"]
