class Qbec < Formula
  desc "Configure Kubernetes objects on multiple clusters using jsonnet"
  homepage "https://qbec.io"
  url "https://github.com/splunk/qbec/archive/refs/tags/v0.16.3.tar.gz"
  sha256 "1dfdd8f4db74ba3115c56704e99b26d072ad72aa14f84d5af8e1c419126bb122"
  license "Apache-2.0"
  head "https://github.com/splunk/qbec.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/splunk/qbec/internal/commands.version=#{version}
      -X github.com/splunk/qbec/internal/commands.commit=#{tap.user}
      -X github.com/splunk/qbec/internal/commands.goVersion=#{Formula["go"].version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    # only support bash at the moment
    generate_completions_from_executable(bin/"qbec", "completion", shells: [:bash])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qbec version")

    system bin/"qbec", "init", "test"
    assert_path_exists testpath/"test/environments/base.libsonnet"
    assert_match "apiVersion: qbec.io/v1alpha1", (testpath/"test/qbec.yaml").read
  end
end
