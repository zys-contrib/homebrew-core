class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.82.4.tar.gz"
  sha256 "26ce516a30518f1997a4e259a2bae6f0825ec5a81971d6f31439ccf919e41519"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "389b0ba2e0c14d05c0453465cc9fdc12cd620fda8316c29ff0ef7b1419bc9c1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90e79ac5270a6064f4a9d0bf5b4bdd616815c838b4f84634eadbaa0632e58967"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d8f8d01b9d62b66c14ab9d159f3390ed8166d97e871bc7fea6f189f31509fc9"
    sha256 cellar: :any_skip_relocation, sonoma:        "481650037801b71395591ec71d311d923e128446a34d3288175198d24df66300"
    sha256 cellar: :any_skip_relocation, ventura:       "82c42cd83607faeef2821b08701ae9b4ad5257c532267cea88f38a33a553281a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9f9652b8568b6bfd4075257ce05c2f93ccbcb2661060665c1627077a1de1496"
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
