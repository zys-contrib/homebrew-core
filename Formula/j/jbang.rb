class Jbang < Formula
  desc "Tool to create, edit and run self-contained source-only Java programs"
  homepage "https://jbang.dev/"
  url "https://github.com/jbangdev/jbang/releases/download/v0.120.4/jbang-0.120.4.zip"
  sha256 "0c9234d1fecacae814490ff1b4e71152a3c5adce2756f9f2a386b64b81a2da21"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bc89089358e918c6a15d85b70b2f41814ab68dadbed373d5515a54bf999c4f8f"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    inreplace "#{libexec}/bin/jbang", /^abs_jbang_dir=.*/, "abs_jbang_dir=#{libexec}/bin"
    bin.install_symlink libexec/"bin/jbang"
  end

  test do
    system bin/"jbang", "init", "--template=cli", testpath/"hello.java"
    assert_match "hello made with jbang", (testpath/"hello.java").read
    assert_match version.to_s, shell_output("#{bin}/jbang --version 2>&1")
  end
end
