class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.123.tar.gz"
  sha256 "82b393fcc3ca7ad310eb07a361acb98836337eca3fcba9586d1bc64c04a110ea"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44ad9562dabc5cd97b9af07824187bc864c6a46614bbc7d1a8e4ff663452e8d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44ad9562dabc5cd97b9af07824187bc864c6a46614bbc7d1a8e4ff663452e8d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44ad9562dabc5cd97b9af07824187bc864c6a46614bbc7d1a8e4ff663452e8d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "157f43fc846de3c4b78c0b48d9d0667bd2252416f3df770ce854bb42901f480f"
    sha256 cellar: :any_skip_relocation, ventura:       "157f43fc846de3c4b78c0b48d9d0667bd2252416f3df770ce854bb42901f480f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0892c7c53b7e8abb6e347519a8cdbab296b1d72edc7be240637af3dc4844a82"
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
