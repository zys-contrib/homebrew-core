class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.26.9.tar.gz"
  sha256 "78d631adb59e6b16ed276ba3c21159588f8d55d8f821b5c48e2fe2058771f2a2"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef865dec44ae32a2b1bcab66c7fc5f642d8824818456465554513d97ef7bb0e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62873f68e7fb0b6fa1f474cf1eeb2716d4a0f5af985b567294e8f00e3f44cc31"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "43d3ee59c0d903d3cc305d98712b579faaa11cba5a818abdbcdc75f1d4659d8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d2771446fc667143b0b50d4b80146ae11c0bf4b85e30859a2faa11bdb0bdaf9"
    sha256 cellar: :any_skip_relocation, ventura:       "56692c4a2a60ed44ef2c79ba0c50c6ddb2e82290e6cd6d0d6c5fac8f8efc05b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1938c2ca1b25989385747c0cb0b49e48e944eef66ad43552b80a98ed5eeee32"
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
