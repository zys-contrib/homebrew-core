class Thriftgo < Formula
  desc "Implementation of thrift compiler in go language with plugin mechanism"
  homepage "https://github.com/cloudwego/thriftgo"
  url "https://github.com/cloudwego/thriftgo/archive/refs/tags/v0.3.17.tar.gz"
  sha256 "365bb6dfe2c8624b4ffb7c5f29d6664a6b04dd1a3e0ddc1fc171833ed4672e63"
  license "Apache-2.0"
  head "https://github.com/cloudwego/thriftgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c0a639ae795e77eb1d7cc1e88b6a436f7a9577a90c722fd1ae213b2ac7fefab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c0a639ae795e77eb1d7cc1e88b6a436f7a9577a90c722fd1ae213b2ac7fefab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c0a639ae795e77eb1d7cc1e88b6a436f7a9577a90c722fd1ae213b2ac7fefab"
    sha256 cellar: :any_skip_relocation, sonoma:         "c0347fcfc83105d9baef34bb99960d161f043f9128e6f185bb662ef10930b20f"
    sha256 cellar: :any_skip_relocation, ventura:        "c0347fcfc83105d9baef34bb99960d161f043f9128e6f185bb662ef10930b20f"
    sha256 cellar: :any_skip_relocation, monterey:       "c0347fcfc83105d9baef34bb99960d161f043f9128e6f185bb662ef10930b20f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cea9d33f382b95e554142b2d4d3feb82b65d46d5c1a4be29c667b61ea392afb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/thriftgo --version 2>&1")
    assert_match "thriftgo #{version}", output

    thriftfile = testpath/"test.thrift"
    thriftfile.write <<~EOS
      namespace go api
      struct Request {
              1: string message
      }
      struct Response {
              1: string message
      }
      service Hello {
          Response echo(1: Request req)
      }
    EOS
    system bin/"thriftgo", "-o=.", "-g=go", "test.thrift"
    assert_predicate testpath/"api"/"test.go", :exist?
    refute_predicate (testpath/"api"/"test.go").size, :zero?
  end
end
