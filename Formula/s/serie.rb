class Serie < Formula
  desc "Rich git commit graph in your terminal"
  homepage "https://github.com/lusingander/serie"
  url "https://github.com/lusingander/serie/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "f806e5d818c6211bb1d194b4e751b5ab1dd4571a5857e910fdca29e77c2cf4e8"
  license "MIT"
  head "https://github.com/lusingander/serie.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/serie --version")

    # Fails in Linux CI with "failed to initialize terminal: ... message: \"No such device or address\" }"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "Initial commit"

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"serie", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "Initial commit", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
