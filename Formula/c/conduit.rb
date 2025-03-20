class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https://conduit.io/"
  url "https://github.com/ConduitIO/conduit/archive/refs/tags/v0.13.3.tar.gz"
  sha256 "5d685430b75c4e047cb09041070773947ea27fe087af0c96559d3bb156d0f778"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/conduit.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a061644d4f09ba431dcc0e34e42a51eab7680f18a44f094fb313a13e33100fc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31440cc8e2e61b83d3b8a40f2aaef45b0b3ebf5081c4f911e083e2013f8f6dec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e75701eb24952db42ae24438bc66a4aa8c3d245090a802c4e2cc101357932c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "de3c3b8a9087fccd097153a23b937f8b8afb8215796df1bd1f360aa1f1b4c433"
    sha256 cellar: :any_skip_relocation, ventura:       "c1b97349f4f82328a998513dcb9b1051116f30dd6ce5055a4ea604b30c976026"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fa048517071f229dd1e620c2e140fbd0f41a6202ef37030b3a16360bb65bbbd"
  end

  depends_on "go" => :build

  def install
    system "make", "VERSION=#{version}"
    bin.install "conduit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/conduit --version")

    File.open("output.txt", "w") do |file|
      # redirect stdout to the file
      $stdout.reopen(file)
      pid = spawn bin/"conduit", "run", "--api.enabled", "true",
                                 "--api.grpc.address", ":0",
                                 "--api.http.address", ":0"
      sleep(5)
      # Kill process
      Process.kill("SIGKILL", pid)
    end
    assert_match "grpc API started", (testpath/"output.txt").read
    assert_match "http API started", (testpath/"output.txt").read
  end
end
