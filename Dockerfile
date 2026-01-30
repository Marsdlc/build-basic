# 基础镜像：JDK21 Alpine
FROM eclipse-temurin:21-jre-alpine

ENV FFMPEG_VERSION=6.0

# 安装必要工具下载 FFmpeg
RUN apk add --no-cache curl xz \
 && ARCH=$(apk --print-arch) \
 && if [ "$ARCH" = "x86_64" ]; then \
        FFMPEG_URL="https://johnvansickle.com/ffmpeg/releases/ffmpeg-${FFMPEG_VERSION}-amd64-static.tar.xz"; \
    elif [ "$ARCH" = "aarch64" ]; then \
        FFMPEG_URL="https://johnvansickle.com/ffmpeg/releases/ffmpeg-${FFMPEG_VERSION}-arm64-static.tar.xz"; \
    else \
        echo "Unsupported architecture: $ARCH" && exit 1; \
    fi && \
    curl -L "$FFMPEG_URL" -o /tmp/ffmpeg.tar.xz && \
    tar -xf /tmp/ffmpeg.tar.xz -C /tmp && \
    mv /tmp/ffmpeg-*-static/ffmpeg /usr/local/bin/ && \
    mv /tmp/ffmpeg-*-static/ffprobe /usr/local/bin/ && \
    chmod +x /usr/local/bin/ffmpeg /usr/local/bin/ffprobe && \
    rm -rf /tmp/* && apk del curl xz

# 验证
RUN java -version && ffmpeg -version
