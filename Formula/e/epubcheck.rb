class Epubcheck < Formula
  desc "Validate EPUB files, version 2.0 and later"
  homepage "https://github.com/w3c/epubcheck"
  url "https://github.com/w3c/epubcheck/releases/download/v5.2.0/epubcheck-5.2.0.zip"
  sha256 "a88fc7ec19df1eb1c27f50ceb5156772ef0b53e1c418f663c8d750bdbdd0f922"
  license "BSD-3-Clause"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "0f49db31f1124e428d4a0e574e130ba7abd35a5467426642b6d84eacb19c672b"
  end

  depends_on "openjdk"

  def install
    jarname = "epubcheck.jar"
    libexec.install jarname, "lib"
    bin.write_jar_script libexec/jarname, "epubcheck"
  end
end
