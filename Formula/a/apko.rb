class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v0.19.6.tar.gz"
  sha256 "b984991fbeb01e4a183cbb3304dbab0d54729cb308d60f899645d9e929ccf2a4"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/apko.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ff38eb7154974bc3ac054c4d67a547b68c1dc67d82034ebb0782212adbca106"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ff38eb7154974bc3ac054c4d67a547b68c1dc67d82034ebb0782212adbca106"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ff38eb7154974bc3ac054c4d67a547b68c1dc67d82034ebb0782212adbca106"
    sha256 cellar: :any_skip_relocation, sonoma:        "1bcc9d2d1a278b84173ae7ddcb00d5183ec1799f3c5554debf2dfa835ac5d6f5"
    sha256 cellar: :any_skip_relocation, ventura:       "1bcc9d2d1a278b84173ae7ddcb00d5183ec1799f3c5554debf2dfa835ac5d6f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dddce1da9b6a81999e70d71ca2cc4b159b62e13bf7af579777d6caf1697db09"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=brew
      -X sigs.k8s.io/release-utils/version.gitTreeState=clean
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"apko", "completion")
  end

  test do
    (testpath/"test.yml").write <<~EOS
      contents:
        repositories:
          - https://dl-cdn.alpinelinux.org/alpine/edge/main
        packages:
          - alpine-base

      entrypoint:
        command: /bin/sh -l

      # optional environment configuration
      environment:
        PATH: /usr/sbin:/sbin:/usr/bin:/bin

      # only key found for arch riscv64 [edge],
      archs:
        - riscv64
    EOS
    system bin/"apko", "build", testpath/"test.yml", "apko-alpine:test", "apko-alpine.tar"
    assert_predicate testpath/"apko-alpine.tar", :exist?

    assert_match version.to_s, shell_output(bin/"apko version 2>&1")
  end
end
