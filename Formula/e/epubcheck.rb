class Epubcheck < Formula
  desc "Validate EPUB files, version 2.0 and later"
  homepage "https://github.com/w3c/epubcheck"
  url "https://github.com/w3c/epubcheck/releases/download/v5.2.1/epubcheck-5.2.1.zip"
  sha256 "0532f6291faa2bb729dd253f958868a2a57dbd2c32f881a97c7c980c5940309e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9078e3e592f0c1f83908f3ce507216c6a4b68d585c2e572c4589eb4861df6d47"
  end

  depends_on "openjdk"

  def install
    jarname = "epubcheck.jar"
    libexec.install jarname, "lib"
    bin.write_jar_script libexec/jarname, "epubcheck"
  end
end
