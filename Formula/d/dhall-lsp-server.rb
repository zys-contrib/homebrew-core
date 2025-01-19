class DhallLspServer < Formula
  desc "Language Server Protocol (LSP) server for Dhall"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-lsp-server"
  url "https://hackage.haskell.org/package/dhall-lsp-server-1.1.4/dhall-lsp-server-1.1.4.tar.gz"
  sha256 "4c7f056c8414f811edb14d26b0a7d3f3225762d0023965e474b5712ed18c9a6d"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "be84073f0eab1bca53d11e14033e15d1ba9b98a71bb6f1109d257fed2df6f32f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3aa48be14dd82f80c0b18dbf2749425279a382c68994febf412085f4b219835c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "404e71e6c61f8838993cdf6640c0b567002ed11a9c9d3c05d375370eeb71eb24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65e8c3a933db681ef99efadb8fe8e8461ace1816a5f32f2b038f990d9f0435c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cccd4dcfde8ad35f651d8d782670238ba3adeaa78e62a686a855adacea98c53f"
    sha256 cellar: :any_skip_relocation, sonoma:         "491813c677ada773203f55c47688adc27dab63a90685bfae30cdf61ccbe06585"
    sha256 cellar: :any_skip_relocation, ventura:        "9dc9ecacf5601cce00502a0f2e19ba14c2d941e231a90607cdf76cf889b86d57"
    sha256 cellar: :any_skip_relocation, monterey:       "d5a3138a0c6445e855ece84b1e5a9171d94ace5d3752b57054eb1c4bbd19ba8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a4548b37b445c1875bed0e54123157e73d5bab76bbb61dcf2ccbabeb22c2902"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "994efb7ca3ec4bb7af8d557d1a6393d699c3a0fd6b8ee8902478e2b1104f6aa1"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.8" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    cd name if build.head?

    # Workaround until dhall-json has a new package release or metadata revision
    # https://github.com/dhall-lang/dhall-haskell/commit/28d346f00d12fa134b4c315974f76cc5557f1330
    args = ["--allow-newer=dhall-json:aeson", "--constraint=aeson<2.3"]

    # Workaround until https://github.com/dhall-lang/dhall-haskell/pull/2571 is available
    args += ["--allow-newer=lsp:lsp-types", "--constraint=lsp-types>=2.1 && <2.2"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args
  end

  test do
    input =
      "Content-Length: 152\r\n" \
      "\r\n" \
      "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"initialize\",\"params\":{\"" \
      "processId\":88075,\"rootUri\":null,\"capabilities\":{},\"trace\":\"ver" \
      "bose\",\"workspaceFolders\":null}}\r\n" \
      "Content-Length: 46\r\n" \
      "\r\n" \
      "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"shutdown\"}\r\n" \
      "Content-Length: 42\r\n" \
      "\r\n" \
      "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"exit\"}\r\n"

    output = pipe_output(bin/"dhall-lsp-server", input, 0)

    assert_match(/^Content-Length: \d+/i, output)
    assert_match "dhall.server.lint", output
  end
end
