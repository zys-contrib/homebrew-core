class Mill < Formula
  desc "Scala build tool"
  homepage "https://mill-build.com/mill/Scala_Intro_to_Mill.html"
  url "https://github.com/com-lihaoyi/mill/releases/download/0.12.2/0.12.2-assembly"
  sha256 "176641cb064e76bac33e0a4109790cade959133cea71e4d0b87df0c3c207e0db"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "084c812a3b51ff7c238ccfa997c7b89e33e4cec66f5155fa26d6e9966a334c40"
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
