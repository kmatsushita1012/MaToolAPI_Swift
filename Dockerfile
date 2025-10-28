# ============================================================
# Stage 1 — Build Swift Lambda binary (Amazon Linux 2)
# ============================================================
FROM swift:6.2.0-amazonlinux2 AS build

WORKDIR /workspace

# パッケージ依存解決
COPY Package.swift .
COPY Package.resolved ./
RUN swift package resolve

# ソースコードコピー
COPY . .

# Releaseビルド（静的リンク）
RUN swift build -c release --static-swift-stdlib

# ============================================================
# Stage 2 — Minimal Lambda runtime image (AL2023)
# ============================================================
FROM public.ecr.aws/lambda/provided:al2023

# ビルド済みバイナリを bootstrap に配置
COPY --from=build /workspace/.build/release/MaToolAPI /var/runtime/bootstrap

# Lambda カスタムランタイムは bootstrap を自動実行
ENTRYPOINT ["/var/runtime/bootstrap"]
