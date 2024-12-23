class Kubeone < Formula
  desc "Automate cluster operations on all your environments"
  homepage "https://kubeone.io"
  license "Apache-2.0"
  head "https://github.com/kubermatic/kubeone.git", branch: "main"

  stable do
    url "https://github.com/kubermatic/kubeone/archive/refs/tags/v1.9.1.tar.gz"
    sha256 "bd19d41be2a172b5ad280e29fe7aac6d1f6c8d10c42bc6a4655bc4bb72aab2af"

    # fish completion support patch, upstream pr ref, https://github.com/kubermatic/kubeone/pull/3471
    patch do
      url "https://github.com/kubermatic/kubeone/commit/e43259aaec109a313288928ad3c0569a3dfda68a.patch?full_index=1"
      sha256 "3038576709fc007aece03b382715b1405e3e2b827a094def46f27f699f33e9fd"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6845aefd87e9632b65a650e8eb22bb9278f101575d95029aa71180bd36a8688"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e4037328cb525776f69d68b628fabb441d84a3be5d0662aa3d695b776889d46"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "629c0ff0037e53791784493de45fce32434453c5cfc507585eea42c35c406f8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2569fad72e220df740779ebdf8d994735a6a80bf44350b70084d2a84785f200"
    sha256 cellar: :any_skip_relocation, ventura:       "f32a80b0aeee397bec285807050c5a8a5f00b7b0b375a4a5148b79d3d829367f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3cf2281195bd9f4f8f019646fd78e67c29a150d9c8e871b9e32d164fdece7b3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X k8c.io/kubeone/pkg/cmd.version=#{version}
      -X k8c.io/kubeone/pkg/cmd.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubeone", "completion")
  end

  test do
    test_config = testpath/"kubeone.yaml"

    test_config.write <<~YAML
      apiVersion: kubeone.k8c.io/v1beta2
      kind: KubeOneCluster

      versions:
        kubernetes: 1.30.1
    YAML

    assert_match "apiEndpoint.port must be greater than 0", shell_output("#{bin}/kubeone status 2>&1", 15)

    assert_match version.to_s, shell_output("#{bin}/kubeone version")
  end
end
