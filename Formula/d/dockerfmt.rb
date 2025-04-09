class Dockerfmt < Formula
  desc "Dockerfile format and parser. a modern dockfmt"
  homepage "https://github.com/reteps/dockerfmt"
  url "https://github.com/reteps/dockerfmt/archive/refs/tags/0.3.0.tar.gz"
  sha256 "265e49b908b848b6e4b24c97520484fa92ad167c565fd6b05e8d3c0d261e5241"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61933de82877e235f9300127ba05f66007673e6fb3bfe9bcd4312b01bd07b81e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61933de82877e235f9300127ba05f66007673e6fb3bfe9bcd4312b01bd07b81e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "61933de82877e235f9300127ba05f66007673e6fb3bfe9bcd4312b01bd07b81e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f8d9438137a7aaf7b6b79df39fd7a517783aab9cf0e3719e5d8383a6e81a7b8"
    sha256 cellar: :any_skip_relocation, ventura:       "9f8d9438137a7aaf7b6b79df39fd7a517783aab9cf0e3719e5d8383a6e81a7b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97cc88369bb96a822fc88ae884f3b3dde759722fb59545ff77764fc2e9f22af8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"dockerfmt", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerfmt version")

    (testpath/"Dockerfile").write <<~DOCKERFILE
      FROM alpine:latest
    DOCKERFILE

    output = shell_output("#{bin}/dockerfmt --check Dockerfile 2>&1", 1)
    assert_match "File Dockerfile is not formatted", output
  end
end
