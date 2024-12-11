class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.14.2.tar.gz"
  sha256 "9700156c7fcfd9a8fa5730bf10277fbeb3b63a61b2595c03054a58f85c2b81ef"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d434ffd248c11e77ef2bcd20bc6b4111a1b620400de178129ff7336546928451"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d434ffd248c11e77ef2bcd20bc6b4111a1b620400de178129ff7336546928451"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d434ffd248c11e77ef2bcd20bc6b4111a1b620400de178129ff7336546928451"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f538ba8a6d7d5998b5472bd667c6c96b20e05718648348367054494894092e6"
    sha256 cellar: :any_skip_relocation, ventura:       "7f538ba8a6d7d5998b5472bd667c6c96b20e05718648348367054494894092e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2b3f0ebd99dae4fe80bc712e83d0ece86ca35f2cf23ebf6b7fc509db683cfb2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "cloud-sql-proxy version #{version}", shell_output("#{bin}/cloud-sql-proxy --version")
    assert_match "could not find default credentials", shell_output("#{bin}/cloud-sql-proxy test 2>&1", 1)
  end
end
