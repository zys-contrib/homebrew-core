class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.18.2.tar.gz"
  sha256 "bc6d8c47a4179e4e517b6dc676edcdf6f388e9ae0515fddb3c992c4e42157081"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ab56e9ad075ff8167402cb0e6aaf32f32308bf06480433c0b3699bf68e387e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ab56e9ad075ff8167402cb0e6aaf32f32308bf06480433c0b3699bf68e387e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ab56e9ad075ff8167402cb0e6aaf32f32308bf06480433c0b3699bf68e387e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "51170a51b5be3b66514288baa0b6820663f4317674d01962aff0150807dde116"
    sha256 cellar: :any_skip_relocation, ventura:       "51170a51b5be3b66514288baa0b6820663f4317674d01962aff0150807dde116"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5da229fd8df2aff1556fde7923af1ce99aade3c933d9f75674e95741c5ef0bd0"
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
