class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "ea73a5463d30c5d5dfd473b11a27f2f25942635121dc3fc89297eeb22755ce8f"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "70adda7b82753f372220c444508c4f750fe2cff4afe11d525ebce8c65a03a5f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39e83c63687917d10cd89e0349623219cc7bbea5adabd24ee6a724e183638a93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "867751b83affaed5f778d7417fb30fdee21887b1ad1de9796e997148a4397c7e"
    sha256 cellar: :any_skip_relocation, sonoma:         "4fe9e0be8d3b2e1a8562d2b2efe10149784e698d202150842d0eecff3b986bec"
    sha256 cellar: :any_skip_relocation, ventura:        "b5a65a608720253834a1b1b468c1b52cb0258bb49cde4119cdc94b90ed844481"
    sha256 cellar: :any_skip_relocation, monterey:       "03123e45da56a89cd370b62a38d4c5cc6cb581135545499d943b6ad2ac2f9761"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e844ae346d1edd3b202771dfbcfe32f3496f4f5d8d0dfa2fc7ab185df5e3f947"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"starship", "completions")
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
