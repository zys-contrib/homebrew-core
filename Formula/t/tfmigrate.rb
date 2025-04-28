class Tfmigrate < Formula
  desc "Terraform/OpenTofu state migration tool for GitOps"
  homepage "https://github.com/minamijoyo/tfmigrate"
  url "https://github.com/minamijoyo/tfmigrate/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "6ca61f363e8eb07f6d68df961e16647c7d98105aee2f7cbfdc1a9b741cb2e9e6"
  license "MIT"
  head "https://github.com/minamijoyo/tfmigrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b96b0802ec46007d13a728026cb0be4ddd2b85464bf3e4c3d916fa0d722d5fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b96b0802ec46007d13a728026cb0be4ddd2b85464bf3e4c3d916fa0d722d5fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b96b0802ec46007d13a728026cb0be4ddd2b85464bf3e4c3d916fa0d722d5fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "10e26bd3919e891455ae96e822fc7b1118f1d828ba58dccf1e55fd5d291e0609"
    sha256 cellar: :any_skip_relocation, ventura:       "10e26bd3919e891455ae96e822fc7b1118f1d828ba58dccf1e55fd5d291e0609"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b599a38eee3afc7f6aaf23dc67978ad9d9a30fed64b712440b7f7845ae9bd7fb"
  end

  depends_on "go" => :build
  depends_on "opentofu" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["TFMIGRATE_EXEC_PATH"] = "tofu"

    (testpath/"tfmigrate.hcl").write <<~HCL
      migration "state" "brew" {
        actions = [
          "mv aws_security_group.foo aws_security_group.baz",
        ]
      }
    HCL
    output = shell_output(bin/"tfmigrate plan tfmigrate.hcl 2>&1", 1)
    assert_match "[migrator@.] compute a new state", output
    assert_match "No state file was found!", output

    assert_match version.to_s, shell_output(bin/"tfmigrate --version")
  end
end
