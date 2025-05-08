class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.19.1.tar.gz"
  sha256 "cc73e7b37e619d99417e54f7a498d2ad17b31601e6a1027b43fec9fe13ea2286"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60783957e43efc71c9a67a9f6ea563ad0559279322e79e465eb987ea058fbc87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60783957e43efc71c9a67a9f6ea563ad0559279322e79e465eb987ea058fbc87"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "60783957e43efc71c9a67a9f6ea563ad0559279322e79e465eb987ea058fbc87"
    sha256 cellar: :any_skip_relocation, sonoma:        "066f5eda645456581bd0d5763709d35ed0a96c969a1cdcdf25f283d0952fa43b"
    sha256 cellar: :any_skip_relocation, ventura:       "066f5eda645456581bd0d5763709d35ed0a96c969a1cdcdf25f283d0952fa43b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a3a2e816575e03669c205060f8104672d6fc213b785c4a1092ffd96bc67fc36"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = "-s -w -X github.com/cloudquery/cloudquery/cli/v6/cmd.Version=#{version}"
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    system bin/"cloudquery", "init", "--source", "aws", "--destination", "bigquery"

    assert_path_exists testpath/"cloudquery.log"
    assert_match <<~YAML, (testpath/"aws_to_bigquery.yaml").read
      kind: source
      spec:
        # Source spec section
        name: aws
        path: cloudquery/aws
    YAML

    assert_match version.to_s, shell_output("#{bin}/cloudquery --version")
  end
end
