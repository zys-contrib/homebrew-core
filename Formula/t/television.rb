class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://github.com/alexpasmantier/television/archive/refs/tags/0.6.2.tar.gz"
  sha256 "79ad4464928812de3a6672c1dba100bf327f90fd7900eed2d0c24a9cdae047f8"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f8aea700de021a65302ec117f8327c38b13124e8714d22c0827f5e75779e7dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e017b42b733895301c40d6d936909a7e938eed44cae166be4a760aed0b370c9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2045766a5bb47a4335e96ff4ac419841e3e2290ea39acbb6a3afe05c1bf7ff0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8730b32a6f2c5d9748bbb280d8c88fd4a496075ae95e5c9311722999ca19346"
    sha256 cellar: :any_skip_relocation, ventura:       "1bfbfa6cdb92dd205b387dca10573734c54288c0d303463a7979896691bbdcd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "852b967754f4fc19ddcb824a55be85ff4d89b68d1d411aae9c29d49c2c82bde3"
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
