class Envelope < Formula
  desc "Environment variables CLI tool"
  homepage "https://github.com/mattrighetti/envelope"
  url "https://github.com/mattrighetti/envelope/archive/refs/tags/0.3.11.tar.gz"
  sha256 "1a378564b07e041fbf3212655e8c6442f8973080cf0698886764ce38982661cc"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/mattrighetti/envelope.git", branch: "master"

  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    args = %w[
      --standalone
      --to=man
    ]
    system "pandoc", *args, "man/envelope.1.md", "-o", "envelope.1"
    man1.install "envelope.1"
  end

  test do
    assert_equal "envelope #{version}", shell_output("#{bin}/envelope --version").strip

    assert_match "error: envelope is not initialized in current directory",
      shell_output("#{bin}/envelope list 2>&1", 1)

    system bin/"envelope", "init"
    system bin/"envelope", "add", "dev", "var1", "test1"
    system bin/"envelope", "add", "dev", "var2", "test2"
    system bin/"envelope", "add", "prod", "var1", "test1"
    system bin/"envelope", "add", "prod", "var2", "test2"
    assert_match "dev\nprod", shell_output("#{bin}/envelope list")
  end
end
