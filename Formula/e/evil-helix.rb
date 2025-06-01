class EvilHelix < Formula
  desc "Soft fork of the helix editor"
  homepage "https://github.com/usagi-flow/evil-helix"
  url "https://github.com/usagi-flow/evil-helix/archive/refs/tags/release-20250601.tar.gz"
  sha256 "8b4466988a06e2ba2bb12b9e423fc0a9613755d3e7f71a0ecb97f4407fb22b66"
  license "MPL-2.0"
  head "https://github.com/usagi-flow/evil-helix.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b1e3c0ba1218793a8b7ba5d15fd5798b2bf6b0c6780f1e8e60cdb8164ce6cf9c"
    sha256 cellar: :any,                 arm64_sonoma:  "5641c78dbf7e337d2383e4031645175d2cc7ae0c81997736164adc20ef520832"
    sha256 cellar: :any,                 arm64_ventura: "d8b286207a5d5a4af13450a7f86e29ff55f19ecb0ea42bc0278308f83e02f862"
    sha256 cellar: :any,                 sonoma:        "18af39d241bda37f98a777f9980261727ee63ca001fb9ef07893754372309248"
    sha256 cellar: :any,                 ventura:       "5636a0702d8468604d26f698208fc237125a6fdf0f1412d9553bc8fc9e063375"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be7405c37721a2caac27ae5b416288c4ba05a06ac2fe0594e2a58491de2595c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "beda696a5384eeaea0fc78f8eec67141f169e4ca905c0073ac9d2dd453b9b109"
  end

  depends_on "rust" => :build

  conflicts_with "helix", because: "both install `hx` binaries"
  conflicts_with "hex", because: "both install `hx` binaries"

  def install
    ENV["HELIX_DEFAULT_RUNTIME"] = libexec/"runtime"
    system "cargo", "install", "-vv", *std_cargo_args(path: "helix-term")
    rm_r "runtime/grammars/sources/"
    libexec.install "runtime"

    bash_completion.install "contrib/completion/hx.bash" => "hx"
    fish_completion.install "contrib/completion/hx.fish"
    zsh_completion.install "contrib/completion/hx.zsh" => "_hx"
  end

  test do
    file = "https://raw.githubusercontent.com/usagi-flow/evil-helix/refs/tags/release-#{version}/Cargo.toml"
    version = shell_output("curl #{file}")&.gsub!(/.0$/i, "")
    assert_match version.to_s, shell_output("#{bin}/hx --version")
    assert_match "✓", shell_output("#{bin}/hx --health")
  end
end
