FROM mongo:7.0

LABEL maintainer="Ugo Governin"
LABEL version="1.0.0"

ENV MONGO_INITDB_DATABASE=blog_db

RUN useradd -m -u 999 mongodb-user || true

COPY init-blog-db.js /docker-entrypoint-initdb.d/01-init-blog-db.js
RUN chmod 755 /docker-entrypoint-initdb.d/01-init-blog-db.js

EXPOSE 27017

HEALTHCHECK --interval=10s --timeout=5s --start-period=40s --retries=3 \
  CMD mongosh --eval "db.adminCommand('ping')" --quiet

USER mongodb
