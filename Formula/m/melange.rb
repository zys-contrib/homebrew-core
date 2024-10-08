class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "1ad069556aae2702c131f2ddf69be4fd19acb8b16f4f6ed4510a8d14f80d2019"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e396744affbe39169afd8aeb25bae20326951e1d57de0ce525a6378f33d57bf5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e396744affbe39169afd8aeb25bae20326951e1d57de0ce525a6378f33d57bf5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e396744affbe39169afd8aeb25bae20326951e1d57de0ce525a6378f33d57bf5"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb752814a536a70129b1c1ae947b2af401e1a1d5f7779e8729e9582c410b094e"
    sha256 cellar: :any_skip_relocation, ventura:       "fb752814a536a70129b1c1ae947b2af401e1a1d5f7779e8729e9582c410b094e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d7c9882d92554c3d697f23dd37e6fb4e8b20b3982c66a28645e2eea22150eca"
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
    (testpath/"test.yml").write <<~EOS
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
    EOS

    assert_equal "hello-2.12-r0", shell_output("#{bin}/melange package-version #{testpath}/test.yml")

    system bin/"melange", "keygen"
    assert_predicate testpath/"melange.rsa", :exist?

    assert_match version.to_s, shell_output(bin/"melange version 2>&1")
  end
end
