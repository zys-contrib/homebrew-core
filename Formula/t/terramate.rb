class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/cli/"
  url "https://github.com/terramate-io/terramate/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "9ab292bc71930587bcbca990d2dbba11f82aa57531f03e38dd6544c8fc1c469c"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c7694517d7ebf544f5b54ff932a9c619ae018e3c3513ef250e5501bd63391a5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7694517d7ebf544f5b54ff932a9c619ae018e3c3513ef250e5501bd63391a5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7694517d7ebf544f5b54ff932a9c619ae018e3c3513ef250e5501bd63391a5f"
    sha256 cellar: :any_skip_relocation, sonoma:         "9eeaf1421b0665e99496381f5d0622f837cb67e2419c60edec77ce1516814116"
    sha256 cellar: :any_skip_relocation, ventura:        "9eeaf1421b0665e99496381f5d0622f837cb67e2419c60edec77ce1516814116"
    sha256 cellar: :any_skip_relocation, monterey:       "9eeaf1421b0665e99496381f5d0622f837cb67e2419c60edec77ce1516814116"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2da08d868342ef3cd2582d9a737cca60ebb851bfcdead4ed37334ed5f39f82c3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"terramate", ldflags: "-s -w"), "./cmd/terramate"
    system "go", "build", *std_go_args(output: bin/"terramate-ls", ldflags: "-s -w"), "./cmd/terramate-ls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terramate version")
    assert_match version.to_s, shell_output("#{bin}/terramate-ls -version")
  end
end
