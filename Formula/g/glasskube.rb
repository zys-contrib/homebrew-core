class Glasskube < Formula
  desc "Missing Package Manager for Kubernetes"
  homepage "https://glasskube.dev/"
  url "https://github.com/glasskube/glasskube/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "327d3f875389d590b9e74ae5e1125967b79b36fde859370c89873b680124162b"
  license "Apache-2.0"
  head "https://github.com/glasskube/glasskube.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf5814c5c135bd15dc2800602f6281ead898aaebd807d1e980c28a5a659ea416"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf5814c5c135bd15dc2800602f6281ead898aaebd807d1e980c28a5a659ea416"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf5814c5c135bd15dc2800602f6281ead898aaebd807d1e980c28a5a659ea416"
    sha256 cellar: :any_skip_relocation, sonoma:         "aafdc2b6ae572e0b8974c1648317d33e8a1c28e71ecf99af2e1d28a02b6d803d"
    sha256 cellar: :any_skip_relocation, ventura:        "aafdc2b6ae572e0b8974c1648317d33e8a1c28e71ecf99af2e1d28a02b6d803d"
    sha256 cellar: :any_skip_relocation, monterey:       "aafdc2b6ae572e0b8974c1648317d33e8a1c28e71ecf99af2e1d28a02b6d803d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37a213f7be07e4046cf29e74eb829959469eedcf380cc84d6d0131fafbd43709"
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
