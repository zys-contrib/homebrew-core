class Ko < Formula
  desc "Build and deploy Go applications on Kubernetes"
  homepage "https://ko.build"
  url "https://github.com/ko-build/ko/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "cc45d71db67186022e0587d81fa50d82f0da05fac2723be1f188e5caf3655107"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1043369454a04d4eacabb390b1dfc3f923d0738ade48f23e35e209d9baed6c78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1043369454a04d4eacabb390b1dfc3f923d0738ade48f23e35e209d9baed6c78"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1043369454a04d4eacabb390b1dfc3f923d0738ade48f23e35e209d9baed6c78"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3f6e6a48eea630a47f224dd52c9677429ed04db879d159e583422dff365a482"
    sha256 cellar: :any_skip_relocation, ventura:       "d3f6e6a48eea630a47f224dd52c9677429ed04db879d159e583422dff365a482"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d45b1a86b2df5e0564c257dd906089729c761609153e0921991189a6be1b305"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/google/ko/pkg/commands.Version=#{version}")

    generate_completions_from_executable(bin/"ko", "completion")
  end

  test do
    output = shell_output("#{bin}/ko login reg.example.com -u brew -p test 2>&1")
    assert_match "logged in via #{testpath}/.docker/config.json", output
  end
end
