class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.55.5",
      revision: "3aed6b0625fc77e9770ea546edb70c8dcb9cac55"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c85a831b38c600570bdab5d3844998fbdbdb47cc8dbf05ec6d2e91398e8b7444"
    sha256 cellar: :any,                 arm64_sonoma:  "f9d0b66cfc6191010783f78888d0991de829234c86019e21e4df374eb8b2676f"
    sha256 cellar: :any,                 arm64_ventura: "42aa06a84e66e8cfdcc6c5fb5476ba3cbf6c38131fec7bc96cfb0f90d243d9f7"
    sha256 cellar: :any,                 sonoma:        "d1e2cd99533a0b7af28d6ef7cd0630ec941ce54114a0105e14ad69c9c0d78bc1"
    sha256 cellar: :any,                 ventura:       "555d0023bb3ce21d0d046c00f29e775049d114e1713e24b9a1f07fd800eec164"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3e988e4507cb92afbe0943a6e2b602e0bc47371c9e3bc9d84b4e9025a602747"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eae7750f9a8e816f5660473e23a0403488009b76eb34e5204efdec1a043e717b"
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
