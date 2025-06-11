class Ldcli < Formula
  desc "CLI for managing LaunchDarkly feature flags"
  homepage "https://launchdarkly.com/docs/home/getting-started/ldcli"
  url "https://github.com/launchdarkly/ldcli/archive/refs/tags/v1.15.3.tar.gz"
  sha256 "0739727df8569c3be837def35a9ff02904e0b24591aabbc4f62a24f5c4993d27"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ldcli.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"ldcli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ldcli --version")

    assert_match "Invalid account ID header",
      shell_output("#{bin}/ldcli flags list --access-token=Homebrew --project=Homebrew 2>&1")
  end
end
