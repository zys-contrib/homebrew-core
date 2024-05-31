class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v0.14.7.tar.gz"
  sha256 "2615f3844cb180db4a346f526dbb2385ef2eae3c2b74b49e40fb71d2b11d0496"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9644bd16d08cb07a30f47900efc3eab5de949cf60902ecba0a2825c440e529cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a9d511ae1dad15a8472807764d5e670234e7fb11202b7e1f68891be815862b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4ae919db8e8b8a33c06e1240b9087c89977cf9ef8a76934c5608cfbe6a7be70"
    sha256 cellar: :any_skip_relocation, sonoma:         "da115f698ab5b9416e6c16fb57cf7bab6506bba32c163ed7d01c5c25f7e7298f"
    sha256 cellar: :any_skip_relocation, ventura:        "13e4e7e76cac4fee8097ec333caa2e7e3779bbc3efb2d99834e1d1090ff95b58"
    sha256 cellar: :any_skip_relocation, monterey:       "9599a36c2bd400beb29c0551dbd4c360e65cc3344aed919f5ca6fe6a6ea5dea7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3fc47dd55189112edb6e370ec0d7e7bea9d70cd2e1f76a87fe36fcc0a08a248"
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
    EOS
    system bin/"apko", "build", testpath/"test.yml", "apko-alpine:test", "apko-alpine.tar"
    assert_predicate testpath/"apko-alpine.tar", :exist?

    assert_match version.to_s, shell_output(bin/"apko version 2>&1")
  end
end
