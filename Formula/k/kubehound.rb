class Kubehound < Formula
  desc "Tool for building Kubernetes attack paths"
  homepage "https://kubehound.io"
  url "https://github.com/DataDog/KubeHound/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "5ee3ca8621d4611e682ed2325bb12b87d6f00c4f7717195d5f43856f5d9b7917"
  license "Apache-2.0"

  depends_on "go" => [:build, :test]

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOARCH").chomp

    ldflags = %W[
      -s -w
      -X github.com/DataDog/KubeHound/pkg/config.BuildVersion=v#{version}
      -X github.com/DataDog/KubeHound/pkg/config.BuildBranch=main
      -X github.com/DataDog/KubeHound/pkg/config.BuildOs=#{goos}
      -X github.com/DataDog/KubeHound/pkg/config.BuildArch=#{goarch}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/kubehound/"
  end

  test do
    assert_match "kubehound version: v#{version}", shell_output("#{bin}/kubehound version")

    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"
    error_message = "error starting the kubehound stack: Cannot connect to the Docker daemon"
    assert_match error_message, shell_output("#{bin}/kubehound backend up 2>&1", 1)
  end
end
