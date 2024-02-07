# Nginx 베이스 이미지 사용
FROM nginx:latest

# 컨테이너 내부의 기본 HTML 파일 교체
COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80

