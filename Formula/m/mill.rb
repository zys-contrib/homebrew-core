class Mill < Formula
  desc "Scala build tool"
  homepage "https://mill-build.com/mill/Intro_to_Mill_for_Scala.html"
  url "https://github.com/com-lihaoyi/mill/releases/download/0.11.10/0.11.10-assembly"
  sha256 "fc855679352ede9895f3449f6ea7921bab674540d3a40ca805c6de0957a55297"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b49362932711a6d1fd33734e1a453730d7d62bc66cd9905e0d29d2005d9bbc1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b49362932711a6d1fd33734e1a453730d7d62bc66cd9905e0d29d2005d9bbc1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b49362932711a6d1fd33734e1a453730d7d62bc66cd9905e0d29d2005d9bbc1"
    sha256 cellar: :any_skip_relocation, sonoma:         "0b49362932711a6d1fd33734e1a453730d7d62bc66cd9905e0d29d2005d9bbc1"
    sha256 cellar: :any_skip_relocation, ventura:        "0b49362932711a6d1fd33734e1a453730d7d62bc66cd9905e0d29d2005d9bbc1"
    sha256 cellar: :any_skip_relocation, monterey:       "0b49362932711a6d1fd33734e1a453730d7d62bc66cd9905e0d29d2005d9bbc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2648488674a64bd96771e25d9dcb8130052716522ee46511b73fc2c59854971"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"].shift => "mill"
    chmod 0555, libexec/"mill"
    (bin/"mill").write_env_script libexec/"mill", Language::Java.overridable_java_home_env
  end

  test do
    (testpath/"build.sc").write <<~EOS
      import mill._
      import mill.scalalib._
      object foo extends ScalaModule {
        def scalaVersion = "2.13.11"
      }
    EOS
    output = shell_output("#{bin}/mill resolve __.compile")
    assert_equal "foo.compile", output.lines.last.chomp
  end
end
