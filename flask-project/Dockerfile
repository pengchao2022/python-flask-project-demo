# 使用官方Python运行时作为父镜像
FROM python:3.9-alpine

# 设置工作目录
WORKDIR /app

# 复制requirements文件并安装依赖
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 复制应用代码
COPY . .

# 使端口5000可供此容器外的环境使用
EXPOSE 5000

# 定义环境变量
ENV FLASK_APP=app
ENV FLASK_ENV=production

# 在容器启动时运行应用
CMD ["flask", "run", "--host", "0.0.0.0"]