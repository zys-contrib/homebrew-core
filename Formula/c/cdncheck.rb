class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "3c95c6d7edcaba7a232abf21c92afe439d8f948a1b9c960539faef80ba007390"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4ea498560b05fcd284a78c28780a27749f4b32c28555a98105ee2dce7edbf89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ddf263bdf5e8ff9e7d83c70a8f58d53d40d0ecb5c8f7bf446b4e12e7abc26ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "238b621263a9d82ff9131a99e3f603b46dec1d5998766c34cfa54c3e4f75040c"
    sha256 cellar: :any_skip_relocation, sonoma:        "99e03fb3725a364552905b982c48d33b61eefa7ccb6c3a7c8e792ddb7e1e061d"
    sha256 cellar: :any_skip_relocation, ventura:       "06b82dd15ef58b3bfe3b50e8c45d70d5b40be8b528d3c0b20c69859b6941dab5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5a76096acf13451793e2af1e79ea762ced8d7b0551db494bcfb728cba30c3a6"
  end

  depends_on "go" => :build

  # Fix for incorrect version. The commit was made after the release. At the
  # time of the next release, ensure that the commit updating the version is
  # part of the release. Remove this patch in the next release.
  patch do
    url "https://github.com/projectdiscovery/cdncheck/commit/430afb8d3e8a732cafc849beb270e788ded3bd09.patch?full_index=1"
    sha256 "b658666f659fb11adb29b2ad084667daa982c63e8239a884662dc9b7e099b55d"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "Found result: 1", shell_output("#{bin}/cdncheck -i 173.245.48.12/32 2>&1")
  end
end
