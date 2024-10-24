class Mill < Formula
  desc "Scala build tool"
  homepage "https://mill-build.com/mill/Scala_Intro_to_Mill.html"
  url "https://github.com/com-lihaoyi/mill/releases/download/0.12.0/0.12.0-assembly"
  sha256 "cb82ad059d4fe9398a6882f62be315be7e735fc9cec4b8da26479709be128ccf"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1cc17f4bd0b4cde8d093e6fa05086874b9f691e285e4b850fe872f9aea72ffad"
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
