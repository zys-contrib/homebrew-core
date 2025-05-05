class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "c09615c43d195f119ef057ce293b475833fd5d5c52058e39b6052f49ddfb24ca"
  license "MIT"
  head "https://github.com/Praqma/helmsman.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d0929fc620f2b70c7ac8d73882af83e4ad75945ecff541943b115153ba051b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d0929fc620f2b70c7ac8d73882af83e4ad75945ecff541943b115153ba051b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d0929fc620f2b70c7ac8d73882af83e4ad75945ecff541943b115153ba051b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9218db433fded2e7250b6e8c2c4eb0c05de5f4704dbe91fb3a8211482bbd8b0"
    sha256 cellar: :any_skip_relocation, ventura:       "a9218db433fded2e7250b6e8c2c4eb0c05de5f4704dbe91fb3a8211482bbd8b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15db5f87deb842220d669913fcba8cb8ec6437b773411f966ce56f515259779c"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/helmsman"
    pkgshare.install "examples/example.yaml", "examples/job.yaml"
  end

  test do
    ENV["ORG_PATH"] = "brewtest"
    ENV["VALUE"] = "brewtest"

    output = shell_output("#{bin}/helmsman --apply -f #{pkgshare}/example.yaml 2>&1", 1)
    assert_match "helm diff not found", output

    assert_match version.to_s, shell_output("#{bin}/helmsman version")
  end
end
