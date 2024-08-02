class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.81.3.tar.gz"
  sha256 "dfd9ccc2ee56301acc75c329cbe3850de44dfe57d47bce8dc9eb816730ea2e75"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c1487ae5672cc994f2ede08b4b08f9cf50f13052e0e2a67a6fa2cbf4c5deba0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06f1238d57f87fd8ec6251431e5b291f2166f6ee8718eb7e405fe77cfa2c1062"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8979850c8367a4098777e8a82edc64cb65c24727452d96e49e346b9320d18ef3"
    sha256 cellar: :any_skip_relocation, sonoma:         "e49c7fca0f75e9ab3ecf8b14f2e4fd362585e6095f8ee5e96167f9a7ccccf4df"
    sha256 cellar: :any_skip_relocation, ventura:        "be850e80acbb4508e39625c420e68defafcf79e984694fc465a25b906615a083"
    sha256 cellar: :any_skip_relocation, monterey:       "db3e6df6d0c7c9f95d4a5dabacdbb62965968150e4821e0eb555d44f6d908681"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2746575f414189be2debcadd9755e9a6a3edfd8a05df92dbbf6ceddbd305fa7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    repo = "https://github.com/trufflesecurity/test_keys"
    output = shell_output("#{bin}/trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/trufflehog --version 2>&1")
  end
end
