# ---- 1. 基础镜像 ----
FROM node:22.19.0-bullseye

# ---- 2. 环境变量 ----
ENV PORT=9527
ENV NODE_ENV=production

# ---- 3. 淘宝源 + 全局依赖 ----
RUN npm config set registry https://registry.npmmirror.com && \
    npm install -g lerna@latest pnpm@latest --registry=https://registry.npmmirror.com

# ---- 4. 工作目录 ----
WORKDIR /app

# ---- 5. 创建项目（强制名称 app，落盘到 /app） ----
RUN npm create vtj@latest --registry=https://registry.npmmirror.com -- -t app -n app

# ---- 6. 安装项目依赖 ----
RUN npm install

# ---- 7. 暴露端口 ----
EXPOSE 9527

# ---- 8. 容器启动命令 ----
CMD ["tail", "-f", "/dev/null"]
