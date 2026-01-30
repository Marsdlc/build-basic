FROM eclipse-temurin:21-jre-jammy

# 构建参数：每个架构传不同 FFmpeg URL
ARG FFMPEG_URL

# 安装必要工具并下载 FFmpeg
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl xz-utils && \
    mkdir -p /tmp/ffmpeg && \
    echo "Downloading FFmpeg from $FFMPEG_URL" && \
    curl -fSL "$FFMPEG_URL" -o /tmp/ffmpeg.tar.xz && \
    tar -xf /tmp/ffmpeg.tar.xz -C /tmp/ffmpeg --strip-components=1 && \
    mv /tmp/ffmpeg/ffmpeg /usr/local/bin/ && \
    mv /tmp/ffmpeg/ffprobe /usr/local/bin/ && \
    chmod +x /usr/local/bin/ffmpeg /usr/local/bin/ffprobe && \
    rm -rf /tmp/ffmpeg* && \
    apt-get purge -y curl xz-utils && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# 工作目录
WORKDIR /app

# 创建通用目录
RUN mkdir -p /app/tmp /app/logs && chmod 777 /app/tmp /app/logs