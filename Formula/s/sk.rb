class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://github.com/skim-rs/skim/archive/refs/tags/v0.20.2.tar.gz"
  sha256 "e0fee383c015777eb7aea1e5ed932b06dee6da990583c665ecf1389600e2789a"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e1b9f6f24d8201025bc7a2971604439884e8d51ba8d208b8d648301d95c1733"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b1bb681f1657af3d9ea109a2e068fce50a0bfe336e87201d10ea094aaa62942"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88a1db5e0a5031ebda14443ad1e0d111f2feebd02a77cec521200d9e77e380ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4c0a8f746612ea30a94f53c6d7c34faad7b1c8d98f776929e26871d87e3f4b6"
    sha256 cellar: :any_skip_relocation, ventura:       "f5ec538e69225154bff53843ddc882bdd5d4908893ddb5d1fcea29960183f806"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "014152e3bc81decb0c176a3fc5e447a3978e4300194429190e7a192695289d61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "410a954f16724253954e4e69e2eca4464e8600d2f02ee86bfad3b67247509610"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "skim")

    generate_completions_from_executable(bin/"sk", "--shell")
    bash_completion.install "shell/key-bindings.bash"
    fish_completion.install "shell/key-bindings.fish" => "skim.fish"
    zsh_completion.install "shell/key-bindings.zsh"
    man1.install buildpath.glob("man/man1/*.1")
    bin.install "bin/sk-tmux"
  end

  test do
    assert_match(/.*world/, pipe_output("#{bin}/sk -f wld", "hello\nworld"))
  end
end
