# 基础镜像：JDK21 + Alpine
FROM eclipse-temurin:21-jre-alpine

ENV FFMPEG_VERSION=6.0
ARG FFMPEG_URL

# 安装 curl/xz，下载并解压静态 FFmpeg
RUN apk add --no-cache curl xz \
 && mkdir -p /tmp/ffmpeg \
 && curl -L "$FFMPEG_URL" | tar -xJ -C /tmp/ffmpeg --strip-components=1 \
 && mv /tmp/ffmpeg/ffmpeg /usr/local/bin/ \
 && mv /tmp/ffmpeg/ffprobe /usr/local/bin/ \
 && chmod +x /usr/local/bin/ffmpeg /usr/local/bin/ffprobe \
 && rm -rf /tmp/ffmpeg \
 && apk del curl xz

# 验证
RUN java -version && ffmpeg -version