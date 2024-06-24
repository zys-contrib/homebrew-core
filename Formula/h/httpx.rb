class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/refs/tags/v1.6.5.tar.gz"
  sha256 "5329d93921f24a9126122f2003d6bfdee57c2cfeb16903dd40a9564c674354b6"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b13ff657ab88c20de294a6ac47f6ebbf66bbb74cebacf78fde9380307c9e9a9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6770536185b0437f88d6b63cfd5313774cc64d251c58969ff5da53a40b9502ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db91e6e473d05af8c8656cbbbe99500858fb1f0e7fc01dd58326549ae6781ba7"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd7cd82b9feb2ad92cc29e78aaf4bdc64773b190ac326a0078fd2dc78b32d587"
    sha256 cellar: :any_skip_relocation, ventura:        "69d633c13798f2fd5b0eaaeae0357fffa2fcd3ddac86eda830c17adbacf7dc12"
    sha256 cellar: :any_skip_relocation, monterey:       "d31b5bcb163d4d5a14b06a1b22f2a643dd460162c4f9cc4730bbb9b4fc2175f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f799be3ffd91677693d0fe478cabb01657ef44ea9e43686d5bf275c3ce2969e5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/httpx"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/httpx -silent -title -json -u example.org"))
    assert_equal 200, output["status_code"]
    assert_equal "Example Domain", output["title"]
  end
end
