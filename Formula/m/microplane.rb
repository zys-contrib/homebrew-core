class Microplane < Formula
  desc "CLI tool to make git changes across many repos"
  homepage "https://github.com/Clever/microplane"
  url "https://github.com/Clever/microplane/archive/refs/tags/v0.0.36.tar.gz"
  sha256 "efa78a7b3b385124e73e230d71667a6af45cd294cd901ea25d47031a97c7498c"
  license "Apache-2.0"
  head "https://github.com/Clever/microplane.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8725ec0214b5f37d9bd5ab7ef3025df23b281b22b34c15d6dc65276752e0ca86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8725ec0214b5f37d9bd5ab7ef3025df23b281b22b34c15d6dc65276752e0ca86"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8725ec0214b5f37d9bd5ab7ef3025df23b281b22b34c15d6dc65276752e0ca86"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecca91e14f27f6c65b4dbde35187fd369c309b23d5898e6e7121daac41fc6ea0"
    sha256 cellar: :any_skip_relocation, ventura:       "ecca91e14f27f6c65b4dbde35187fd369c309b23d5898e6e7121daac41fc6ea0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42b83dffc0c0573172f2217ac257cf0ea2f2df2d763570d1b26652868b53ec96"
  end

  depends_on "go" => :build

  # bump to go 1.23, upstream pr ref, https://github.com/Clever/microplane/pull/295
  patch do
    url "https://github.com/Clever/microplane/commit/3e2f1371e56af6d65fc62af5c306a7d6485321ad.patch?full_index=1"
    sha256 "6ba123167defb192f0f97d6dc918be9a557014f8a0367f6be663232b930e3dd5"
  end

  def install
    system "go", "build", *std_go_args(output: bin/"mp", ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"mp", "completion")
  end

  test do
    # mandatory env variable
    ENV["GITHUB_API_TOKEN"] = "test"
    # create repos.txt
    (testpath/"repos.txt").write <<~EOF
      hashicorp/terraform
    EOF
    # create mp/init.json
    system bin/"mp", "init", "-f", testpath/"repos.txt"
    # test command
    output = shell_output("#{bin}/mp plan -b microplaning -m 'microplane fun' -r terraform -- sh echo 'hi' 2>&1")
    assert_match "planning", output
  end
end
