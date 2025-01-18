class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.5.18.tar.gz"
  sha256 "ca8998b2c55b780885d398eeba0ccfef19e891ff66f903577c1d9625b03e9035"
  license "MIT"

  bottle do
    sha256 arm64_sequoia: "1f736538868d0c07ab9ef32ccf68350f98b8f51efde7d19597470c4fcc30da66"
    sha256 arm64_sonoma:  "befc6034fe931ef613c70ea39c171d62415ff4dd2f01567eb6c08fc5a822d3a0"
    sha256 arm64_ventura: "3332e2eaee2a03c0df0ba730f30dabf0fe010950c23246b27357d47af787311e"
    sha256 sonoma:        "0ae3fe224fe70705665e39f0b04c084273d7e0cec20878e2b84a071d796199c7"
    sha256 ventura:       "c0f37dd2dab30ae72724610cff3fd216b9aa640d46c8eb6607609302500f335a"
    sha256 x86_64_linux:  "5e82a0f02c0fdc67036e2497f1a4ec549c4166ac2d3b2e4f260f778dc2ca996e"
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
    assert_predicate testpath/"systems.csv", :exist?

    version_files = testpath.glob("systems/cl-chat*/_00_OCICL_VERSION")
    assert_equal 1, version_files.length, "Expected exactly one _00_OCICL_VERSION file"

    (testpath/"init.lisp").write shell_output("#{bin}/ocicl setup")
    system "sbcl", "--non-interactive", "--load", "init.lisp",
           "--eval", "(progn (asdf:load-system :chat) (sb-ext:quit))"
  end
end
