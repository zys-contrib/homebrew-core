class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "55b31b8bbe639d4c2c78ed61e7e84b874a0d1ccd2f80e92dffcb392deedf1805"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "723f9db0e4dd92676bef2c53a40d3bbf69955dfaedad5c40ec1ee9df84e27313"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8157d3ba39c00de1cad5354a0946aeb7c9e5e48136eb84f7728b5facc91daf63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e16946c0d79ae6459cb3dda4f6a81b1797eddcc5aca71023431f572b29ff57e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "25166f561d661bc9d9ea48c269061491e9cc227c630854e4d0b419ca47c31e99"
    sha256 cellar: :any_skip_relocation, ventura:        "a983b708fe5a5f802625d33098b5c8a366fc4d697acd56fe620d5a107b861e5f"
    sha256 cellar: :any_skip_relocation, monterey:       "56db10fb5eaaada6cff27b9dc9325ce3c4b38c10d662c7bf9ff21bfc22eb7112"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ab186e12edd2ecd7727e0c435f1628adcb59144ccfb86bed17b9a25edcc2b13"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/livekit-cli"
  end

  test do
    output = shell_output("#{bin}/livekit-cli create-token --list --api-key key --api-secret secret")
    assert output.start_with?("valid for (mins):  5")
    assert_match "livekit-cli version #{version}", shell_output("#{bin}/livekit-cli --version")
  end
end
