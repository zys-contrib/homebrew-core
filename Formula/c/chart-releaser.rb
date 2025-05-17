class ChartReleaser < Formula
  desc "Hosting Helm Charts via GitHub Pages and Releases"
  homepage "https://github.com/helm/chart-releaser/"
  url "https://github.com/helm/chart-releaser/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "de29b9f4f62145a08e55fd74ca1068fb8db61432aa39b84b3b3314f1d0846d5a"
  license "Apache-2.0"
  head "https://github.com/helm/chart-releaser.git", branch: "main"

  depends_on "go" => :build
  depends_on "helm" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/helm/chart-releaser/cr/cmd.Version=#{version}
      -X github.com/helm/chart-releaser/cr/cmd.GitCommit=#{tap.user}
      -X github.com/helm/chart-releaser/cr/cmd.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"cr"), "./cr"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cr version")

    system "helm", "create", "testchart"
    system bin/"cr", "package", "--package-path", testpath/"packages", testpath/"testchart"
    assert_path_exists testpath/"packages/testchart-0.1.0.tgz"
  end
end
