# ---- 基础镜像 ----
FROM node:22.19.0-bullseye

# ---- 环境变量 ----
ENV PORT=9527
ENV NPM_CONFIG_REGISTRY=https://registry.npmmirror.com

# ---- 安装全局依赖 ----
RUN npm install -g lerna@latest pnpm@latest

# ---- 创建项目 ----
WORKDIR /app
RUN echo "app" | npm create vtj@latest -- -t app

# ---- 安装依赖（含 devDependencies）并补装 cross-env ----
WORKDIR /app/app
RUN npm install

# =====  关键：构建阶段自检  =====
# 1. 后台启动 dev 服务
# 2. 用内建 healthcheck 等待端口就绪
# 3. 能连通就 kill 掉，构建继续；超时则构建失败
RUN npm run dev & \
    pid=$! && \
    echo "waiting for dev server on port ${PORT}..." && \
    for i in {1..30}; do \
      if nc -z 127.0.0.1 ${PORT}; then \
        echo "✅ dev server is healthy, shutting down..." && \
        kill $pid && wait $pid 2>/dev/null && exit 0; \
      fi; \
      sleep 2; \
    done && \
    echo "❌ dev server failed to start" && kill $pid && exit 1

# ---- 暴露端口 ----
EXPOSE 9527

# ---- 默认启动命令 ----
CMD ["npm", "run", "dev"]
