class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "266088bd1962350593478f4f09ad0dcb8825d1e2c0c3b4ef59600f8f3da883e6"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e5cdf4e59424dcbd24ff6fbbb5b20bb5f27971b85dc5fb8cd4ea8a8f6225c33c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c60d959bac9f63bec392204d59c2b7d4cb329d85448b82b493f0ccd4176b773e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd2955b4d69814fddaebcceae8de38f8985f10120fda30d144baba9edc65f03e"
    sha256 cellar: :any_skip_relocation, sonoma:         "15f34413fb1c27809129dd3ca50c5e397bdb4a487b5aec9aebde3bbe10a59131"
    sha256 cellar: :any_skip_relocation, ventura:        "037b53bfd98247433abb6e6b2f15aee46cefb34b4352b21c24af0257339c1476"
    sha256 cellar: :any_skip_relocation, monterey:       "3e396c796f32792f1e1efc06d096ad601e1c3a6c90c488bbd3cd2a5c1aca0558"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91b26cdb57683874f286415ec84208aa77defb210a339df53d840f544e7b4d56"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/rancher/fleet/pkg/version.Version=#{version}
      -X github.com/rancher/fleet/pkg/version.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(output: bin/"fleet", ldflags:), "./cmd/fleetcli"

    generate_completions_from_executable(bin/"fleet", "completion", base_name: "fleet")
  end

  test do
    system "git", "clone", "https://github.com/rancher/fleet-examples"
    assert_match "kind: Deployment", shell_output("#{bin}/fleet test fleet-examples/simple 2>&1")

    assert_match version.to_s, shell_output("#{bin}/fleet --version")
  end
end
