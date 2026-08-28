# Comdb2 Docker

[![Docker Build](https://github.com/boolivar/comdb2-docker/actions/workflows/ci.yml/badge.svg)](https://github.com/boolivar/comdb2-docker/actions/workflows/ci.yml)
[![Docker Pulls](https://img.shields.io/docker/pulls/boolivar/comdb2)](https://hub.docker.com/r/boolivar/comdb2)
[![Docker Image Version](https://img.shields.io/docker/v/boolivar/comdb2?sort=semver)](https://hub.docker.com/r/boolivar/comdb2/tags)

This repository is an unofficial docker image source for [Comdb2](https://github.com/bloomberg/comdb2) distributed relational database.

## Usage

Run Docker container:
```bash
docker run --name comdb2-instance -d -p 19000:19000 boolivar/comdb2:latest
```

## License

This project is licensed under the [MIT License](LICENSE).

Original Comdb2 project is licensed under the Apache License 2.0. See [original license](https://github.com/bloomberg/comdb2/blob/main/LICENSE) for more details.
