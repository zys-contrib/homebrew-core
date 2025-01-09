class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.13.0.tar.gz"
  sha256 "750b911ef4e1dc63e03bb5ada28a43c36c5d3e5caa1bd07f135fa14b5db65fae"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a8eb027183176ad1b286c75c48cc48cfa27e5308388f21a1c94792d748b7802"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a8eb027183176ad1b286c75c48cc48cfa27e5308388f21a1c94792d748b7802"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a8eb027183176ad1b286c75c48cc48cfa27e5308388f21a1c94792d748b7802"
    sha256 cellar: :any_skip_relocation, sonoma:        "f73464c4b3564fa8b864f86d2940e039168a6a4becba548f9727dd0e3ef3029c"
    sha256 cellar: :any_skip_relocation, ventura:       "f73464c4b3564fa8b864f86d2940e039168a6a4becba548f9727dd0e3ef3029c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eea01b5017130176055878370a844a796317e8a9127187d5275dfdb9fccbf8cd"
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
