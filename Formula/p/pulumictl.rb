class Pulumictl < Formula
  desc "Swiss army knife for Pulumi development"
  homepage "https://github.com/pulumi/pulumictl"
  url "https://github.com/pulumi/pulumictl/archive/refs/tags/v0.0.49.tar.gz"
  sha256 "36af696d99adfa8ca5941780ad12f13116178f252fe47e24a70be0a2f771b0d0"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumictl.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/pulumi/pulumictl/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pulumictl"

    generate_completions_from_executable(bin/"pulumictl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pulumictl version")

    output = shell_output("#{bin}/pulumictl convert-version --language generic --version v1.2.3")
    assert_equal "1.2.3", output.strip

    output = shell_output("#{bin}/pulumictl create homebrew-bump v1.0.0 test-repo --org test-org 2>&1", 1)
    assert_match "Error: unable to create dispatch event", output.strip
  end
end
