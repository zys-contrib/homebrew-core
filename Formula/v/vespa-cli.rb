class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.507.34.tar.gz"
  sha256 "7d6e5f90333babe7d6ca5edfb5496a88eec978f4bf9c0d3c557a60e1744f4c30"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fe3b15088f895eb63ccc535289a1f7a0628120c651a99e538e4db3bbe945ed7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "721afea200e2193e49b8ba4902dd0a968cfd8c1fe79053cd401b20b06df0e941"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3cdaf69f85cfeb103965a8149ea791e40950889d6a763a6d48e3351cb9735685"
    sha256 cellar: :any_skip_relocation, sonoma:        "e89cd3bf2037dbc383c68ef21489096520f91b0ba846f122244c49412428cd69"
    sha256 cellar: :any_skip_relocation, ventura:       "449ed0054eb6ea8867b608f08bfde2755dcb697a91e6af969a4cee066d18b36f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecdae74fa25b2752b8003ef09e27760baa160d5bc4e9ac813872bdf632f09825"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", "completion")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    output = shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    assert_match "Error: deployment not converged", output
    system bin/"vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
