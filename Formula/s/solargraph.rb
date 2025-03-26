class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.53.1",
      revision: "0e82bbdcc9da7343dd028373797f2fe0373dbf6a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a01a7933988410b5082fe964c445cb9020d826ebe1d39bde2df4d0ffbfacddda"
    sha256 cellar: :any,                 arm64_sonoma:  "cc5593f9816b58ba88086bfd7dcc5de7dbf5a230dd3021c0e5a120584914de52"
    sha256 cellar: :any,                 arm64_ventura: "9a40c2a674ed5a30f49fbb2a9247ce9293460b1b7c22a33e5f6b1cf7987b3276"
    sha256 cellar: :any,                 sonoma:        "fbff78ad48ea609bf58ebb627c945be8ee96a8a2522ee832ac85d93749c33542"
    sha256 cellar: :any,                 ventura:       "641b17ff4ce1f5dea9878cb2211668429e5c6baf385d8162a0084b6eeae7f16c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aeac92990df3c89959776c1a6de1ddd4cebfb05a72205ac7e2d90459b1610479"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d7bf019876fbf4b618a8ce26bf80af0de4947bdcd972da31b9b03fac78a673d"
  end

  depends_on "ruby" # Requires >= Ruby 2.7

  depends_on "xz"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    require "open3"

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

    Open3.popen3(bin/"solargraph", "stdio") do |stdin, stdout, _, _|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
