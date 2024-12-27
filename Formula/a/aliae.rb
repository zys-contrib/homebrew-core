class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  url "https://github.com/jandedobbeleer/aliae/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "8036ac29dcd7aa4c259bd69b0554d3d3de1b08db25943f0999b698c5ad3dc19f"
  license "MIT"
  head "https://github.com/jandedobbeleer/aliae.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b155186fe06fd48c4aa5f45355c264b2807807029cc5ab7d5373c0fd86e48f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9678c5490c1c64114610a6faf309fffe6d618e6eb48eca1c1692ef8c9a09f161"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "453a7a1d5311f722c46cf999b10c8c01e191baa3882439bd880a66a8a041a982"
    sha256 cellar: :any_skip_relocation, sonoma:        "be1e953c87486f51a7fc6012adfeeeb7b2aaa71ed9c9abbd5df92882cce6cdf3"
    sha256 cellar: :any_skip_relocation, ventura:       "dbf4ccd3e0c9dbd19fb034e65b043d13f4e7d85bb4f04077fe8b593a8bbaeb60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c929539a4a379c6c999d23763ade436f2bd23d22bf37da3822ad2cb157c4e85"
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
