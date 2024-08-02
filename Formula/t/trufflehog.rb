class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.81.4.tar.gz"
  sha256 "c4ac853e5fde26f2599871a0ff3f00e6eb411e438289bc5786d8b832df2d3215"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b58d0934c11a427da8a653de8a777cf3358da1205511b30ef1a819b456410f7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11ac21db1150c29aabcc4e5bcc134d7e40b549685aa599e646c9c72f4c7f51f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a988bd3f32ae80434ce70b7dc6d8fbfab6ca5540cc5b338093eb30b3703ad9c"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a75e4ab5ae638be05ede9ab5a85e53d2617721727aa84ea8a6973aada86cf36"
    sha256 cellar: :any_skip_relocation, ventura:        "baca63b4adbf8212bd39c32f8186677ff15a44cab0720038eade60c1a9725d0c"
    sha256 cellar: :any_skip_relocation, monterey:       "1c0b34a677b69e8b2aad7100e50ade40bbdc7252a78fd8b1dc96747f5f9fb785"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a90cd2a3d1a3dd791b943224fdcab13ebfe024e20f0f22bd70abcb05c6205693"
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
