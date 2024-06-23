class Oj < Formula
  desc "JSON parser and visualization tool"
  homepage "https://github.com/ohler55/ojg"
  url "https://github.com/ohler55/ojg/archive/refs/tags/v1.22.1.tar.gz"
  sha256 "bf457a7e35806a63f7ac3ff09f453c663186ab53f8b67515e0890cbcf44da771"
  license "MIT"
  head "https://github.com/ohler55/ojg.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2db70feafeec01d0e075dc067428c19a7a617b27d92960a840937c96b312e35e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2db70feafeec01d0e075dc067428c19a7a617b27d92960a840937c96b312e35e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2db70feafeec01d0e075dc067428c19a7a617b27d92960a840937c96b312e35e"
    sha256 cellar: :any_skip_relocation, sonoma:         "f9b79ed419f211663765cfe4ae1410d3ed391b1fee5faa36e9f089fc9826116e"
    sha256 cellar: :any_skip_relocation, ventura:        "f9b79ed419f211663765cfe4ae1410d3ed391b1fee5faa36e9f089fc9826116e"
    sha256 cellar: :any_skip_relocation, monterey:       "f9b79ed419f211663765cfe4ae1410d3ed391b1fee5faa36e9f089fc9826116e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1204c541c180df8fb4661314d54e1de4d734543026db2ea4fab083501060def2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), "./cmd/oj"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/oj -z @.x", "{x:1,y:2}")
  end
end
