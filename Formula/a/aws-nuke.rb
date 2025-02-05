class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.47.0.tar.gz"
  sha256 "e4011e837872528aece36559981ee7e661f335b304b802150f8ef4b6c4331fee"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9b7c9e440cf0b544a08a0c5d486c0f2217fd6ec73a6166ec899d8b609a3c029"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9b7c9e440cf0b544a08a0c5d486c0f2217fd6ec73a6166ec899d8b609a3c029"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9b7c9e440cf0b544a08a0c5d486c0f2217fd6ec73a6166ec899d8b609a3c029"
    sha256 cellar: :any_skip_relocation, sonoma:        "a650e037cafa3f0c830c36545696d7713fe79c6e1edd3b1dfdd33fd9b139964b"
    sha256 cellar: :any_skip_relocation, ventura:       "a650e037cafa3f0c830c36545696d7713fe79c6e1edd3b1dfdd33fd9b139964b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a95caf4b48b696bcfe80426537c15e8ffce75f59fa55270c9dc4ef2c3f21ed29"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/ekristen/aws-nuke/v#{version.major}/pkg/common.SUMMARY=#{version}
    ]
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags:)

    pkgshare.install "pkg/config"

    generate_completions_from_executable(bin/"aws-nuke", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aws-nuke --version")
    assert_match "InvalidClientTokenId", shell_output(
      "#{bin}/aws-nuke run --config #{pkgshare}/config/testdata/example.yaml \
      --access-key-id fake --secret-access-key fake 2>&1",
      1,
    )
    assert_match "IAMUser", shell_output("#{bin}/aws-nuke resource-types")
  end
end
