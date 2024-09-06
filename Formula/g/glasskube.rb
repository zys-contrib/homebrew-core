class Glasskube < Formula
  desc "Missing Package Manager for Kubernetes"
  homepage "https://glasskube.dev/"
  url "https://github.com/glasskube/glasskube/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "4f9044f92e9736a4e8d70cb9a42b2becc4d2dcd995a82c48b45de7372e4db0af"
  license "Apache-2.0"
  head "https://github.com/glasskube/glasskube.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "96caf4cea855513bf94cf7033b6870c663f88798f183d898c80af4dc4d694ee5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96caf4cea855513bf94cf7033b6870c663f88798f183d898c80af4dc4d694ee5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96caf4cea855513bf94cf7033b6870c663f88798f183d898c80af4dc4d694ee5"
    sha256 cellar: :any_skip_relocation, sonoma:         "926cbccae77773bc28d2dec8acee9a28e8e13cbcb4394c7609787bf989679c9d"
    sha256 cellar: :any_skip_relocation, ventura:        "926cbccae77773bc28d2dec8acee9a28e8e13cbcb4394c7609787bf989679c9d"
    sha256 cellar: :any_skip_relocation, monterey:       "926cbccae77773bc28d2dec8acee9a28e8e13cbcb4394c7609787bf989679c9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c22b7fec0ea8a56707eed8b9d94c4957642c6b5aba68de3db99b31f34b8e3d65"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/glasskube/glasskube/internal/config.Version=#{version}
      -X github.com/glasskube/glasskube/internal/config.Commit=#{tap.user}
      -X github.com/glasskube/glasskube/internal/config.Date=#{time.iso8601}
    ]

    system "make", "web"
    system "go", "build", *std_go_args(ldflags:), "./cmd/glasskube"

    generate_completions_from_executable(bin/"glasskube", "completion")
  end

  test do
    output = shell_output("#{bin}/glasskube bootstrap --type slim 2>&1", 1)
    assert_match "Your kubeconfig file is either empty or missing!", output

    assert_match version.to_s, shell_output("#{bin}/glasskube --version")
  end
end
