# ---- 基础镜像 ----
FROM node:22.19.0-bullseye

# ---- 环境变量 ----
ENV NODE_ENV=production
ENV PORT=9527
ENV NPM_CONFIG_REGISTRY=https://registry.npmmirror.com

# ---- 安装全局依赖（利用缓存层） ----
RUN npm install -g lerna@latest pnpm@latest

# ---- 创建并进入工作目录 ----
WORKDIR /app

# ---- 创建项目（交互式自动应答） ----
# npm create vtj@latest 会询问项目名，echo 管道把 app 写进去
RUN echo "app" | npm create vtj@latest -- -t app

# ---- 安装项目依赖 ----
WORKDIR /app/app
RUN npm install

# ---- 暴露端口 ----
EXPOSE 9527

# ---- 保持主进程不退出 ----
CMD ["tail", "-f", "/dev/null"]
