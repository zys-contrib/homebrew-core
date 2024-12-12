class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "bbca72a23fabc001a563f5da301ab28bfb0baecf49238b41810c8bf161e12094"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "324183582f36e1835b2d26d4291902d48499005bf757d07e3a03445f4575e978"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ab4bd2f296549dacdc16b0e5fe20032c6a1b01fd9e8b911947c9ab98dfa1bed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "09f6ccfca746951f62bc18c017566bb837f36319293040a2ab1840acc634049d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c987d6ad164cf1500d9d411d6bb7c2a54089c8132e803cd224659c0afbd5a341"
    sha256 cellar: :any_skip_relocation, ventura:       "6ce8bea7a5faf8a6e60c6e71795d3a96891df0d16c16f4c7d7535927681f3109"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df5520d359ef96b2f79f44a80883abc7b7d9eb7c47e3feeb8e5afe66f4c07008"
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
