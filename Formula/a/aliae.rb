class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  url "https://github.com/jandedobbeleer/aliae/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "2d0fd5e1128edab3d7b5cacadd884393d0e38281274b74e493e18d5144672ea8"
  license "MIT"
  head "https://github.com/jandedobbeleer/aliae.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fd97c2d95bb912fab6cc6fbbaf54f51ebb88e748c41809de127b8e36446d552"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78c1706ff262a696312f03e8beaedaf5aa66c926fa322f51b113bff074894c86"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e54c7d59d1e0c878b216d85423d03fe9cb46e2716fa6c808e4e02d027b32eaa9"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6ffc935c6acd6960a7075f4b24d7380869e2dc8a64048f74a2f9c636376c5d6"
    sha256 cellar: :any_skip_relocation, ventura:       "10ce70fdc6cf7d9d843e14d76a71ed2f6ee0b1f2e9f48152cb6e2bdd5beaf9e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "731276b545e6ae08c184ca06319d10e2b94ad45ac50c6d043f9294b50fbb0189"
  end

  depends_on "go" => :build

  def install
    cd "src" do
      ldflags = "-s -w -X main.Version=#{version}"
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"aliae", "completion")
  end

  test do
    (testpath/".aliae.yaml").write <<~YAML
      alias:
        - name: a
          value: aliae
        - name: hello-world
          value: echo "hello world"
          type: function
    YAML

    output = shell_output("#{bin}/aliae init bash")
    assert_equal <<~SHELL.chomp, output
      alias a="aliae"
      hello-world() {
          echo "hello world"
      }
    SHELL

    assert_match version.to_s, shell_output("#{bin}/aliae --version")
  end
end
