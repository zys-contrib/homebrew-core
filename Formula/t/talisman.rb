class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https://thoughtworks.github.io/talisman/"
  url "https://github.com/thoughtworks/talisman/archive/refs/tags/v1.33.0.tar.gz"
  sha256 "2a31dcd297c82d1b0ffa9303c34d5ed9d2a5e14a33236d26ab17b1db1f9f4631"
  license "MIT"
  version_scheme 1
  head "https://github.com/thoughtworks/talisman.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "994b7fb7ab0e732f85a7900ba5a27e69d0355fc851f48b6f7156d25d5c19859c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "994b7fb7ab0e732f85a7900ba5a27e69d0355fc851f48b6f7156d25d5c19859c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "994b7fb7ab0e732f85a7900ba5a27e69d0355fc851f48b6f7156d25d5c19859c"
    sha256 cellar: :any_skip_relocation, sonoma:        "296165bf33326ebe9c644c057d071932915d6b21174cdbf142062487a1e49507"
    sha256 cellar: :any_skip_relocation, ventura:       "296165bf33326ebe9c644c057d071932915d6b21174cdbf142062487a1e49507"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da00be79e46fd5ed3eedcf83f655395dc1ea5a4fdafaf8318e6551249f947941"
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
