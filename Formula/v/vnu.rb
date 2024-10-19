class Vnu < Formula
  desc "Nu Markup Checker: command-line and server HTML validator"
  homepage "https://validator.github.io/validator/"
  url "https://registry.npmjs.org/vnu-jar/-/vnu-jar-24.10.17.tgz"
  sha256 "4617d3e3234a40efce2eb42fa9c0fcc8abf85c33fffb8825bfd77563209d43b0"
  license "MIT"
  version_scheme 1

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "78a79722951e515741231ad763a31c877c22311e38a212760cf33cb64e03d06f"
  end

  depends_on "openjdk"

  def install
    libexec.install "build/dist/vnu.jar"
    bin.write_jar_script libexec/"vnu.jar", "vnu"
  end

  test do
    (testpath/"index.html").write <<~EOS
      <!DOCTYPE html>
      <html>
      <head>
        <title>hi</title>
      </head>
      <body>
      </body>
      </html>
    EOS
    system bin/"vnu", testpath/"index.html"
  end
end
