class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.11.4.tar.gz"
  sha256 "910f8c6d3334d8de750932facf74753677339c7b7e6c07071232a04560ac7574"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9f527dcb787555d116603f8d91d574e1e633f513312ce9948b70ad71acfee146"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f527dcb787555d116603f8d91d574e1e633f513312ce9948b70ad71acfee146"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f527dcb787555d116603f8d91d574e1e633f513312ce9948b70ad71acfee146"
    sha256 cellar: :any_skip_relocation, sonoma:         "c6de92b4e5c1e8de11f1b162b63a5c3d679cecc4908924fa30560e1fbe93fea1"
    sha256 cellar: :any_skip_relocation, ventura:        "c6de92b4e5c1e8de11f1b162b63a5c3d679cecc4908924fa30560e1fbe93fea1"
    sha256 cellar: :any_skip_relocation, monterey:       "c6de92b4e5c1e8de11f1b162b63a5c3d679cecc4908924fa30560e1fbe93fea1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a63a49d1a6a725472c4ee0c21b8b78eade4b35589bcc8c01e4d7a2cbedb7aa5a"
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
