# anchor-java-gen

Docker container for generating Java code from Anchor protocol.

Based on [anchor-src-gen](https://github.com/sava-software/anchor-src-gen).

## Build

```shell
docker build \
  --build-arg GITHUB_USERNAME=GITHUB_USERNAME \
  --build-arg GITHUB_TOKEN=GITHUB_TOKEN \
  -t anchor-java-gen:latest .
```

## Use

```shell
docker run --rm \
  -v "$(pwd)":/work \
  anchor-java-gen:latest \
  --tabLength=2 \
  --sourceDirectory="/work/src/main/java" \
  --moduleName="org.your.module" \
  --basePackageName="org.your.package.anchor.gen" \
  --programs="/work/main_net_programs.json" \
  --rpc="https://rpc.com" \
  --baseDelayMillis=200 \
  --numThreads=5
```

## Docker Compose

```shell
docker-compose -f compose.example.yaml up -d
```