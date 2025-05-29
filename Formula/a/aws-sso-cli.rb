class AwsSsoCli < Formula
  desc "Securely manage AWS API credentials using AWS SSO"
  homepage "https://synfinatic.github.io/aws-sso-cli/"
  url "https://github.com/synfinatic/aws-sso-cli/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "7ebb5d64260ac43d9f70c5f9ef2d04567006df4458dd94a27cb53178956c2eb3"
  license "GPL-3.0-only"
  head "https://github.com/synfinatic/aws-sso-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d84aa90210bc1712eb33df6be5335dd748e81c48887ee814139e288f40fc4e44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffc8dd19cd8d47d7c182bec2742adb3ac198cec893f1c3505ca2cfe00ce2be28"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4c36bf6d1f5183781a0a047754d12102df571360a4637d2840bd4c0430f0181f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce9add7007ad99ea442ce585670ce6c8ab878e3575e22f2eb109036ce20a4db1"
    sha256 cellar: :any_skip_relocation, ventura:       "02914f36beb7ecd63673b728238dfc8e0d9d289dbfb8563c823fd18deb16daa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc5d40322436e42b7123d8d858ad11d1ec1d5086e0120183db1aad9fb681c574"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Buildinfos=#{time.iso8601}
      -X main.Tag=#{version}
      -X main.CommitID=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"aws-sso"), "./cmd/aws-sso"
  end

  test do
    assert_match "AWS SSO CLI Version #{version}", shell_output("#{bin}/aws-sso version")
    assert_match "no AWS SSO providers have been configured",
        shell_output("#{bin}/aws-sso --config /dev/null 2>&1", 1)
  end
end
