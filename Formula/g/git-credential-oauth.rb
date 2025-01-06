class GitCredentialOauth < Formula
  desc "Git credential helper that authenticates in browser using OAuth"
  homepage "https://github.com/hickford/git-credential-oauth"
  url "https://github.com/hickford/git-credential-oauth/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "0b9c23264e67a6cdd423031749ab9c6679c14ce88b1e2c4c5c2219501c70f628"
  license "Apache-2.0"
  head "https://github.com/hickford/git-credential-oauth.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bb87e1ddd6a3b9e8a5e215786f3387abea7c5243f356545aa547dbe36640714"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bb87e1ddd6a3b9e8a5e215786f3387abea7c5243f356545aa547dbe36640714"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2bb87e1ddd6a3b9e8a5e215786f3387abea7c5243f356545aa547dbe36640714"
    sha256 cellar: :any_skip_relocation, sonoma:        "14257aec08dcf92ca92b1013b81f6129a19a03c98ce11f0c5f2e26f97e828933"
    sha256 cellar: :any_skip_relocation, ventura:       "14257aec08dcf92ca92b1013b81f6129a19a03c98ce11f0c5f2e26f97e828933"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3e5d9af07a696b7efd6b288c72cc0e24e8ef3379810644275861ada5aaed2f7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match "git-credential-oauth #{version}", shell_output("#{bin}/git-credential-oauth -verbose 2>&1", 2)
  end
end
