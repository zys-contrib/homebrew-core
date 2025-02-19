class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.93.tar.gz"
  sha256 "c9d366f8fc378596ebc7dbe35a2ad331df403424000f4611a96e6bc710742c1b"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7761ae76c52fd2826be4a7eaa544abfa74832d193ea24d9d8ec7f715911bc4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7761ae76c52fd2826be4a7eaa544abfa74832d193ea24d9d8ec7f715911bc4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7761ae76c52fd2826be4a7eaa544abfa74832d193ea24d9d8ec7f715911bc4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca90d494a7e048e501a8e6643eabec1e7fabe80b0c3b96c556dab7f5a6cfdc0c"
    sha256 cellar: :any_skip_relocation, ventura:       "ca90d494a7e048e501a8e6643eabec1e7fabe80b0c3b96c556dab7f5a6cfdc0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "395ae76f0ca13e50b595b3a5d5ab7855e79c01cecb94e9147ac3185372e22d22"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectl-testkube"), "./cmd/kubectl-testkube"
    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", "completion")
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get tests 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end
