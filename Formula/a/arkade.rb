class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.11.37.tar.gz"
  sha256 "a2b740256bb771f87b05727aac4790460eca444110f69a99b0ce813c4ed70989"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac3b189b0fd3d2cad76345add117412d7f043c6f822155a339f62be8dc85d0a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac3b189b0fd3d2cad76345add117412d7f043c6f822155a339f62be8dc85d0a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ac3b189b0fd3d2cad76345add117412d7f043c6f822155a339f62be8dc85d0a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "53b877bd8dac153548e1ca8fe3dc2b3d02fbb2a277612184baec9d9cd47fc744"
    sha256 cellar: :any_skip_relocation, ventura:       "53b877bd8dac153548e1ca8fe3dc2b3d02fbb2a277612184baec9d9cd47fc744"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "171720fa36dfe18cc7865dabede7b52ac7e6bead56c48afedbb73a284f134eeb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/pkg.Version=#{version}
      -X github.com/alexellis/arkade/pkg.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    bin.install_symlink "arkade" => "ark"

    generate_completions_from_executable(bin/"arkade", "completion")
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output(bin/"arkade version")
    assert_match "Info for app: openfaas", shell_output(bin/"arkade info openfaas")
  end
end
