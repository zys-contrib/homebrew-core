class Popeye < Formula
  desc "Kubernetes cluster resource sanitizer"
  homepage "https://popeyecli.io"
  url "https://github.com/derailed/popeye/archive/refs/tags/v0.21.6.tar.gz"
  sha256 "b2fdf6f8741afe05363b43b081be4eb1283e18d293f1906ec5a59b3993fa82d9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c26fadd31514d523704d7951098ef173c861d05d9543ab9980cc79e549b0ba7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b12ef373326ecb6fd1be6f8a31da6b2c2795a39023eb110c1b55863b3040e09d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f32240f54aab2e3dcc1a58cf7c796a31f6a3adaad0460142cdc6c7f2dd3e96e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ec39d372bd2f5537765e1543e2c234ba7f966d73f087b24249a264a12aba924"
    sha256 cellar: :any_skip_relocation, ventura:       "81df6b8a947c95be6d130bda01a94d84fd602ffe2d811246575f499de87e4f08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f015d9ac7d0c4ccd32040fb1150f27362f35aca3eb9b5a31570415c24de4c1f8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/popeye/cmd.version=#{version}
      -X github.com/derailed/popeye/cmd.commit=#{tap.user}
      -X github.com/derailed/popeye/cmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"popeye", "completion")
  end

  test do
    output = shell_output("#{bin}/popeye --save --out html --output-file report.html 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/popeye version")
  end
end
