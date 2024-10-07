class Jikken < Formula
  desc "Powerful, source control friendly REST API testing toolkit"
  homepage "https://jikken.io/"
  url "https://github.com/jikkenio/jikken/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "d06d1bce4715c8d64d6f4c59bd12f0e7f18b4f486ad04eac9ddc263f7fc986d0"
  license "MIT"
  head "https://github.com/jikkenio/jikken.git", branch: "main"

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/jk new test")
    assert_match "Successfully created test (`test.jkt`).", output
    assert_match "status: 200", (testpath/"test.jkt").read

    assert_match version.to_s, shell_output("#{bin}/jk --version")
  end
end
