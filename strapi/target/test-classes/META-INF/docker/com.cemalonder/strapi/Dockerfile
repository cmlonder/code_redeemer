FROM node:11.1.0-alpine

LABEL maintainer="Cemal Önder <cemalonder1@gmail.com>" \
      org.label-schema.vendor="Strapi" \
      org.label-schema.name="Strapi Docker image" \
      org.label-schema.description="Strapi containerized" \
      org.label-schema.url="https://strapi.io" \
      org.label-schema.vcs-url="https://github.com/strapi/strapi-docker" \
      org.label-schema.version=latest \
      org.label-schema.schema-version="1.0"

WORKDIR /usr/src/api

RUN apk --no-cache add curl
RUN echo "unsafe-perm = true" >> ~/.npmrc
RUN npm install -g strapi@beta

COPY strapi.sh ./
RUN chmod +x ./strapi.sh

EXPOSE 1337

COPY healthcheck.js ./
HEALTHCHECK --interval=15s --timeout=5s --start-period=30s \
CMD node /usr/src/api/healthcheck.js

# TODO: Can not create folder like models and copy folder, permission error
# TODO: Can not create all models dynamically, so commented out for now
# COPY create_models.sh ./
# RUN chmod +x ./create_models.sh
# COPY code.sh ./
# RUN chmod +x ./code.sh
# COPY game.sh ./
# RUN chmod +x ./game.sh
# COPY waitforserver.sh ./
# RUN chmod +x ./waitforserver.sh

CMD ["./strapi.sh"]