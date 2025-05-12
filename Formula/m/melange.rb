class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.23.17.tar.gz"
  sha256 "af7cfcc8a88803d2f4c4a51d910e58aa76eb573eb380cefcc7473e80ec28308e"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b6e28487e980a22b510c3219d842749f5b1c625e84d22a7849c9b97ed3aa3ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78921dc88be16c02b0931a61e97190c353f4a0078fc9c331c89c3e531e620be0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "affe8ee0dec62d75b1e462ed9da9aedaaca383438fc856f647458acd437804a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bba4accdd3c0c06e671dfd539a5a6ca25328bd3221bd0cb770a97895646376f"
    sha256 cellar: :any_skip_relocation, ventura:       "3514c517e6fd892322671382a910a73295790cbcdba2fb25ea5a399d07e1ddf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd8c074f7aec678d65792bda0c9b3a6405c2db29da3bd28a014a94f6ba355cd0"
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
