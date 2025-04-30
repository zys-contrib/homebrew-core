class Opkssh < Formula
  desc "Enables SSH to be used with OpenID Connect"
  homepage "https://eprint.iacr.org/2023/296"
  url "https://github.com/openpubkey/opkssh/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "df86132ce42ba3ad4bb7b34584a1176a38d6243514a365d866f67a9f1536f67b"
  license "Apache-2.0"
  head "https://github.com/openpubkey/opkssh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30b99b05d642470a9afaf636a5fd3b65a71832009a6914c8f2e1c7752c35d569"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30b99b05d642470a9afaf636a5fd3b65a71832009a6914c8f2e1c7752c35d569"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "30b99b05d642470a9afaf636a5fd3b65a71832009a6914c8f2e1c7752c35d569"
    sha256 cellar: :any_skip_relocation, sonoma:        "515dbf57d7f5df1039e21ac8c1a7ff217f922c4c2d7bac499596661db2d2b469"
    sha256 cellar: :any_skip_relocation, ventura:       "515dbf57d7f5df1039e21ac8c1a7ff217f922c4c2d7bac499596661db2d2b469"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e98210a50e087103791f0601d5bfb9b93d416ba7ec14ba18845312cf11207507"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opkssh --version")

    output = shell_output("#{bin}/opkssh add brew brew brew 2>&1", 1)
    assert_match "Failed to add to policy", output
  end
end
