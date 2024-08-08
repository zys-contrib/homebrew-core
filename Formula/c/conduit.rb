class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https://conduit.io/"
  url "https://github.com/ConduitIO/conduit/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "da16e12823640869e388ebbce5e5f1fac73ba0d3b0e360a7205d87177ceaa795"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/conduit.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "45135006bad71eae6780bc3b67189f4364e69d8429d35996343bcaa705b73b94"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "015a4ba313637f28dd417591e38e5c7ea244c35ea18ace4a5c92ec3ea2a8f097"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5b9973e94ab8e1023656cff7bcdd351f4ceafd9dccba5783344dba3e008b171"
    sha256 cellar: :any_skip_relocation, sonoma:         "54360df8410c8e9afd674c417d5b03194ebc74a77389975cbb57f19dfb935f07"
    sha256 cellar: :any_skip_relocation, ventura:        "95061d7ab9611d98dfe1509840e9aa891de9d329d2229b166b631ebcfd2dcada"
    sha256 cellar: :any_skip_relocation, monterey:       "b55a4771a9f0735fd524118f564eb480e1a7673fc5e0b1dc731ea7b6688089c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8897606ee9784d12be3319e4146d0d59cd59efde28c19841adf6d404d7ec28b9"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    system "make", "VERSION=#{version}"
    bin.install "conduit"
  end

  test do
    # Assert conduit version
    assert_match(version.to_s, shell_output("#{bin}/conduit -version"))

    File.open("output.txt", "w") do |file|
      # redirect stdout to the file
      $stdout.reopen(file)
      pid = fork do
        # Run conduit with random free ports for gRPC and HTTP servers
        exec bin/"conduit", "--grpc.address", ":0",
                            "--http.address", ":0"
      end
      sleep(5)
      # Kill process
      Process.kill("SIGKILL", pid)
    end
    assert_match "grpc API started", (testpath/"output.txt").read
    assert_match "http API started", (testpath/"output.txt").read
  end
end
