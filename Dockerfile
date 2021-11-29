FROM swift:5.5-focal as build
WORKDIR /build
COPY ./Package.* ./
RUN swift package resolve
COPY . .
RUN swift build -c release

WORKDIR /staging
RUN cp "$(swift build --package-path /build -c release --show-bin-path)/Run" ./
RUN [ -d /build/Public ] && { mv /build/Public ./Public && chmod -R a-w ./Public; } || true
RUN [ -d /build/Resources ] && { mv /build/Resources ./Resources && chmod -R a-w ./Resources; } || true

FROM swift:5.5-focal-slim

RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true && \
    apt-get install ca-certificates
    
WORKDIR /app
COPY --from=build /staging /app

EXPOSE 8080
ENTRYPOINT ["./Run"]
CMD ["serve", "--env", "production", "--hostname", "0.0.0.0", "--port", "8080"]
