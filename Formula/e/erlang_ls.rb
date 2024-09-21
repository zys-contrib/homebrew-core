class ErlangLs < Formula
  desc "Erlang Language Server"
  homepage "https://erlang-ls.github.io/"
  url "https://github.com/erlang-ls/erlang_ls/archive/refs/tags/0.53.0.tar.gz"
  sha256 "e35383dd316af425a950a65d56e7e8179b0d179c3d6473be05306a9b3c0b0ef5"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b65b641bc307ea2f4ed41a8441e00a5a1dabacf3673033242e9b25623ea9120"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68696353c214d1061d815ec536dc4e1dd9dd224f95692db1512d59390262ff68"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d637886c8828c4ac9bf2ea19f7b4a4f3e03f3a851fc6bdcf8947b019d923241"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d253a02ada4fa5b0d03c392d5f2b6d5ac6bc6057baf19c7c4617629ab1f3324"
    sha256 cellar: :any_skip_relocation, ventura:       "25b385484d393e06627e363e72ab241a41d9e3cb152a5ef8af43924675a2f124"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ed0802b21b473b74e529328a7498f1415eaf4f83b6c1d29131b3c32ab467148"
  end

  depends_on "erlang"
  depends_on "rebar3"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    output = pipe_output(bin/"erlang_ls", nil, 1)
    assert_match "Content-Length", output
  end
end
