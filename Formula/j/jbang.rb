class Jbang < Formula
  desc "Tool to create, edit and run self-contained source-only Java programs"
  homepage "https://jbang.dev/"
  url "https://github.com/jbangdev/jbang/releases/download/v0.117.1/jbang-0.117.1.zip"
  sha256 "28b66273d5ff4057ed37a2dfda5b49b549768e8bed6e0ea335015eea8d28c67c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "79d6a7da49c643e131e430f3e538fa083c4bd1b33b287945e4851dcadbbc8e41"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    inreplace "#{libexec}/bin/jbang", /^abs_jbang_dir=.*/, "abs_jbang_dir=#{libexec}/bin"
    bin.install_symlink libexec/"bin/jbang"
  end

  test do
    system "#{bin}/jbang", "init", "--template=cli", testpath/"hello.java"
    assert_match "hello made with jbang", (testpath/"hello.java").read
    assert_match version.to_s, shell_output("#{bin}/jbang --version 2>&1")
  end
end
