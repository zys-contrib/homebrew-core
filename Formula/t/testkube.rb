class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.17.57.tar.gz"
  sha256 "7710f2abd34765410ab670f5d03103b20b35b6905812533e6e4c45881864da93"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0a5d3f11b8858828c056c607e8fca192d219624e4ddb50e7788aa1f7f6a50e75"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e5abdd4175b117392cd141d2a1813eb2d1886c52d8cbfc68742b274ff4e0bd6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99de5e3a993a432b1b9ceec011414028eb201ec14c6a605877675e65f5331fb5"
    sha256 cellar: :any_skip_relocation, sonoma:         "05f558974044178b95eb356fb7ef04dca2099ed110d97a5d9aebe571e5e11526"
    sha256 cellar: :any_skip_relocation, ventura:        "d6f0d9b6c010fb509237e10a8bbdc09394afff1766db6fd94da95ff7dd2ef2e8"
    sha256 cellar: :any_skip_relocation, monterey:       "f55ecdbe6ca8138bc932384f18e082b11ea8ea782def74b7312ff43ee20b8953"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "424a879c667eeccdcc89809a608f1b27189fa0b58aacb6ac2ac0e604646797cb"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(output: bin/"kubectl-testkube", ldflags:),
      "cmd/kubectl-testkube/main.go"

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
