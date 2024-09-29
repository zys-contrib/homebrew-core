class Viddy < Formula
  desc "Modern watch command"
  homepage "https://github.com/sachaos/viddy"
  url "https://github.com/sachaos/viddy/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "fb76b1d0a25a2909a5e105f75534bda05c8d63ad82c1fb4f1bb5f828773b30f0"
  license "MIT"
  head "https://github.com/sachaos/viddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4145ce20a9f9da725e3f0faeca92cadade196198cbf96843d572d5bd83d91832"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37bb8b6f8992a88aac0b1110bec2d208f58c61341c71206e947a024c1a5f1980"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "431048e14383439df04c4e5e18a84132815dad2fa797054bff8bd9fe5ef2f86b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ad1668f9f280a82bdc5d01def46eae09ae43140e4b0b385e0733303870298e6"
    sha256 cellar: :any_skip_relocation, ventura:       "e0873e16dd2f8b91085cbc1d90efbd547e56946b23b819180f14df2b3634fe59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bafd5772eff6c44834d7f64ddb3f822012440963affb3cd8ee2d49996bbadea"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Errno::EIO: Input/output error @ io_fread - /dev/pts/0
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      pid = fork do
        system bin/"viddy", "--interval", "1", "date"
      end
      sleep 2
    ensure
      Process.kill("TERM", pid)
    end

    assert_match "viddy #{version}", shell_output("#{bin}/viddy --version")
  end
end
