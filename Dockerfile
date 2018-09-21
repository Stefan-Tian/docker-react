FROM node:alpine AS builder
WORKDIR /usr/app
COPY package*.json ./
RUN yarn install --upgrade
COPY . .
RUN yarn build

FROM nginx
EXPOSE 80
COPY --from=builder /usr/app/build /usr/share/nginx/html
