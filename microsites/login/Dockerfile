FROM node:18-alpine AS base

FROM base AS builder
# Check https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine to understand why libc6-compat might be needed.
RUN apk update
RUN apk add --no-cache libc6-compat
# Set working directory
WORKDIR /app
RUN npm install -g turbo
COPY . .
RUN turbo prune @micro-site/login --docker

# Add lockfile and package.json's of isolated subworkspace
FROM base AS installer
RUN apk update
RUN apk add --no-cache libc6-compat
WORKDIR /app

# First install the dependencies (as they change less often)
COPY .gitignore .gitignore
COPY --from=builder /app/out/json/ .
COPY --from=builder /app/out/package-lock.json ./package-lock.json
# We added --force because we are using react and next.js rc versions; fell free to remove it!
RUN npm install --force

# Build the project
COPY --from=builder /app/out/full/ .
COPY turbo.json turbo.json
COPY micro-config.json micro-config.json
# Uncomment and use build args to enable remote caching
# ARG TURBO_TEAM
# ENV TURBO_TEAM=$TURBO_TEAM

# ARG TURBO_TOKEN
# ENV TURBO_TOKEN=$TURBO_TOKEN

RUN npm install -g turbo
RUN turbo build --filter=@micro-site/login...

FROM base AS runner
WORKDIR /app

# Don't run production as root
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs
USER nextjs

COPY --from=installer /app/microsites/login/next.config.mjs .
COPY --from=installer /app/microsites/login/package.json .

# Automatically leverage output traces to reduce image size
# https://nextjs.org/docs/advanced-features/output-file-tracing
COPY --from=installer --chown=nextjs:nodejs /app/microsites/login/.next/standalone ./
COPY --from=installer --chown=nextjs:nodejs /app/microsites/login/.next/static ./microsites/login/.next/static
COPY --from=installer --chown=nextjs:nodejs /app/microsites/login/public ./microsites/login/public

CMD node microsites/login/server.js
