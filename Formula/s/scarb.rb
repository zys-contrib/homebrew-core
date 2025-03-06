class Scarb < Formula
  desc "Cairo package manager"
  homepage "https://docs.swmansion.com/scarb/"
  url "https://github.com/software-mansion/scarb/archive/refs/tags/v2.11.1.tar.gz"
  sha256 "613ab337a19c131da49d87336335227770419513c6f4bbf336ca44cb9862c715"
  license "MIT"
  head "https://github.com/software-mansion/scarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec977059f8be25a8b10bdfaffa4e0d7e815e2afba47ef0caed66a2c6ee207d42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba8595c1c634b0d6ffd47aff53501bedd7e4630dcc4fbf862a1f8006ae3a89b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3db7f34fa3629f6a5702699f7ff288897a4ec4a7628a8e87c96db4d83ab3f463"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca0ba31da842ca53505929ac6e0cbc719a87397d39a048eea8624b85d13fece0"
    sha256 cellar: :any_skip_relocation, ventura:       "c22b1aebee7dd7e4d7871de34232ce8ef6d7063098afce5ac5906a3133040f0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c729f30ffd0f4ee05b24e155d23ea99260f1f62c524b11ba9bc5333a3bf428a"
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  def install
    %w[
      scarb
      extensions/scarb-cairo-language-server
      extensions/scarb-cairo-run
      extensions/scarb-cairo-test
      extensions/scarb-doc
    ].each do |f|
      system "cargo", "install", *std_cargo_args(path: f)
    end
  end

  test do
    ENV["SCARB_INIT_TEST_RUNNER"] = "cairo-test"

    assert_match "#{testpath}/Scarb.toml", shell_output("#{bin}/scarb manifest-path")

    system bin/"scarb", "init", "--name", "brewtest", "--no-vcs"
    assert_path_exists testpath/"src/lib.cairo"
    assert_match "brewtest", (testpath/"Scarb.toml").read

    assert_match version.to_s, shell_output("#{bin}/scarb --version")
    assert_match version.to_s, shell_output("#{bin}/scarb cairo-run --version")
    assert_match version.to_s, shell_output("#{bin}/scarb cairo-test --version")
    assert_match version.to_s, shell_output("#{bin}/scarb doc --version")
  end
end
