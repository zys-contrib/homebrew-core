class Kbt < Formula
  desc "Keyboard tester in terminal"
  homepage "https://github.com/bloznelis/kbt"
  url "https://github.com/bloznelis/kbt/archive/refs/tags/2.1.0.tar.gz"
  sha256 "8dd3b9c129b51e902f1b0aeb5a717c716d92f81ed76c2264a9131f8def428e93"
  license "MIT"
  head "https://github.com/bloznelis/kbt.git", branch: "master"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "libx11"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # kbt is a TUI application
    assert_match version.to_s, shell_output("#{bin}/kbt --version")
  end
end
