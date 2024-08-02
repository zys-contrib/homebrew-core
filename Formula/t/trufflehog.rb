class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.80.6.tar.gz"
  sha256 "8f63d7462e16f80e6ac80bc5a47bf3c2bcd7d759eec930db6e90f632c485ac0a"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "179246ffb0c24b6f35d209944ed6f32b0fa244be0e9fc57c88e90a28475ba815"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "436133e5f7ad01884759e30c94d89a1b6bcae1cc586b561d9e98be3ca987966f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2bd59a4af5daf18681cc5323a3f05146d66452029377ff1da4de6b87a13d55f"
    sha256 cellar: :any_skip_relocation, sonoma:         "07a5c9beda5c683983abb34dfb31b2a17507522f8adc0500ff44c98be570eb05"
    sha256 cellar: :any_skip_relocation, ventura:        "6b9ced7ce04f592595c930a270f090cc7ea4aeddc14945f5b31ea3bb90cee626"
    sha256 cellar: :any_skip_relocation, monterey:       "2d537c1a1195f342f924e96740160db415a9d591f49d61c4f6285f7d3fc7a07e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59a0b4273de5bb68230b7056c80db3a465f6832eb29c51f05f06a0918f2cc938"
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
