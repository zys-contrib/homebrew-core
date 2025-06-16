class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://github.com/massdriver-cloud/mass/archive/refs/tags/1.11.1.tar.gz"
  sha256 "90a941125dae188610c4906180e5374ed2e6312e552b699ff6346c2ad09fe893"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b806c5272ff004cdb8a846106591ab2e47c499cd2ddf8512f1be0c895dfc3a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b806c5272ff004cdb8a846106591ab2e47c499cd2ddf8512f1be0c895dfc3a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b806c5272ff004cdb8a846106591ab2e47c499cd2ddf8512f1be0c895dfc3a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "de82a6c01b310a3c7ffee6688047108cacb1a3b15b7abb4326adf796c6325f13"
    sha256 cellar: :any_skip_relocation, ventura:       "de82a6c01b310a3c7ffee6688047108cacb1a3b15b7abb4326adf796c6325f13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ae067d338cc3aa745923a883733bde0df24c89e333cd6efb408899f4cd4fa7f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/massdriver-cloud/mass/pkg/version.version=#{version}
      -X github.com/massdriver-cloud/mass/pkg/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"mass")

    generate_completions_from_executable(bin/"mass", "completion")
  end

  test do
    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output

    output = shell_output("#{bin}/mass bundle lint 2>&1", 1)
    assert_match "OrgID: missing required value: MASSDRIVER_ORG_ID", output

    assert_match version.to_s, shell_output("#{bin}/mass version")
  end
end
