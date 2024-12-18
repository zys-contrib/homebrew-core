class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "d0f2b07ebdc6e3021f02c9a2c1d3738151c6d55f6136749c1de08c2da7fa9108"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f7b5f2d8f906cd721ecd057224f6c5215808f5cf40a2d03fed98eceb9c6d6e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de896b0615e43325db0d3afff180060265b5f480e780ea987093f31a0630e28b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eebf99a88ebfab7606e2de6afa9cada64a273b430f0b14962dbed27700cbf916"
    sha256 cellar: :any_skip_relocation, sonoma:        "8fec4d8e8cc6d574bfa8f47bcf719d174e7e0ddde8cd78e52d460105dceee938"
    sha256 cellar: :any_skip_relocation, ventura:       "5cf020ae27385979bb971fb013eca9f8ddf5dc2e5cd93a1f991dc58cf0c8b5f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1a5b54f8b2e21cdb3c616553c4810827c23193954d5fc677cc9b3ff7b8ece8a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "usage-cli", shell_output(bin/"usage --version").chomp
    assert_equal "--foo", shell_output(bin/"usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end
