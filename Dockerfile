FROM node:lts-alpine AS assets
WORKDIR /tmp
RUN npm init -y >/dev/null && npm install --no-audit --no-fund \
      @ruffle-rs/ruffle@latest \
      @fontsource-variable/geist@latest

FROM nginx:alpine
RUN rm -rf /usr/share/nginx/html/*
COPY --from=assets /tmp/node_modules/@ruffle-rs/ruffle /usr/share/nginx/html/ruffle/
COPY --from=assets /tmp/node_modules/@fontsource-variable/geist/files /usr/share/nginx/html/fonts/geist/
COPY public/ /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 5000
