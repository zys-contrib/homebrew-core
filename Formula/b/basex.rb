class Basex < Formula
  desc "Light-weight XML database and XPath/XQuery processor"
  homepage "https://basex.org"
  url "https://files.basex.org/releases/11.7/BaseX117.zip"
  version "11.7"
  sha256 "e3178c7667e4e8999f7ad7c31a5a8a4184ccb5fd79bd119129845dcab0bdd027"
  license "BSD-3-Clause"

  livecheck do
    url "https://files.basex.org/releases/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5f64247e53d61eac9a50b32b9b639a8c69a4a913b3fe874543773c0a731cc6d7"
  end

  depends_on "openjdk"

  def install
    rm Dir["bin/*.bat"]
    rm_r("repo")
    rm_r("data")
    rm_r("etc")

    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    assert_equal "1\n2\n3\n4\n5\n6\n7\n8\n9\n10", shell_output("#{bin}/basex '1 to 10'")
  end
end
