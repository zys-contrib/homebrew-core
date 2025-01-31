class Tuisky < Formula
  desc "TUI client for bluesky"
  homepage "https://github.com/sugyan/tuisky"
  url "https://github.com/sugyan/tuisky/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "cedfc4ae396af0dadc357f93b65a9f35cfda3afca1a5ad41d9d27cc293bc8df4"
  license "MIT"
  head "https://github.com/sugyan/tuisky.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec91483715129272fe6838210eb3171d544c4f959e7124711951f868e5535e5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e59d40de23a058c94aac3d1ba6e99e916b1d8acbda469970847b937760115ce6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4fc96ae7f73ee11a89b1299f511c30d520676be8a13996bfc99f03c0dc238d05"
    sha256 cellar: :any_skip_relocation, sonoma:        "93b22b23643b4aea41293b24be6b859435fd05b9a2acbb3425bee8ce85217978"
    sha256 cellar: :any_skip_relocation, ventura:       "2ad91ad8cb03dd39a3167efa2162e0a5c409322967c6d6369a69c97c4e8dd63e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a2306a9137730db5cf1f04aa315c442e3b340535867c451c7942bb0dc414357"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    pkgetc.install "config/example.config.toml" => "config.toml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tuisky --version")

    # Fails in Linux CI with `No such device or address (os error 6)`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"tuisky", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "https://bsky.social", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
