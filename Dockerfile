FROM joseluisq/static-web-server:2-alpine
COPY ./config.toml ./config.toml
COPY ./public/ /public
