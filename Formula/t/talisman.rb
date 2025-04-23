class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https://thoughtworks.github.io/talisman/"
  url "https://github.com/thoughtworks/talisman/archive/refs/tags/v1.36.0.tar.gz"
  sha256 "765d585fff532882d65d63dca2455edead2a392452a42e7089a600c23b46e5c8"
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

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd"
  end

  test do
    system "git", "init", "."
    assert_match "talisman scan report", shell_output(bin/"talisman --scan")
  end
end
