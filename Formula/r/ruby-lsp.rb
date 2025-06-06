class RubyLsp < Formula
  desc "Opinionated language server for Ruby"
  homepage "https://shopify.github.io/ruby-lsp"
  url "https://github.com/Shopify/ruby-lsp/archive/refs/tags/v0.24.1.tar.gz"
  sha256 "726928a197a35aff4bffb70e459973b7192a2720fbed112b9aaa2916cd5d624f"
  license "MIT"
  head "https://github.com/Shopify/ruby-lsp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c584e2d303b60565ee5a5678d62a70fdca5d3c44aa2d1bf29de5dd976fdf956d"
    sha256 cellar: :any,                 arm64_sonoma:  "309d0aef070215e14f306aa16759390e9d453f67fa49c90b8ec767655c93838c"
    sha256 cellar: :any,                 arm64_ventura: "51bd4c6a00703c064f1d0a9bf092179f333bec44b492add3f259f7b0ab4cdca5"
    sha256 cellar: :any,                 sonoma:        "83d0e4d460977cc9d5dd90fe960f03bd7bdb0ae35592e3365dbbd09f579fa550"
    sha256 cellar: :any,                 ventura:       "812e8fcff15f87d6f9a7adf14b6524af36652b213a7488de9d1ea5cd423f81c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1cdd6fac6d9b774dd55e4b5d9bd9aa89cd0c255f3a814cefd5ff8052acf474f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2248a95748d1f36aa7340a7273d6552142385b435882222db88d366bcc4c1f6e"
  end

  depends_on "ruby"

  def install
    ENV["BUNDLE_VERSION"] = "system" # Avoid installing Bundler into the keg
    ENV["GEM_HOME"] = libexec

    system "bundle", "config", "set", "without", "development", "test"
    system "bundle", "install"
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"

    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files libexec/"bin",
      PATH:     "#{Formula["ruby"].opt_bin}:$PATH",
      GEM_HOME: ENV["GEM_HOME"]
  end

  test do
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}/ruby-lsp 2>&1", input, 0)
    assert_match(/^Content-Length: \d+/i, output)
  end
end
