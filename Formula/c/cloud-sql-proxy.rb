class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.14.1.tar.gz"
  sha256 "656e6cc8dc72ae2844e4ab3fa2e210c91a245133f1c42a8d94b10473fca1350d"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d595a8116bd7d4e23ced223d6c855cc63ebbfd7919e137852ef2bb17d04a208"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d595a8116bd7d4e23ced223d6c855cc63ebbfd7919e137852ef2bb17d04a208"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d595a8116bd7d4e23ced223d6c855cc63ebbfd7919e137852ef2bb17d04a208"
    sha256 cellar: :any_skip_relocation, sonoma:        "c02ec89449183e593641cc31905051c32111920fabdcca3585a13e2406956a44"
    sha256 cellar: :any_skip_relocation, ventura:       "c02ec89449183e593641cc31905051c32111920fabdcca3585a13e2406956a44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2dad6d3f3e52104da80f5395a8621fdd2435641f975c2efece2c27ccc419f9b9"
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
