
FROM alpine:3.12

RUN apk --update add curl

COPY /app.sh /

CMD  [ "app.sh" ]