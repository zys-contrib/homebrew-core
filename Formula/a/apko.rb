class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "871eb04465c8fc24afb0df90058c00e0bd2b2922726b1eb688940239ccd35439"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e388ee17b29d4e9a8a4a9331dd9040a779ed70ac5f1433d376b1e55e4d08c3ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e388ee17b29d4e9a8a4a9331dd9040a779ed70ac5f1433d376b1e55e4d08c3ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e388ee17b29d4e9a8a4a9331dd9040a779ed70ac5f1433d376b1e55e4d08c3ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "eaa876fb7244d954952967196c816f56d7e9e3793ba1b9f24643d7e7f80769c3"
    sha256 cellar: :any_skip_relocation, ventura:       "eaa876fb7244d954952967196c816f56d7e9e3793ba1b9f24643d7e7f80769c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe85dc55e95a820deabfdf76542008ac3677f0bac31962bc3837dccf1c75f9b0"
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
    (testpath/"test.yml").write <<~YAML
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
    YAML
    system bin/"apko", "build", testpath/"test.yml", "apko-alpine:test", "apko-alpine.tar"
    assert_predicate testpath/"apko-alpine.tar", :exist?

    assert_match version.to_s, shell_output(bin/"apko version 2>&1")
  end
end
