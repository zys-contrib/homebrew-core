class Sops < Formula
  desc "Editor of encrypted files"
  homepage "https://getsops.io/"
  url "https://github.com/getsops/sops/archive/refs/tags/v3.10.0.tar.gz"
  sha256 "a749e633ed68a0f357c7dfc3b005395c8697c18c1c88547f6b599a7169e20b37"
  license "MPL-2.0"
  head "https://github.com/getsops/sops.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37e076fb5868d03a09f4d1dc0362985f6287277f2f6e52071319d909c5ee572a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37e076fb5868d03a09f4d1dc0362985f6287277f2f6e52071319d909c5ee572a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "37e076fb5868d03a09f4d1dc0362985f6287277f2f6e52071319d909c5ee572a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7044f03ea020947e1e855ca703de6044fbd778f06d892652da35725ff6db2100"
    sha256 cellar: :any_skip_relocation, ventura:       "7044f03ea020947e1e855ca703de6044fbd778f06d892652da35725ff6db2100"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f5356d7cc9fb4b00f111872dfe2a6d06a60f11cf083d993c74de2ca3f821f07"
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
