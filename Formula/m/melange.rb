class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.23.14.tar.gz"
  sha256 "1d06eee2e031c975fe4d19de0ca713d81e5a8e8f2f119cf59547be1affdf246b"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b58085e011a96989100d9ce15a965da1ddfedd8f3e86fff42c0c3a59b8d3093"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3c22e5e2bcbaff94e24840607627213b44933d1cc64093059b1ec6bac0c5124"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a3e48c34fe1c9fe9c9455564f6e2fe3d1e0aa66a06e42a4f776976f849368ee1"
    sha256 cellar: :any_skip_relocation, sonoma:        "d55e19049285307e185ff2ee6ca0c45ea73f67208e8d00aad9fc19c32e5b1540"
    sha256 cellar: :any_skip_relocation, ventura:       "1bb3a380d39b066492a909d042b105ac10116f4ab989a1593c34cdc33d7a23e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8207f2d23f1e98ba1d1d84aebdf665867f9d0bc83385c1650940816f889ef6e0"
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

    generate_completions_from_executable(bin/"melange", "completion")
  end

  test do
    (testpath/"test.yml").write <<~YAML
      package:
        name: hello
        version: 2.12
        epoch: 0
        description: "the GNU hello world program"
        copyright:
          - paths:
            - "*"
            attestation: |
              Copyright 1992, 1995, 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2005,
              2006, 2007, 2008, 2010, 2011, 2013, 2014, 2022 Free Software Foundation,
              Inc.
            license: GPL-3.0-or-later
        dependencies:
          runtime:

      environment:
        contents:
          repositories:
            - https://dl-cdn.alpinelinux.org/alpine/edge/main
          packages:
            - alpine-baselayout-data
            - busybox
            - build-base
            - scanelf
            - ssl_client
            - ca-certificates-bundle

      pipeline:
        - uses: fetch
          with:
            uri: https://ftp.gnu.org/gnu/hello/hello-${{package.version}}.tar.gz
            expected-sha256: cf04af86dc085268c5f4470fbae49b18afbc221b78096aab842d934a76bad0ab
        - uses: autoconf/configure
        - uses: autoconf/make
        - uses: autoconf/make-install
        - uses: strip
    YAML

    assert_equal "hello-2.12-r0", shell_output("#{bin}/melange package-version #{testpath}/test.yml")

    system bin/"melange", "keygen"
    assert_path_exists testpath/"melange.rsa"

    assert_match version.to_s, shell_output(bin/"melange version 2>&1")
  end
end
