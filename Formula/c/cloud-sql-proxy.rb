class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.14.3.tar.gz"
  sha256 "367540bf7d4c57d788af4c73d96fbee158d954fae30d7f1ec5a28c321341a2e2"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62bbb45443ba44d27c2f6e605c09b9c8696d8f1d16d0d88bfb13917af6fee216"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62bbb45443ba44d27c2f6e605c09b9c8696d8f1d16d0d88bfb13917af6fee216"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62bbb45443ba44d27c2f6e605c09b9c8696d8f1d16d0d88bfb13917af6fee216"
    sha256 cellar: :any_skip_relocation, sonoma:        "9576bb74a69597cd5978d2873a2aa9ef565f46285ea53df206ded79c300edeb4"
    sha256 cellar: :any_skip_relocation, ventura:       "9576bb74a69597cd5978d2873a2aa9ef565f46285ea53df206ded79c300edeb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed04244f4fe31273177f6ced1278c20cf3a8daac7869662eebea4dcc21bd166f"
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
