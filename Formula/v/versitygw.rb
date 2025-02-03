class Versitygw < Formula
  desc "Versity S3 Gateway"
  homepage "https://www.versity.com/products/versitygw/"
  url "https://github.com/versity/versitygw/archive/refs/tags/v1.0.10.tar.gz"
  sha256 "c488d6adbb40d3bcb40400fa95c8069d6720ea4fb6db590af0598fc1baa98bd5"
  license "Apache-2.0"
  head "https://github.com/versity/versitygw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "353d313b16f0fb040ddf93979b662387aef0c24346d08bd15fbc3416bdfc548e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "353d313b16f0fb040ddf93979b662387aef0c24346d08bd15fbc3416bdfc548e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "353d313b16f0fb040ddf93979b662387aef0c24346d08bd15fbc3416bdfc548e"
    sha256 cellar: :any_skip_relocation, sonoma:        "2aa57085901aeb5ed36f65a9f46d72ded2dba280ebf669350cc305bb92be2b18"
    sha256 cellar: :any_skip_relocation, ventura:       "2aa57085901aeb5ed36f65a9f46d72ded2dba280ebf669350cc305bb92be2b18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f34d70568f52eca7a89f7c01b7a2abce00cce5aed542bdfa4354625b4b420232"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.BuildTime=#{time.iso8601} -X main.Build=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/versitygw"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/versitygw --version")

    system bin/"versitygw", "utils", "gen-event-filter-config"
    assert_equal true, JSON.parse((testpath/"event_config.json").read)["s3:ObjectAcl:Put"]

    output = shell_output("#{bin}/versitygw admin list-buckets 2>&1", 1)
    assert_match "Required flags \"access, secret, endpoint-url\"", output
  end
end
