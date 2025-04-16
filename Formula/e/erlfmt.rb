class Erlfmt < Formula
  desc "Automated code formatter for Erlang"
  homepage "https://github.com/WhatsApp/erlfmt"
  url "https://github.com/WhatsApp/erlfmt/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "198f33ff305806d4cee5113884364d8874912f3ad0ec3d0aa2ca243cfadc44b6"
  license "Apache-2.0"

  depends_on "rebar3" => :build
  depends_on "erlang"

  def install
    system "rebar3", "as", "release", "escriptize"
    bin.install "_build/release/bin/erlfmt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/erlfmt --version")
    assert_equal "f(X) -> X * 10.\n",
                 pipe_output("#{bin}/erlfmt -", "f (X)->X*10 .")
  end
end
