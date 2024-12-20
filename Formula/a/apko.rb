class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v0.22.4.tar.gz"
  sha256 "88abc448820157d020284268d69ad011e2312627b29cfeec18ab504639e6b5c3"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff3222b310f7f9aaf7cfc2c3d29582ed366f288848562cf7de4be8c34dd51499"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff3222b310f7f9aaf7cfc2c3d29582ed366f288848562cf7de4be8c34dd51499"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ff3222b310f7f9aaf7cfc2c3d29582ed366f288848562cf7de4be8c34dd51499"
    sha256 cellar: :any_skip_relocation, sonoma:        "d997eef725e3128db9d04ab44b0cdf1b85b5d8d7d3bf467cc96e1449628c75f4"
    sha256 cellar: :any_skip_relocation, ventura:       "d997eef725e3128db9d04ab44b0cdf1b85b5d8d7d3bf467cc96e1449628c75f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d92b94ac4ac7f13c99ffb8949f0c85a46a261b1440cc4109266d3ec50c06e39b"
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
