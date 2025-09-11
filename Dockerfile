# ---- 基础镜像 ----
FROM node:22.19.0-bullseye

# ---- 环境变量 ----
# 删除 NODE_ENV=production，避免跳过 devDependencies
ENV PORT=9527
ENV NPM_CONFIG_REGISTRY=https://registry.npmmirror.com

# ---- 安装全局依赖 ----
RUN npm install -g lerna@latest pnpm@latest

# ---- 创建项目 ----
WORKDIR /app
RUN echo "app" | npm create vtj@latest -- -t app

# ---- 安装依赖（含 devDependencies）并补装 cross-env ----
WORKDIR /app/app
RUN npm install && npm install -D cross-env

# ---- 暴露端口 ----
EXPOSE 9527

# ---- 默认启动命令 ----
CMD ["npm", "run", "dev"]
