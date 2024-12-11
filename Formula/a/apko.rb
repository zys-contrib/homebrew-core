class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v0.20.2.tar.gz"
  sha256 "685400fac391359ea46d50c056fde7f2b8642ee94c3d779cb2ec4040f01ff3a5"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55f700c71c60d6d6a7e8ddf65b52db0005678b5d74955f3101b7bb8f3901dd44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55f700c71c60d6d6a7e8ddf65b52db0005678b5d74955f3101b7bb8f3901dd44"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "55f700c71c60d6d6a7e8ddf65b52db0005678b5d74955f3101b7bb8f3901dd44"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ebc1519ebe8f998bca19d9b824145b7acd20fd4d6b056cb148cb012582e0fd3"
    sha256 cellar: :any_skip_relocation, ventura:       "5ebc1519ebe8f998bca19d9b824145b7acd20fd4d6b056cb148cb012582e0fd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b2e2b1f1cfe3a3cda1d85e14bb054e5c1bb4b7011cdd55a43e3fd329bd60655"
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
