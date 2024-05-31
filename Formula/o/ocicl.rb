class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.3.7.tar.gz"
  sha256 "7199674fe545a0a80b1cf7aed9a52b51277beca3583c95478aae24e0c9af74f8"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "1c993138242b9d91c0c083ccfd03738fa8026b2f983974069922c2e66b6e9bf4"
    sha256 arm64_ventura:  "6f4d9af03e1e0e2e27e13133f4e8d4de74d6e9c6f05cdb1b024678e73d161d07"
    sha256 arm64_monterey: "dc0a11cc2bb9d53d1b15eed9d06965e8fc5a6d3783fa6ce1818aa4621ff05dcc"
    sha256 sonoma:         "a59d43028e7817ab6ab22bc8231d29df45adedc747ac9bd7712a00d6b52a90dc"
    sha256 ventura:        "de2ad9e25522997365f1fad608f2dedc01279f7fa59f990f1b2ae5be03c32f4c"
    sha256 monterey:       "b7a84b199eec7141dbdfd99cb4a10125b8796a8e97f8dcf49a3b433907cb8f1f"
    sha256 x86_64_linux:   "e2faaece2efeee11b08b1accaee6f240d785599e5f32b7779508cc74ec1e0312"
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
      (ocicl:main)
    EOS

    # Write a shell script to wrap oras
    (bin/"ocicl-oras").write <<~EOS
      #!/bin/sh
      oras "$@"
    EOS
  end

  test do
    system "#{bin}/ocicl", "install", "chat"
    assert_predicate testpath/"systems.csv", :exist?

    version_files = testpath.glob("systems/cl-chat*/_00_OCICL_VERSION")
    assert_equal 1, version_files.length, "Expected exactly one _00_OCICL_VERSION file"

    (testpath/"init.lisp").write shell_output("#{bin}/ocicl setup")
    system "sbcl", "--non-interactive", "--load", "init.lisp",
           "--eval", "(progn (asdf:load-system :chat) (sb-ext:quit))"
  end
end
