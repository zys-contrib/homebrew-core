class Draft < Formula
  desc "Day 0 tool for getting your app on Kubernetes fast"
  homepage "https://github.com/Azure/draft"
  url "https://github.com/Azure/draft/archive/refs/tags/v0.17.3.tar.gz"
  sha256 "8d108f2bf9116f7a8e41315976cfb9b775985084dea3a4e14df08731ea0ecd3e"
  license "MIT"
  head "https://github.com/Azure/draft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24dc1fa99e075f489f0228efe549d2e3b4d4a928d48dbfe1f51122ac649adebc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23856af4b189db3110234f032fa0de66ec3c64d67c0f58b8c23729c41b81021c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf2ec1ad645034eb99c489d99dec17be31dc07550d4451805828bf6106bc7fde"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd449809bca7982c26b3f200db141bdd51bbfd6f2161dc01c84483d8adcd97d4"
    sha256 cellar: :any_skip_relocation, ventura:       "821da65b5bd8cfa9e09c9ab9b9b8dc171b2f711eb18844798133c0a6c875eb6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "619fd55ee776ebf4c76b1f9bda0f144040786ec34fb4815cb712c9a38bf2bec3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/Azure/draft/cmd.VERSION=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"draft", "completion")
  end

  test do
    supported_deployment_types = JSON.parse(shell_output("#{bin}/draft info"))["supportedDeploymentTypes"]
    assert_equal ["helm", "kustomize", "manifests"], supported_deployment_types

    assert_match version.to_s, shell_output("#{bin}/draft version")
  end
end
