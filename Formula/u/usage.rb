class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "0d80734b4b6952e2b79bc09b3f63a58781443fa824b389d16d87251662d79c6e"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d8f2d74f455ef641b1720d58e2367862510499332446e3024e2b9b817361e4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b0b90ffe77e6ad2a9344a0b03de239e0aebbb3a8a908fb13dd5293d0c2fdef3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f07033804b9df2b8214034feba60135c00007c0f8686b674ebcda84a903fd02"
    sha256 cellar: :any_skip_relocation, sonoma:        "65300752e8c1a91e7eda3b0b9ccc4e680f939d1e7551a68c9abe5455666415c1"
    sha256 cellar: :any_skip_relocation, ventura:       "695750d7a42dea42bcdce6e0c69bd497abce1e529ad1727481876f5e0e17b096"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c82e8928321e287a218a86528797694981c2b64c42db957a2cc127a0115f356"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "usage-cli", shell_output(bin/"usage --version").chomp
    assert_equal "--foo", shell_output(bin/"usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end
