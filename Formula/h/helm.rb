class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm/archive/refs/tags/v3.15.3.tar.gz"
  sha256 "f4eb30fa8285091ceffba16cf5ad7ec4b444897bd1df615af4bef3842f6d6d0e"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "acf31d718a351224ceddc070b77c88bfda41fdeca0568bc1fb73933fd76247c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71847de7550d6ce1179d0fe8ec93f737416db04b88db113bfcb49e0226aadff5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e15df753d03f6aa213bcc3c204b49da112f8ba16a38f2e563261f7b7df41c01"
    sha256 cellar: :any_skip_relocation, sonoma:         "aad9245f76cf88b3872c04b2e33d63c4a7c860974bc97a0928901ea084da0a1c"
    sha256 cellar: :any_skip_relocation, ventura:        "83af0d48b3daf8b926b9ff6f8a911513233b8afc2766b434bf66181849a9737d"
    sha256 cellar: :any_skip_relocation, monterey:       "efe450f4ec2da4df86d1832422e13239f3ef1ca87a875b291813668f91864573"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c515f4142a5e45df24a30eecbda7a0bf36a285f040983a4c2ee0132e3900732"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X helm.sh/helm/v3/internal/version.version=v#{version}
      -X helm.sh/helm/v3/internal/version.metadata=
      -X helm.sh/helm/v3/internal/version.gitCommit=#{tap.user}
      -X helm.sh/helm/v3/internal/version.gitTreeState=clean
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/helm"

    mkdir "man1" do
      system bin/"helm", "docs", "--type", "man"
      man1.install Dir["*"]
    end

    generate_completions_from_executable(bin/"helm", "completion")
  end

  test do
    system bin/"helm", "create", "foo"
    assert File.directory? testpath/"foo/charts"

    version_output = shell_output(bin/"helm version")
    assert_match "GitTreeState:\"clean\"", version_output
    assert_match "Version:\"v#{version}\"", version_output
  end
end
