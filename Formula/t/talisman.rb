class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https://thoughtworks.github.io/talisman/"
  url "https://github.com/thoughtworks/talisman/archive/refs/tags/v1.35.1.tar.gz"
  sha256 "bdf7be9943cea535f81e463a60464f7a5bbad2c08fe7096e9cd71a00bb8cfc48"
  license "MIT"
  version_scheme 1
  head "https://github.com/thoughtworks/talisman.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8164c98badb6af264ff9f11e1453ca5153439f9283532a82d803a7b072acd8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8164c98badb6af264ff9f11e1453ca5153439f9283532a82d803a7b072acd8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e8164c98badb6af264ff9f11e1453ca5153439f9283532a82d803a7b072acd8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbd6b9890a9acdf124eb58b1ecc186107a1241096ee94813e645c10a8b99e7fc"
    sha256 cellar: :any_skip_relocation, ventura:       "fbd6b9890a9acdf124eb58b1ecc186107a1241096ee94813e645c10a8b99e7fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fddc5c6974656ec9b24e1925061e447c618a0168964344bcd7fc1299138638c9"
  end

  depends_on "go" => :build

  # go.mod update, upstream pr ref, https://github.com/thoughtworks/talisman/pull/479
  patch do
    url "https://github.com/thoughtworks/talisman/commit/592b23a7a757e776a4203c23724181a1d13ab9ae.patch?full_index=1"
    sha256 "f069f83c819a45496ca9edbca2c5fa244c18df5a1f45eaa1d99dfbbdc1180ec5"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd"
  end

  test do
    system "git", "init", "."
    assert_match "talisman scan report", shell_output(bin/"talisman --scan")
  end
end
