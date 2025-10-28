# ============================================================
# Stage 1 — Build Swift Lambda binary (AL2, arm64)
# ============================================================
FROM --platform=linux/arm64 swift:6.2.0-amazonlinux2 AS build

WORKDIR /workspace
COPY . .
RUN swift build -c release --static-swift-stdlib

# ============================================================
# Stage 2 — Lambda Runtime (AL2023, arm64)
# ============================================================
FROM --platform=linux/arm64 public.ecr.aws/lambda/provided:al2023

# Swift バイナリ配置
COPY --from=build /workspace/.build/release/MaToolAPI /var/runtime/bootstrap
RUN chmod +x /var/runtime/bootstrap

ENTRYPOINT ["/var/runtime/bootstrap"]
