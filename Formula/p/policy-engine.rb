class PolicyEngine < Formula
  desc "Unified Policy Engine"
  homepage "https://github.com/snyk/policy-engine"
  url "https://github.com/snyk/policy-engine/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "cc61ac06f363a67619054fe50c23e3f426c7cef3126d5fe797263f75643147ba"
  license "Apache-2.0"
  head "https://github.com/snyk/policy-engine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "004a49eb32e9601864fa2abe9c9b24b583d33b6d312a48410a4700bf8e0f879f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "004a49eb32e9601864fa2abe9c9b24b583d33b6d312a48410a4700bf8e0f879f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "004a49eb32e9601864fa2abe9c9b24b583d33b6d312a48410a4700bf8e0f879f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d25b892684455ac1aac97f56b0eb41bf1086dc61aa9c840c3a0ce3bc6192fef6"
    sha256 cellar: :any_skip_relocation, ventura:       "d25b892684455ac1aac97f56b0eb41bf1086dc61aa9c840c3a0ce3bc6192fef6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f117fbb9c6c7a90dd188f198efebbd9f03b2e0e00a11d01a9eab3ddea703d29a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/snyk/policy-engine/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"policy-engine", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/policy-engine version")

    (testpath/"infra/test.tf").write <<~HCL
      resource "aws_s3_bucket" "foo-bucket" {
        region        = "us-east-1"
        bucket        = "test"
        acl           = "public-read"
        force_destroy = true

        versioning {
          enabled = true
        }
      }
    HCL

    assert_match "\"rule_results\": []", shell_output(bin/"policy-engine run infra")
  end
end
