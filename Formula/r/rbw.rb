class Rbw < Formula
  desc "Unofficial Bitwarden CLI client"
  homepage "https://github.com/doy/rbw"
  url "https://github.com/doy/rbw/archive/refs/tags/1.13.1.tar.gz"
  sha256 "2e3181417732b5ab32456a1babff2febeee695604e85db2c94668270ed8a2036"
  license "MIT"
  head "https://github.com/doy/rbw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c27aca374444a46673b13156b329da80b754b6470acd25a570d59aea5c2bbf82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc3077a43a6cf1ab358cd096d8a207a469bcd22dc1b02e504bedd211bfbec38b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d4ddcfbb04f28e8076de33a6400899a00b1f6ee8ddb919993e83476743da5ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "f58116f70687aaafc609cedd3726d5a4abef08adbf037bdf7daa4fed1a03c6c9"
    sha256 cellar: :any_skip_relocation, ventura:       "64167c2e29e8edbca0b95cf67adbbdaf30ff3df06a286739a155ed4738d7867d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "064af12f9e87f0466a3a4ae65c20bad233ee38ab28fceaf6111d76deb40848c6"
  end

  depends_on "rust" => :build
  depends_on "pinentry"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"rbw", "gen-completions")
  end

  test do
    expected = "ERROR: Before using rbw"
    output = shell_output("#{bin}/rbw ls 2>&1 > /dev/null", 1).each_line.first.strip
    assert_match expected, output
  end
end
