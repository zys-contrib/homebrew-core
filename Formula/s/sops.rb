class Sops < Formula
  desc "Editor of encrypted files"
  homepage "https://github.com/getsops/sops"
  url "https://github.com/getsops/sops/archive/refs/tags/v3.9.3.tar.gz"
  sha256 "07f21ad574df8153d28f9bcd0a6e5d03c436cb9a45664a9af767a70a7d7662b9"
  license "MPL-2.0"
  head "https://github.com/getsops/sops.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7567b33797e17e0f3d1a85da1913ca11b85010a0421c1d2562252f60e51584db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7567b33797e17e0f3d1a85da1913ca11b85010a0421c1d2562252f60e51584db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7567b33797e17e0f3d1a85da1913ca11b85010a0421c1d2562252f60e51584db"
    sha256 cellar: :any_skip_relocation, sonoma:        "5492d1bd65d75f608a2695dbd2b665a6fd28b83d12594ce3b13e8bf5836d4e5d"
    sha256 cellar: :any_skip_relocation, ventura:       "5492d1bd65d75f608a2695dbd2b665a6fd28b83d12594ce3b13e8bf5836d4e5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c0529de1eeb34a8a7b489a760c813c72d1071ec2a0cd05452bdb05ea5b3c39e"
  end

  depends_on "go" => :build

  def install
    system "go", "mod", "tidy"

    ldflags = "-s -w -X github.com/getsops/sops/v3/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/sops"
    pkgshare.install "example.yaml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sops --version")

    assert_match "Recovery failed because no master key was able to decrypt the file.",
      shell_output("#{bin}/sops #{pkgshare}/example.yaml 2>&1", 128)
  end
end
