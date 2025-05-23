class RubyLsp < Formula
  desc "Opinionated language server for Ruby"
  homepage "https://shopify.github.io/ruby-lsp"
  url "https://github.com/Shopify/ruby-lsp/archive/refs/tags/v0.23.22.tar.gz"
  sha256 "5a8f9ee657d63c78fed79b744c1055a5ba5881e256bdfbee26b2325e4e3a9a78"
  license "MIT"
  head "https://github.com/Shopify/ruby-lsp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d3b292f7e192cf21fb3eafa065f22b3de7d5f9ef5dbc3bc7a4f9f776f92a262b"
    sha256 cellar: :any,                 arm64_sonoma:  "962eee0d596424d618663eac21555b9d8d1840b6d780dc76c5eaec4d171e2acd"
    sha256 cellar: :any,                 arm64_ventura: "113df93f1d1e1fdeeae13d4837f3726ddb7651ed32635462532e9e2a4343355d"
    sha256 cellar: :any,                 sonoma:        "78713a06856251b59c86574b409ad375c23240fd368581739525b37bf50473f2"
    sha256 cellar: :any,                 ventura:       "81eea948d877b92326c8c40429ce3da76ac3528cd99a491db67532d5d6e22b9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b92017656a5c2e93be00de97fc3a63dd8b07ff4648a059c9edf584ffbf8e47a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ac1946dbe5ddf9a816344c8bfb1478772338118540901b10531185e5e0f5d45"
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
