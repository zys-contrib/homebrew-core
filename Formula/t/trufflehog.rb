class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.88.21.tar.gz"
  sha256 "f8b9b6a7859a44bc28ae6bae9933b49a4884c9ba57aab32183c2c28e720a9fc2"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68b27626947795077e8e693b57bbcdfede48c271cd23110318f5e808b60cfa04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3935215504f4e21a10fb23e98f469bbc8907b23f24e13010a55cc8f044475f52"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b297330d5dee91a5333243b3f2640dfd7173e3e29da9a5d20c7eb685c4155f96"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed1bd52f25f40921d286be28300a9a8ea989786157741a2fdad303443c2cad19"
    sha256 cellar: :any_skip_relocation, ventura:       "7139021bf3f5e5b81c57ab526802e53bd8c4f32ef12a71d1f74c02ddfb76b6d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f3946ad53fa1ba5bf599d56575aad8d747647394664c56512b114ee0983f1ca"
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
