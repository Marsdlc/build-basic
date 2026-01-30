FROM eclipse-temurin:21-jre-jammy

# 1. 声明 TARGETARCH，Docker Buildx 会自动注入当前构建的架构 (如 amd64 或 arm64)
ARG TARGETARCH
# 定义 FFmpeg 版本
ARG FFMPEG_VERSION=6.0

# 2. 动态构建 URL 并下载
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl xz-utils && \
    mkdir -p /tmp/ffmpeg && \
    FFMPEG_URL="https://johnvansickle.com/ffmpeg/releases/ffmpeg-${FFMPEG_VERSION}-${TARGETARCH}-static.tar.xz" && \
    echo "Downloading FFmpeg (${TARGETARCH}) from $FFMPEG_URL" && \
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