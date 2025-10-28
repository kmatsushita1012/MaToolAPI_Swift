# ============================================================
# Stage 1 — Build Swift toolchain on Amazon Linux 2023
# ============================================================
FROM amazonlinux:2023 AS swift-toolchain

WORKDIR /tmp
COPY scripts/build-swift.sh /tmp/build-swift.sh
RUN chmod +x /tmp/build-swift.sh && /tmp/build-swift.sh

# 結果: /tmp/swift-5.8-amazonlinux2023.tar.gz が生成される

# ============================================================
# Stage 2 — Build Swift Lambda binary using the new toolchain
# ============================================================
FROM amazonlinux:2023 AS build

# Swiftツールチェイン導入
COPY --from=swift-toolchain /tmp/swift-6.2-amazonlinux2023.tar.gz /tmp/
RUN tar -xzf /tmp/swift-6.2-amazonlinux2023.tar.gz -C /usr

# Swift環境を有効化
ENV PATH="/usr/bin:/usr/libexec/swift/linux/bin:$PATH"

WORKDIR /workspace
COPY . .

# Swift Lambda バイナリをビルド
RUN swift build -c release --static-swift-stdlib

# ============================================================
# Stage 3 — Lambda runtime image (AL2023)
# ============================================================
FROM public.ecr.aws/lambda/provided:al2023

# Swift バイナリを配置
COPY --from=build /workspace/.build/release/MaToolAPI /var/runtime/bootstrap

RUN chmod +x /var/runtime/bootstrap
ENTRYPOINT ["/var/runtime/bootstrap"]