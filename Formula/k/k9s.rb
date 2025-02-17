class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.40.2",
      revision: "1044f2260e808cb820499b4d7bda8f1def84ea72"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82d2a29ec2b4cfd18489901696c4bbf56e817ed4a1a55afba7c2edad6429616f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b8cc70a8d37d92f29e864e9b9eaabfff38eb42367bfd2feae38bda5a50bc878"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ebbb80d09d48d72ef087fca13df763ebae5272081aae0cbfb5f9d93b6f635fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa35fbb06c523b5535c0372e6deac51fada84284776c8aeb99f8bf94edfdfc01"
    sha256 cellar: :any_skip_relocation, ventura:       "6c48e780bbe7652a832e2199defaa24dd3bfd9134592ceb9b1a22b27da5ccf22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a80582edc00b08a01dce6805c7ab44997ef96e7fafcb2198947f7aa5f067be38"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/k9s/cmd.version=#{version}
      -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"k9s", "completion")
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
