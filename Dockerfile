FROM eclipse-temurin:21-jre-jammy

# 安装必要工具并下载对应架构的静态 ffmpeg (支持 amd64/arm64)
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl xz-utils && \
    ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then \
        FFMPEG_URL="https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz"; \
    elif [ "$ARCH" = "arm64" ]; then \
        FFMPEG_URL="https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-arm64-static.tar.xz"; \
    else \
        echo "Unsupported architecture: $ARCH" && exit 1; \
    fi && \
    mkdir -p /tmp/ffmpeg && \
    curl -L "$FFMPEG_URL" -o /tmp/ffmpeg.tar.xz && \
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

# 创建目录
RUN mkdir -p /app/tmp && chmod 777 /app/tmp \
 && mkdir -p /app/logs && chmod 777 /app/logs

# 复制 jar
COPY target/mars-printer-hub-*.jar /app/app.jar

# 启动
ENTRYPOINT ["java", "-jar", "/app/app.jar"]