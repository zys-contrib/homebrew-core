class Sops < Formula
  desc "Editor of encrypted files"
  homepage "https://getsops.io/"
  url "https://github.com/getsops/sops/archive/refs/tags/v3.10.2.tar.gz"
  sha256 "2f7cfa67f23ccc553538450a1c3e3f7666ec934d94034457b3890dbcd49b0469"
  license "MPL-2.0"
  head "https://github.com/getsops/sops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6483f4eaa1728676510a009ef7f8372cbcf1e3f204f51caad0ad0e39eedef5a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6483f4eaa1728676510a009ef7f8372cbcf1e3f204f51caad0ad0e39eedef5a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6483f4eaa1728676510a009ef7f8372cbcf1e3f204f51caad0ad0e39eedef5a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "9cfeb721bcd3905f22ff1170d4f6c4657817d872689088cd6f081fce74c3b9b8"
    sha256 cellar: :any_skip_relocation, ventura:       "9cfeb721bcd3905f22ff1170d4f6c4657817d872689088cd6f081fce74c3b9b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e395949652afc37d66373af18862cbcac33f559b9fa15b436dc42fbbfe3d7b5b"
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
