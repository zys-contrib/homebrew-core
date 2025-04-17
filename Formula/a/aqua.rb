class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://github.com/aquaproj/aqua/archive/refs/tags/v2.48.3.tar.gz"
  sha256 "0b5dd5d29922270e86449993a44f0625360debc83878e17330f375c2d0c4014f"
  license "MIT"
  head "https://github.com/aquaproj/aqua.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "357c448cc996c45bbceb5dce6a3dfd32ffbfaa132360238bca106d21bffae26e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "357c448cc996c45bbceb5dce6a3dfd32ffbfaa132360238bca106d21bffae26e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "357c448cc996c45bbceb5dce6a3dfd32ffbfaa132360238bca106d21bffae26e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0fb80916035e799064bb67bc5716f1ba4f7d9f0937b553c41c2ec02d12a43df"
    sha256 cellar: :any_skip_relocation, ventura:       "c0fb80916035e799064bb67bc5716f1ba4f7d9f0937b553c41c2ec02d12a43df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcb9e49ca96696827644624b3cf7eb9ec0631be80563387b1455675ec6ea4cb6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/aqua"

    generate_completions_from_executable(bin/"aqua", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aqua --version")

    system bin/"aqua", "init"
    assert_match "depName=aquaproj/aqua-registry", (testpath/"aqua.yaml").read
  end
end
