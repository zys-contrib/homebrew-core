class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.63.0.tar.gz"
  sha256 "728e76268637098c53a1def2614f3de3f84e0717f33f131e1288b939ea94c81e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "22338e011388bca185691d576e654ab74e41b947be25e3546e75d18275fd46ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc6f94b920b54867083dd25a9b539c045726d5230cf7ded15d3ad7b6d6f12590"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25c08cfa752f777b21efb63aa1721934986d495d88eb0c3e37d611876a309a01"
    sha256 cellar: :any_skip_relocation, sonoma:         "b801f87fd2a138884866978f6ba412dfa003e2ec6345daf4c7b3865b8e4d7255"
    sha256 cellar: :any_skip_relocation, ventura:        "8886654a031f832a71f06e173daaee98b146a2959f8c5c345347b68ea0f4d047"
    sha256 cellar: :any_skip_relocation, monterey:       "21301fd191ad3aad6bccc64c2b4e5ed3e72ee35f1160b84a5327a7941d3182f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b199628ad0d213c564c557796c8754a80311c3cee0d4073f0d91465adf9ff43"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
