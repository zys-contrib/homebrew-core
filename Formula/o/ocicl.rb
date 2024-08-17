class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "e4c5457cb08016d3d4a62832d41c79134b5395102061b328348cdcefae21b82d"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "cb5c7e07ec2a9470b533572a71c891d22a53f18dcfa61b25b127d457635870b5"
    sha256 arm64_ventura:  "e97fdbf6cf3634e55516bf1b9deb5c0447cda653f9e9378d701fe5c67e0d5ef9"
    sha256 arm64_monterey: "a1d56c355636a845c44a7d5d988d3d50cf59985def7dadf249fcd4d3f6cdd096"
    sha256 sonoma:         "e152fc623ada856980c23594efd544d125c184524df0fd507ba8184bcc215bfb"
    sha256 ventura:        "2ac0d6ab306ba26bee8014d7353a987791083772175ea95d6f8e9518122a0174"
    sha256 monterey:       "0b4842368566b7a9f5aa562808240a58303ca3372278664c47407848514ea7f9"
    sha256 x86_64_linux:   "bc5bd7d9001dcdb0dfc19df628dde9d769de79ab922122f18aa67bf56ac88749"
  end

  depends_on "oras"
  depends_on "sbcl"
  depends_on "zstd"

  def install
    mkdir_p [libexec, bin]

    # ocicl's setup.lisp generates an executable that is the binding
    # of the sbcl executable to the ocicl image core.  Unfortunately,
    # on Linux, homebrew somehow manipulates the resulting ELF file in
    # such a way that the sbcl part of the binary can't find the image
    # cores.  For this reason, we are generating our own image core as
    # a separate file and loading it at runtime.
    system "sbcl", "--dynamic-space-size", "3072", "--no-userinit", "--eval",
           "(require 'asdf)", "--eval", <<~LISP
             (progn
               (push (uiop:getcwd) asdf:*central-registry*)
               (asdf:load-system :ocicl)
               (sb-ext:save-lisp-and-die "#{libexec}/ocicl.core"))
           LISP

    # Write a shell script to wrap ocicl
    (bin/"ocicl").write <<~EOS
      #!/usr/bin/env -S sbcl --core #{libexec}/ocicl.core --script
      (uiop:restore-image)
      (ocicl:main)
    EOS

    # Write a shell script to wrap oras
    (bin/"ocicl-oras").write <<~EOS
      #!/bin/sh
      oras "$@"
    EOS
  end

  test do
    system bin/"ocicl", "install", "chat"
    assert_predicate testpath/"systems.csv", :exist?

    version_files = testpath.glob("systems/cl-chat*/_00_OCICL_VERSION")
    assert_equal 1, version_files.length, "Expected exactly one _00_OCICL_VERSION file"

    (testpath/"init.lisp").write shell_output("#{bin}/ocicl setup")
    system "sbcl", "--non-interactive", "--load", "init.lisp",
           "--eval", "(progn (asdf:load-system :chat) (sb-ext:quit))"
  end
end
