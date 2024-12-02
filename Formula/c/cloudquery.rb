class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.12.5.tar.gz"
  sha256 "39d3f7a8a841ed61aadcc7e73c0886277c19111d4f1c51d8a376ed868d8b1685"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76d4b58eeae2d35e7ed302b19cc1c34deb2356f1bf46c98a5add762ea81f3147"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76d4b58eeae2d35e7ed302b19cc1c34deb2356f1bf46c98a5add762ea81f3147"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "76d4b58eeae2d35e7ed302b19cc1c34deb2356f1bf46c98a5add762ea81f3147"
    sha256 cellar: :any_skip_relocation, sonoma:        "87b7d1bc834511c2ba52be6f82bdf26c6e829569a8bb1df50c3b60b34863d903"
    sha256 cellar: :any_skip_relocation, ventura:       "87b7d1bc834511c2ba52be6f82bdf26c6e829569a8bb1df50c3b60b34863d903"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffcdf90cbc98604d349c3b7d01545c0b27cf5f017ed162f77f1e94ef2ebdb13e"
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
