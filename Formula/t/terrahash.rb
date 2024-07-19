class Terrahash < Formula
  desc "Create and store a hash of the Terraform modules used by your configuration"
  homepage "https://github.com/ned1313/terrahash"
  url "https://github.com/ned1313/terrahash/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "3f6d3db33167a77290741ca24ac32cb82f18400969cde4e501c84d250801758f"
  license "MIT"
  head "https://github.com/ned1313/terrahash.git", branch: "main"

  depends_on "go" => :build
  depends_on "opentofu" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"terrahash", "completion")
  end

  test do
    (testpath/"main.tf").write <<~EOS
      module "example" {
        source = "terraform-aws-modules/ec2-instance/aws"
        version = "~> 5"

        ami           = "ami-0c55b159cbfafe1f0"
        instance_type = "t2.micro"
        name          = "example"
      }
    EOS

    system "tofu", "init"
    assert_predicate testpath/".terraform.lock.hcl", :exist?

    output = shell_output("#{bin}/terrahash init -s #{testpath}")
    assert_match "Summary: 1 modules added to mod lock file", output
    assert_predicate testpath/".terraform.module.lock.hcl", :exist?

    assert_match version.to_s, shell_output("#{bin}/terrahash version")
  end
end
