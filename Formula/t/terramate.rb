class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/"
  url "https://github.com/terramate-io/terramate/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "fb9dfeb7395e10e2000ed67ab9a6e40edea6d31efcc9f5a84a95f274cb9ec8b9"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cc4c757f704dc260a7bec44a987a65143f6e159fc3fafb0f7419022d0573fe8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cc4c757f704dc260a7bec44a987a65143f6e159fc3fafb0f7419022d0573fe8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5cc4c757f704dc260a7bec44a987a65143f6e159fc3fafb0f7419022d0573fe8"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd422f5df9630dbbde49ff9402d8ccecaa2767e6d68321220ef512716788880b"
    sha256 cellar: :any_skip_relocation, ventura:       "bd422f5df9630dbbde49ff9402d8ccecaa2767e6d68321220ef512716788880b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6e19cf7d47804f39c3f369ccd80cc925ff7c83929ae7a069e8035bff1bc84ca"
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
