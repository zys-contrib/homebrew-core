class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "e8467bf166a5ad4e6e2d9dd029316d4fbbc3a77f92d1a8e2450a96a06210c2d9"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ace79d54cd5997d3ee2d1986f2484d55e2262b5a60185e98c82870cf18373753"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ace79d54cd5997d3ee2d1986f2484d55e2262b5a60185e98c82870cf18373753"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ace79d54cd5997d3ee2d1986f2484d55e2262b5a60185e98c82870cf18373753"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e9f924619bdf04201a0d0ca4c61c11f95fab4d0f1b563d2f108b6f4177ea0dd"
    sha256 cellar: :any_skip_relocation, ventura:       "5e9f924619bdf04201a0d0ca4c61c11f95fab4d0f1b563d2f108b6f4177ea0dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fff9cfc7faf1decaae1c6c55c632bd6437c47f03a0a84bc8a33aaf1af829d3bb"
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
