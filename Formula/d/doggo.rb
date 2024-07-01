class Doggo < Formula
  desc "Command-line DNS Client for Humans"
  homepage "https://doggo.mrkaran.dev/"
  url "https://github.com/mr-karan/doggo/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "056c0edac0007293b519e6bd50ca9c3445cbe340e868c3d9030abc495b44c881"
  license "GPL-3.0-or-later"
  head "https://github.com/mr-karan/doggo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4bce4ba0cb699798165e00f37b3541e26df8a609a63080d7e9f66c961a1e18f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b4de65a929a6de277912e2868de0181f93a7ad5866c756849a52da3440b3ebe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5c05cbba75ddc4045bb66aaadfac7add891eb6b00b27b41ac9bb0fcf04903e9"
    sha256 cellar: :any_skip_relocation, sonoma:         "86b8edce3f395974c86d21616874ecc82d816c749116e1eca2be8826f510055f"
    sha256 cellar: :any_skip_relocation, ventura:        "9fb951a3f37e56c9d0a7ed4ae18123c91d3533a15816d244e1cbc8269366cae7"
    sha256 cellar: :any_skip_relocation, monterey:       "14b07f27630f2741d5fa6a20e06772a697a6d2eca3c4e82af8330d6b0b53c2a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2ce5071d318730f98cbf08a114540efcb5f4d0628babc7bbe89024a05898c99"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd"

    generate_completions_from_executable(bin/"doggo", "completions")
  end

  test do
    answer = shell_output("#{bin}/doggo --short example.com NS @1.1.1.1")
    assert_equal "a.iana-servers.net.\nb.iana-servers.net.\n", answer

    assert_match version.to_s, shell_output("#{bin}/doggo --version")
  end
end
