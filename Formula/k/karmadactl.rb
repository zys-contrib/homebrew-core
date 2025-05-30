class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https://karmada.io/"
  url "https://github.com/karmada-io/karmada/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "f53776a352b0f6da4abe5b163cb7d764ab9c580e8c44e001af2c46485eb3d4f8"
  license "Apache-2.0"
  head "https://github.com/karmada-io/karmada.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "608ac5bb07946468c6c55928d344c0f5a0b8278ac16a3c263ba9c427aa7c7f57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a103227dff8cdb8437d12de6c28e6ee052be528ffcf38697b92c1498dd97dcd4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c1029a7b0e899142c71cf67e4cfe19a6ec6cd45acb8642ae9c06008f26ef2fe9"
    sha256 cellar: :any_skip_relocation, sonoma:        "b25c87bc5e8adc2db5db216aca0a9353e4cd3848ee8ed7d63a8f6453ab08fc55"
    sha256 cellar: :any_skip_relocation, ventura:       "624e8c2224b967ad18a09582c445026b711bb4da817c53b7020047eb76aa0940"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddbb2010619b4a3c3d777322f808cc0e6c3596f754cc7c542d33083982d63cc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "527b513d41860faff19afdbac1b5f42cd3d890253eb83dd3bee64ce71c670fa8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/karmada-io/karmada/pkg/version.gitVersion=#{version}
      -X github.com/karmada-io/karmada/pkg/version.gitCommit=
      -X github.com/karmada-io/karmada/pkg/version.gitTreeState=clean
      -X github.com/karmada-io/karmada/pkg/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/karmadactl"

    generate_completions_from_executable(bin/"karmadactl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("#{bin}/karmadactl init 2>&1", 1)
    assert_match "Missing or incomplete configuration info", output

    output = shell_output("#{bin}/karmadactl token list 2>&1", 1)
    assert_match "failed to list bootstrap tokens", output

    assert_match version.to_s, shell_output("#{bin}/karmadactl version")
  end
end
