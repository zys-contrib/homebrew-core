class Kubehound < Formula
  desc "Tool for building Kubernetes attack paths"
  homepage "https://kubehound.io"
  url "https://github.com/DataDog/KubeHound/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "5ee3ca8621d4611e682ed2325bb12b87d6f00c4f7717195d5f43856f5d9b7917"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3983899e7e0aae0d3bd07d4a775b42fc59ad776644a2dfb2ccdc96d9ab2b6fce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "832d7c60d8c546d94ec4bdf64a900b93c1774a345b8cf1bc9b58e86ef5f887ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd4c60d1ac07a65fb019dab6480f6f4f5f84d3763c9cc6f530516230c59e3117"
    sha256 cellar: :any_skip_relocation, sonoma:         "e0c7ffbc553d373fe3e160573248ce6c06e2e4af7d1242effb6dd4c92493bb4f"
    sha256 cellar: :any_skip_relocation, ventura:        "3202667ef54894775e0c2c85de0c966b1f7aa8e7c695f8413cc5303a8ebf98fb"
    sha256 cellar: :any_skip_relocation, monterey:       "a3befe679b83973912f1e0066fcfa775c20d0f90d46801d014d53c78540a93a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0e27e6919c232b1dfdc3b1a00f1e6be6ca9751f7bcec208b3898059d3887db8"
  end

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
