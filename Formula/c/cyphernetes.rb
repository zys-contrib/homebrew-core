class Cyphernetes < Formula
  desc "Kubernetes Query Language"
  homepage "https://cyphernet.es"
  url "https://github.com/AvitalTamir/cyphernetes/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "b2c5d9689756c421cc3d698077d748be0c8c51cda084a07cba27c1c316009155"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75da4e379823ea786ea5a4c49529ad849ded9713aac3b1f538279981bcc2b52d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75da4e379823ea786ea5a4c49529ad849ded9713aac3b1f538279981bcc2b52d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75da4e379823ea786ea5a4c49529ad849ded9713aac3b1f538279981bcc2b52d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2d6275f62e613029912d8fd68a92572eb7c36549a42ca86766fc652c601fbe4"
    sha256 cellar: :any_skip_relocation, ventura:       "b2d6275f62e613029912d8fd68a92572eb7c36549a42ca86766fc652c601fbe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "282922804f0b4394dc1c10fa5b3e6c37887a129a7a74c7ce32ab689618090c05"
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
