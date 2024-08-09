class GitCredentialOauth < Formula
  desc "Git credential helper that authenticates in browser using OAuth"
  homepage "https://github.com/hickford/git-credential-oauth"
  url "https://github.com/hickford/git-credential-oauth/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "06da9103faaadf1e0d1f7ae9758f7193828fc9d7b3de246fcd8ef889450c5639"
  license "Apache-2.0"
  head "https://github.com/hickford/git-credential-oauth.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a7e0af6e5ce989ef4586709e5908a8d06a73ca615e3945f7d099699f7b0e9808"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3718c14f0d67a5cb7405aed8f6825dde2f397d683cd177fa810ab6e3e01badb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e141efd510b33a465e40e2c640dafb3828f92f7f67cb54534175e3d4f0d591cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "fba66f5fc381ea1aa341a1985fac9c13a2e16738c393a1527cb4d177f62c9f97"
    sha256 cellar: :any_skip_relocation, ventura:        "196e5391f4198f7776ee71944641aa9b45124aee2b7b6449cece92a7613fa7a1"
    sha256 cellar: :any_skip_relocation, monterey:       "1b28a10d586e0fb117088ba51f5e156e27aa88af3148f0009faaa336eb249cf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2987263293629dd2f906367cedbd13a7308b817a1b3191ba52d45f376387f233"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match "git-credential-oauth #{version}", shell_output("#{bin}/git-credential-oauth -verbose 2>&1", 2)
  end
end
