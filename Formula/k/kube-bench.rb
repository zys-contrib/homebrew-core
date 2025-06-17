class KubeBench < Formula
  desc "Checks Kubernetes deployment against security best practices (CIS Benchmark)"
  homepage "https://github.com/aquasecurity/kube-bench"
  url "https://github.com/aquasecurity/kube-bench/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "0113a22ef39ac2f4d7d0fa4b2871e41b4ba5ebae59c012b3ab8349117b67cbe1"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/kube-bench.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9f7114e10aa3f80efe162cc58581fd086d0f4c01688a34027878ce5c441c86c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9f7114e10aa3f80efe162cc58581fd086d0f4c01688a34027878ce5c441c86c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e9f7114e10aa3f80efe162cc58581fd086d0f4c01688a34027878ce5c441c86c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e68b71f799a161fb423f0dee490c81d96383e8de9532fe9ebb55e4afc5b2a64"
    sha256 cellar: :any_skip_relocation, ventura:       "9e68b71f799a161fb423f0dee490c81d96383e8de9532fe9ebb55e4afc5b2a64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9d76087ce976f9b2da18f122283a2d253ea73ab4f4dba335b6561a72621a726"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/aquasecurity/kube-bench/cmd.KubeBenchVersion=#{version}")

    generate_completions_from_executable(bin/"kube-bench", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kube-bench version")

    output = shell_output("#{bin}/kube-bench run 2>&1", 1)
    assert_match "error: config file is missing 'version_mapping' section", output
  end
end
