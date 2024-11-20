class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/cli/"
  url "https://github.com/terramate-io/terramate/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "1a59e9f9a1335f4a9bc8e7c8e0d06d73fbca63ce4d2dfa5a48397d9c0862b818"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af39c51f04d3068234f1cfab87da50b07ed8052ffe259d32c52b2acd1f6029b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af39c51f04d3068234f1cfab87da50b07ed8052ffe259d32c52b2acd1f6029b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af39c51f04d3068234f1cfab87da50b07ed8052ffe259d32c52b2acd1f6029b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ccde4a188d325a379a51063eae2c1dd7ae71016925dc88c497dca4611738dceb"
    sha256 cellar: :any_skip_relocation, ventura:       "ccde4a188d325a379a51063eae2c1dd7ae71016925dc88c497dca4611738dceb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c02e08171c60c80d04712b4b469e5726fa97696930392ce97e40c0711bf4680"
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
