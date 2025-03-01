class BaconLs < Formula
  desc "Rust diagnostic provider based on Bacon"
  homepage "https://github.com/crisidev/bacon-ls"
  url "https://github.com/crisidev/bacon-ls/archive/refs/tags/0.19.0.tar.gz"
  sha256 "a1376645260417273c0953b713c49921104e93d39ce1568966cb03cf718549c7"
  license "MIT"
  head "https://github.com/crisidev/bacon-ls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5adb5214414afd943d538610b34b86f25790d7a984d171b3c89a1f449b0ddacb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ec0d977d6aa27a4e81f72cbb765f71374000150348588da64471193243daa87"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b8ed5a7ed08bba23f30816195b5547c37705fa4e72422d26c444d30941f1402"
    sha256 cellar: :any_skip_relocation, sonoma:        "22f6460e81025009a8d3ff8e4775071db891849ff5d12016eaf059c3fd363a8f"
    sha256 cellar: :any_skip_relocation, ventura:       "0ad245c67eb601609a1dbceff4fdd27b9510106f0d84d4fe740be9d8357df005"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9dbf37daf6fd187a5652f50068133d98e5a7595dedec33a2e74257ba7746f546"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "open3"

    assert_match version.to_s, shell_output("#{bin}/bacon-ls --version")

    init_json = <<~JSON
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

    Open3.popen3(bin/"bacon-ls") do |stdin, stdout, _|
      stdin.write "Content-Length: #{init_json.bytesize}\r\n\r\n#{init_json}"
      stdin.close

      assert_match(/^Content-Length: \d+/i, stdout.read)
    end
  end
end
