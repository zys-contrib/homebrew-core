class Squealer < Formula
  desc "Scans Git repositories or filesystems for secrets in commit histories"
  homepage "https://github.com/owenrumney/squealer"
  url "https://github.com/owenrumney/squealer/archive/refs/tags/v1.2.6.tar.gz"
  sha256 "7b13a6d5d52d2cf54c13b0f25d48b8c5712e5a0d2e9cda7122ecd685f565c76e"
  license "Unlicense"
  head "https://github.com/owenrumney/squealer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78883c46b7982ffb270f3a21c7eab367905bfca53fa5ab785e35df45e298be05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78883c46b7982ffb270f3a21c7eab367905bfca53fa5ab785e35df45e298be05"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78883c46b7982ffb270f3a21c7eab367905bfca53fa5ab785e35df45e298be05"
    sha256 cellar: :any_skip_relocation, sonoma:        "37d9029eb70e4b53a38bff7b01047ec81fa750537202778c90f01c78fb9ea2b8"
    sha256 cellar: :any_skip_relocation, ventura:       "37d9029eb70e4b53a38bff7b01047ec81fa750537202778c90f01c78fb9ea2b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "373cfbf3541dd3dcfd74ed82aae47a99815eb41424225935152133aee356fa7a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/owenrumney/squealer/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/squealer"
  end

  test do
    system "git", "clone", "https://github.com/owenrumney/woopsie.git"
    output = shell_output("#{bin}/squealer woopsie", 1)
    assert_match "-----BEGIN OPENSSH PRIVATE KEY-----", output
  end
end
