# JDK21 + Alpine
FROM eclipse-temurin:21-jre-alpine

ENV FFMPEG_VERSION=6.0

# 使用 build-arg 指定 FFmpeg 下载 URL
ARG FFMPEG_URL

RUN apk add --no-cache curl xz \
 && curl -L "$FFMPEG_URL" -o /tmp/ffmpeg.tar.xz \
 && tar -xf /tmp/ffmpeg.tar.xz -C /tmp \
 && mv /tmp/ffmpeg-*-static/ffmpeg /usr/local/bin/ \
 && mv /tmp/ffmpeg-*-static/ffprobe /usr/local/bin/ \
 && chmod +x /usr/local/bin/ffmpeg /usr/local/bin/ffprobe \
 && rm -rf /tmp/* && apk del curl xz

# 验证
RUN java -version && ffmpeg -version