class Asak < Formula
  desc "Cross-platform audio recording/playback CLI tool with TUI"
  homepage "https://github.com/chaosprint/asak"
  url "https://github.com/chaosprint/asak/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "171916d7964e2a54ae92b38ffdb67f841e21da89e1b1ffcfb96e385999e066f2"
  license "MIT"
  head "https://github.com/chaosprint/asak.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ed8ad6aff3db12016ca1f7f2f0242ff2373eebf52707125a67c326d0416a79b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bd72ff2e29d2a12e2e7a3970c55505329d0cee01d76418baba55b3ea3a6e0de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5b2a5bfba37fd35fdafc19cc8f7cf44fc1d1d764dadf912ad7b0011154556670"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f555b3fcbaf3125eef3d2dc3ce942777c3982f526b1d5f96bb7d049c23033c3"
    sha256 cellar: :any_skip_relocation, ventura:       "1906d3fffa8236bdf4d41c625fb9273cb61bcb6a23987818294e86003a65d45f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b773ec9f9d8c4f69c29b99a2543d9b1be34029e475438b6236916d2fd8f885b3"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "jack"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "target/completions/asak.bash" => "asak"
    fish_completion.install "target/completions/asak.fish" => "asak"
    zsh_completion.install "target/completions/_asak" => "_asak"
    man1.install "target/man/asak.1"
  end

  test do
    output = shell_output("#{bin}/asak play")
    assert_match "No wav files found in current directory", output

    assert_match version.to_s, shell_output("#{bin}/asak --version")
  end
end
