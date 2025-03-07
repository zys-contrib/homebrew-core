class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "d07a964bd097b49193f05795c431f2774e14cb658f68725d181ad3484ad9fcf3"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8776e81264676c2f61a4853301510635ee4e77274a9f2e996263067d03347fe9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3a8056aacdfa8643167bbd3caf20d1e9efdfd2326af9048b8c73da35c1a7544"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "04bebc4e34695b9fbc93c20754a873655a48e33b9106e8db4350cdc5af696f71"
    sha256 cellar: :any_skip_relocation, sonoma:        "20544a8f27400cea771dfc2225305e41c77bfd62168d2b1b6d2a97056fbcb833"
    sha256 cellar: :any_skip_relocation, ventura:       "52a93291c8848edb434c3018fe69667b2c211296c488c9aa9c359bf5671bb276"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ba3c83c3a6cdbe95512f09a56fd064d64e19bec2fb8def2b6ca687fae92bd30"
  end

  depends_on "go" => :build

  def install
    cilium_version_url = "https://raw.githubusercontent.com/cilium/cilium/main/stable.txt"
    cilium_version = Utils.safe_popen_read("curl", cilium_version_url).strip

    ldflags = %W[
      -s -w
      -X github.com/cilium/cilium/cilium-cli/defaults.CLIVersion=v#{version}
      -X github.com/cilium/cilium/cilium-cli/defaults.Version=#{cilium_version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"cilium"), "./cmd/cilium"

    generate_completions_from_executable(bin/"cilium", "completion")
  end

  test do
    assert_match("cilium-cli: v#{version}", shell_output("#{bin}/cilium version"))
    assert_match("Kubernetes cluster unreachable", shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end
