class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.82.1.tar.gz"
  sha256 "4cd3b47391ce295a1befd8a6d1faf9f8f72e5c399dff73745896a0ffe3c6f666"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d51b7f56a578dc983dfcfa5e986542defb663a83272dab816b364075d314c1d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f5141ec94e4a5e3b54394722c47f98b805335d0a8e2e4ec67506ebc86b0caaa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89495e396a12e6a001adbcde0b6d8aec8edaabdf486046cf4ac738cffa953a42"
    sha256 cellar: :any_skip_relocation, sonoma:         "358a144864b5a9663d554670c4643c99cb82f0f8f6ef2f40343b1be7c1e129ad"
    sha256 cellar: :any_skip_relocation, ventura:        "269088879b725bce3e1513828c360ba28ea694c663c3d43b114ae2159592d5e7"
    sha256 cellar: :any_skip_relocation, monterey:       "2fe43b94c856beb1bb3a86d1a4a962a98788f241dddc00b9da276b146b7eabdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d879bdbb5a3334c2a26e129880c77ce6d939724d4f851b1f91fa479cb98fa0a"
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
