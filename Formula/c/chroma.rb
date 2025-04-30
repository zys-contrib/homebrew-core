class Chroma < Formula
  desc "General purpose syntax highlighter in pure Go"
  homepage "https://github.com/alecthomas/chroma"
  url "https://github.com/alecthomas/chroma/archive/refs/tags/v2.17.2.tar.gz"
  sha256 "731fc4ee95095156e8f84684eb7bb9543ce41bdb4a6459a0387b78ef223ed1e8"
  license "MIT"
  head "https://github.com/alecthomas/chroma.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a26687f1e14bb55d720f4f41b184ad528dbd659c738d5234dc39d9764204a3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a26687f1e14bb55d720f4f41b184ad528dbd659c738d5234dc39d9764204a3f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a26687f1e14bb55d720f4f41b184ad528dbd659c738d5234dc39d9764204a3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e74cdfab7f5cd5a57a8f98eb4db383df4ff83bded68960ddc5514b8daa0423e"
    sha256 cellar: :any_skip_relocation, ventura:       "5e74cdfab7f5cd5a57a8f98eb4db383df4ff83bded68960ddc5514b8daa0423e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f8a4e6eac5c771d9f8600c00dc23ac109455550331ad6aa7299c42bf1f432f0"
  end

  depends_on "go" => :build

  def install
    cd "cmd/chroma" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    json_output = JSON.parse(shell_output("#{bin}/chroma --json #{test_fixtures("test.diff")}"))
    assert_equal "GenericHeading", json_output[0]["type"]
  end
end
