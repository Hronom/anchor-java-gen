<!-- TOC -->
* [anchor-java-gen](#anchor-java-gen)
  * [Usage](#usage)
    * [Use using docker](#use-using-docker)
  * [Run tests like in CI](#run-tests-like-in-ci)
<!-- TOC -->

# anchor-java-gen

Docker container for generating Java code from Anchor protocol.

Based on [anchor-src-gen](https://github.com/sava-software/anchor-src-gen).

## Usage

### Use using docker

Write secrets to files:
```shell
echo "Hronom" > github_username.secret
echo "secret" > github_token.secret
```

Build:
```shell
docker build \
  --secret id=github_username,src=./github_username.secret \
  --secret id=github_token,src=./github_token.secret \
  -t anchor-java-gen:latest .
```

Run:
```shell
docker run --rm \
  -v "$(pwd)":/work \
  anchor-java-gen:latest \
  --tabLength=2 \
  --sourceDirectory="/work/java-generated" \
  --moduleName="org.your.module" \
  --basePackageName="org.your.package.anchor.gen" \
  --programs="/work/main_net_programs.json" \
  --rpc="https://api.devnet.solana.com" \
  --baseDelayMillis=200 \
  --numThreads=5
```

## Run tests like in CI

Write secrets to files:
```shell
echo "Hronom" > github_username.secret
echo "secret" > github_token.secret
```

```shell
docker compose -f compose.test.ci.yaml up --menu=false --quiet-pull --build --exit-code-from anchor-java-gen-test
```