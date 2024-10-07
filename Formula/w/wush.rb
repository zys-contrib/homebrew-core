class Wush < Formula
  desc "Transfer files between computers via WireGuard"
  homepage "https://github.com/coder/wush"
  url "https://github.com/coder/wush/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "b3b14464aefd5714d2f596f787beaec9158c469fc988dbc7d344b06dafdd43b6"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d1e786b0f4efdddfecee543b6d9247bc9156072b15f4eecc2957f443ba87385"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4fe37055e145b48122e1b0a337480dca33f5c410ffcd219bfa21c0f2a3795e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9ceac15c7ca0fad88e43a560a0d3172809331b9a1bb37e8b59394922bc73d12e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2a2a56d08df53456386260245fb2dbb9036e3f835bc1a35756ca59690490640"
    sha256 cellar: :any_skip_relocation, ventura:       "11b42f7bf54474e661073ff11d7e084f30ba3ef163d495d88cc99ea12407c30a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d039b71e363e9d52cbc4ae0c60d82e1313907ecd6b47eaa3f75764cd7bb17421"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/wush"
  end

  test do
    read, write = IO.pipe

    pid = fork do
      exec bin/"wush", "serve", out: write, err: write
    end

    output = read.gets
    assert_includes output, "Picked DERP region"
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
