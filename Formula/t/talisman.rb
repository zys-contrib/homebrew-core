class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https://thoughtworks.github.io/talisman/"
  url "https://github.com/thoughtworks/talisman/archive/refs/tags/v1.37.0.tar.gz"
  sha256 "40f9ab7d43fadf75abe7a4d71fac5ff083f71b63afada282146827725460d2d1"
  license "MIT"
  version_scheme 1
  head "https://github.com/thoughtworks/talisman.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75924535f98753f902d628dfe25a5e45a1a1064c2692effef0b3e56be2009937"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75924535f98753f902d628dfe25a5e45a1a1064c2692effef0b3e56be2009937"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75924535f98753f902d628dfe25a5e45a1a1064c2692effef0b3e56be2009937"
    sha256 cellar: :any_skip_relocation, sonoma:        "8985b3c786ba90b53e53e58022dfcac0d389b73a4b51aa98ad8f8f4541a07a96"
    sha256 cellar: :any_skip_relocation, ventura:       "8985b3c786ba90b53e53e58022dfcac0d389b73a4b51aa98ad8f8f4541a07a96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4fde7340d9580d9cb47d0ec6b4c48977d8ace8a6920868d158ae9a690b8d4de"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd"
  end

  test do
    system "git", "init", "."
    assert_match "talisman scan report", shell_output(bin/"talisman --scan")
  end
end
