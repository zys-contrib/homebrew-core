class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://github.com/alexpasmantier/television/archive/refs/tags/0.7.1.tar.gz"
  sha256 "18b1590003c065813d2726cc835ae4a33c5ce0bd9de6255dfad0e6e9bb759169"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "111f8848ec40a0748677a89cb4017596d78d9a2b6250e8b24479cabba628601d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69444202a4a619759708ad7a8b4cdf4417e58f3d3bda6985592b7022244de3da"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af7a5f22f9488b9bff815990c5e887880bf1b29b9c18a055b884a4f81650038c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7aa2d1c85d3ae23dfb83a572da4d2c1a177db7cde34a221d984a3a02a0f5b1cf"
    sha256 cellar: :any_skip_relocation, ventura:       "652d4e3cab25849c3dd09ceb44641065e2a91d3e35a434ecb463a1869a0e175d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ec0de65fa6c18e881e8f9cde85d9e2ae912ffae9146accd8bc6756ed1d11b33"
  end

  depends_on "rust" => :build

  conflicts_with "tidy-viewer", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tv -V")

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"tv", [:out, :err] => output_log.to_s
      sleep 2
      assert_match "Preview", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
