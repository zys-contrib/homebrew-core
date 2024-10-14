class Cyphernetes < Formula
  desc "Kubernetes Query Language"
  homepage "https://cyphernet.es"
  url "https://github.com/AvitalTamir/cyphernetes/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "cad9220829ad61429478cc08b2632063588ea763af3cd4806fa2ef94b7e3c354"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "027d7de889844224b6098738af42839bb6e63e0e0e7bd2c60177d3c4890b7774"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "027d7de889844224b6098738af42839bb6e63e0e0e7bd2c60177d3c4890b7774"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "027d7de889844224b6098738af42839bb6e63e0e0e7bd2c60177d3c4890b7774"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d100fa000f34051281d4dcef1a38e082765e6d4c8ea33bf3ff68dc612a462a8"
    sha256 cellar: :any_skip_relocation, ventura:       "4d100fa000f34051281d4dcef1a38e082765e6d4c8ea33bf3ff68dc612a462a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93e2269f4c346d9235e84c0028bc7ee8407c2d7aa5b750c30c9b844604798636"
  end

  depends_on "go" => :build
  depends_on "goyacc" => :build

  def install
    system "make", "operator-manifests", "gen-parser"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cyphernetes"

    generate_completions_from_executable(bin/"cyphernetes", "completion")
  end

  test do
    output = shell_output("#{bin}/cyphernetes query 'MATCH (d:Deployment)->(s:Service) RETURN d'", 1)

    assert_match("Error getting current context:  current context  does not exist in kubeconfig", output)
  end
end
