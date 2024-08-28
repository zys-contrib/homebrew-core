class Terramaid < Formula
  desc "Utility for generating Mermaid diagrams from Terraform configurations"
  homepage "https://github.com/RoseSecurity/Terramaid"
  url "https://github.com/RoseSecurity/Terramaid/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "992563cd53d7ce64db3734a839a3291f6e1950458ab72a13eb382c8f3c403afc"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/Terramaid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b2376ca6b6ba58f770a9fce956e066d160ae7a7b2793b95b9ef87891196d70c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2376ca6b6ba58f770a9fce956e066d160ae7a7b2793b95b9ef87891196d70c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2376ca6b6ba58f770a9fce956e066d160ae7a7b2793b95b9ef87891196d70c5"
    sha256 cellar: :any_skip_relocation, sonoma:         "a861d1f3346e737e918d786f9bfc4f8d4b11b8a5ec030ab3182fcebec82e7a67"
    sha256 cellar: :any_skip_relocation, ventura:        "a861d1f3346e737e918d786f9bfc4f8d4b11b8a5ec030ab3182fcebec82e7a67"
    sha256 cellar: :any_skip_relocation, monterey:       "a861d1f3346e737e918d786f9bfc4f8d4b11b8a5ec030ab3182fcebec82e7a67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a62924e3092ff9521c1219531f92732664d6e187666e3491738e8d94a0f2c60"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"terramaid", "completion")
  end

  test do
    resource "terraform" do
      # https://www.hashicorp.com/blog/hashicorp-adopts-business-source-license
      # Do not update terraform, it switched to the BUSL license
      # Waiting for https://github.com/runatlantis/atlantis/issues/3741
      url "https://github.com/hashicorp/terraform/archive/refs/tags/v1.5.7.tar.gz"
      sha256 "6742fc87cba5e064455393cda12f0e0241c85a7cb2a3558d13289380bb5f26f5"
    end

    resource("terraform").stage do
      system "go", "build", *std_go_args(ldflags: "-s -w", output: testpath/"terraform")
    end

    ENV.prepend_path "PATH", testpath

    (testpath/"main.tf").write <<~EOS
      resource "aws_instance" "example" {
        ami           = "ami-0c55b159cbfafe1f0"
        instance_type = "t2.micro"
      }
    EOS

    system bin/"terramaid", "-d", testpath.to_s, "-o", testpath/"output.mmd"
    assert_predicate testpath/"output.mmd", :exist?

    assert_match version.to_s, shell_output("#{bin}/terramaid version")
  end
end
