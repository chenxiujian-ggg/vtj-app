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
# 1. 装探测工具
RUN apt-get update && \
    apt-get install -y --no-install-recommends netcat-openbsd && \
    rm -rf /var/lib/apt/lists/*

# 2. 自检
RUN BROWSER=none npm run dev

# ---- 暴露端口 ----
EXPOSE 9527

# ---- 默认启动命令 ----
CMD ["npm", "run", "dev"]
