class Tfupdate < Formula
  desc "Update version constraints in your Terraform configurations"
  homepage "https://github.com/minamijoyo/tfupdate"
  url "https://github.com/minamijoyo/tfupdate/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "0d9820f93f9f80c17e01da8bd3f4256642e93c86a1356b5d4418cb93797ec95d"
  license "MIT"
  head "https://github.com/minamijoyo/tfupdate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "758383e3b5dc2d5986f94bfd918454622c952950d1bf80bdba7d389dbf854859"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "758383e3b5dc2d5986f94bfd918454622c952950d1bf80bdba7d389dbf854859"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "758383e3b5dc2d5986f94bfd918454622c952950d1bf80bdba7d389dbf854859"
    sha256 cellar: :any_skip_relocation, sonoma:        "a97263cf53d5059a724cb3825ef2ef9a7b497aab9d90828786500911aa786f6f"
    sha256 cellar: :any_skip_relocation, ventura:       "a97263cf53d5059a724cb3825ef2ef9a7b497aab9d90828786500911aa786f6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9a59de4820aed2f0c7b73a3674446d027c1f1e28ca6fea036ca7670f5023713"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"provider.tf").write <<~HCL
      provider "aws" {
        version = "2.39.0"
      }
    HCL

    system bin/"tfupdate", "provider", "aws", "-v", "2.40.0", testpath/"provider.tf"
    assert_match "2.40.0", File.read(testpath/"provider.tf")

    assert_match version.to_s, shell_output(bin/"tfupdate --version")
  end
end
