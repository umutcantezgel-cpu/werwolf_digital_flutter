# Mordakte-Server.
# Build-Kontext ist das REPO-ROOT, weil der Server packages/mordakte_core braucht:
#   docker build -f server/Dockerfile -t mordakte-server .
#   docker run --rm -p 8080:8080 mordakte-server

# --- Stage 1: kompilieren ----------------------------------------------------
FROM dart:stable AS build
WORKDIR /src

# Erst nur die pubspecs → Abhängigkeiten werden gecacht.
COPY packages/mordakte_core/pubspec.yaml packages/mordakte_core/
COPY server/pubspec.yaml server/pubspec.lock server/
RUN cd server && dart pub get

COPY packages/mordakte_core packages/mordakte_core
COPY server server
COPY content content

RUN cd server \
 && dart pub get --offline \
 && dart compile exe bin/server.dart -o /out/server \
 && mkdir -p /out/content/scenarios \
 && if [ -d /src/content/scenarios ]; then cp -r /src/content/scenarios/. /out/content/scenarios/; fi

# --- Stage 2: minimales Laufzeit-Image ---------------------------------------
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /out/server /app/bin/server
COPY --from=build /out/content/scenarios /app/content/scenarios

ENV SCENARIO_DIR=/app/content/scenarios
EXPOSE 8080
USER 65532:65532
CMD ["/app/bin/server"]
