class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.6.3.tar.gz"
  sha256 "8b7f43e2b7d9abfe0c4920788fb8e2daeeac8855cd27800966af69f9c8de34ec"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c018cbf35036c6a3ce5d7f38cdb7d03a3fd5f5aca46edfef7346b55e3891da87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e96a99f4db86a2ac23a20776d6c8d05fe57468269ab40e60eb3cec2dfd3db60"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5b44b0cc3008c1dc522ea1fe15079d4b2f9dd1f463d14f1a84d20166620f26d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "06cfae06a7adc2306775fb3c12084a4d96017e5ca545e4711354452b01fe3f75"
    sha256 cellar: :any_skip_relocation, ventura:       "6a744921469b74e9b9f7ac4a18bf4640fdfafa2336495f7b00d559001f56b2d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae2db334f9f63861f62fb09146f42ccd6fad0d1587f6a64aedcd65011af91526"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e71f2a713a07e38afad58fe58171056bdd7accf26a53335d9c6c4e12a9360a9"
  end

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
    system "sbcl", "--dynamic-space-size", "3072", "--no-userinit",
           "--eval", "(load \"runtime/asdf.lisp\")", "--eval", <<~LISP
             (progn
               (asdf:initialize-source-registry
                 (list :source-registry
                       :inherit-configuration (list :tree (uiop:getcwd))))
               (asdf:load-system :ocicl)
               (asdf:clear-source-registry)
               (sb-ext:save-lisp-and-die "#{libexec}/ocicl.core"))
           LISP

    # Write a shell script to wrap ocicl
    (bin/"ocicl").write <<~LISP
      #!/usr/bin/env -S sbcl --core #{libexec}/ocicl.core --script
      (uiop:restore-image)
      (ocicl:main)
    LISP
  end

  test do
    system bin/"ocicl", "install", "chat"
    assert_path_exists testpath/"ocicl.csv"

    version_files = testpath.glob("ocicl/cl-chat*/_00_OCICL_VERSION")
    assert_equal 1, version_files.length, "Expected exactly one _00_OCICL_VERSION file"

    (testpath/"init.lisp").write shell_output("#{bin}/ocicl setup")
    system "sbcl", "--non-interactive", "--load", "init.lisp",
           "--eval", "(progn (asdf:load-system :chat) (sb-ext:quit))"
  end
end
