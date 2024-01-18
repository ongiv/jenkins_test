# 이미지의 베이스를 설정합니다.
FROM node:14-alpine

# 앱 소스 코드를 추가합니다.
COPY . /app

# 작업 디렉토리를 설정합니다.
WORKDIR /app

# 앱의 종속성을 설치합니다.
RUN npm install

# 앱 실행을 위한 명령어를 설정합니다.
CMD ["npm", "start"]
