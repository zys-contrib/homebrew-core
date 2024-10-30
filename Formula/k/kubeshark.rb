class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https://www.kubeshark.co/"
  url "https://github.com/kubeshark/kubeshark/archive/refs/tags/v52.3.86.tar.gz"
  sha256 "c7e33253bde9967a11bf983d6ef34d093a98d9ae9a3370e461eb2a824307dc2b"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f402e46af70ba00ab5d2405ea2b3fdbab370ff9b778df32d86ba9493c90f3ad0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa423c7151f1519600872a22399c16225d250014d9778dd09c5ab825fd96dc07"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0507c4a209956cedda2a66f93488c6b271de0a140ba4f656a1d80ede0606112e"
    sha256 cellar: :any_skip_relocation, sonoma:        "25804c9e1fe054a442ea55b4fb66cbe6d9f141087951ca1db7b23e1c2bdead18"
    sha256 cellar: :any_skip_relocation, ventura:       "62abdf671b76178d673494444305179330dfa0678aed6a79b57db5f861af0828"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f77ff1d25bd416b6da2ca43b207abf886fef40aced9d598350ae5eea3a6eb75d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X "github.com/kubeshark/kubeshark/misc.Platform=#{OS.kernel_name}_#{Hardware::CPU.arch}"
      -X "github.com/kubeshark/kubeshark/misc.BuildTimestamp=#{time}"
      -X "github.com/kubeshark/kubeshark/misc.Ver=v#{version}"
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    version_output = shell_output("#{bin}/kubeshark version")
    assert_equal "v#{version}", version_output.strip

    tap_output = shell_output("#{bin}/kubeshark tap 2>&1")
    assert_match ".kube/config: no such file or directory", tap_output
  end
end
