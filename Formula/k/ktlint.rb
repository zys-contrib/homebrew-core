class Ktlint < Formula
  desc "Anti-bikeshedding Kotlin linter with built-in formatter"
  homepage "https://ktlint.github.io/"
  url "https://github.com/pinterest/ktlint/releases/download/1.3.0/ktlint-1.3.0.zip"
  sha256 "4c2cf93a1ba306edb3505b3333960752fe84896be4bd04134340c64fd6836f43"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "09f8a9ea65773e77493c57d0433042d138dddda6ffe2eba0b8dab48c0ab1cfa3"
  end

  depends_on "openjdk"

  def install
    libexec.install "bin/ktlint"
    (libexec/"ktlint").chmod 0755
    (bin/"ktlint").write_env_script libexec/"ktlint", Language::Java.java_home_env
  end

  test do
    (testpath/"Main.kt").write <<~EOS
      fun main( )
    EOS
    (testpath/"Out.kt").write <<~EOS
      fun main()
    EOS
    system bin/"ktlint", "-F", "Main.kt"
    assert_equal shell_output("cat Main.kt"), shell_output("cat Out.kt")
  end
end
