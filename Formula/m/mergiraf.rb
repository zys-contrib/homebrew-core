class Mergiraf < Formula
  desc "Syntax-aware git merge driver"
  homepage "https://mergiraf.org"
  url "https://codeberg.org/mergiraf/mergiraf/archive/v0.11.0.tar.gz"
  sha256 "6b43d6d70067c76a8b7d24590bbfa1b83405bdf129d01cd5ea7a45b1a09f5f31"
  license "GPL-3.0-only"
  head "https://codeberg.org/mergiraf/mergiraf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "feaa82ea220e1cb6858387c0c116d0f0e5368c3ae1913da0153dbce8640a4aaa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4d01e9d8876b67ab22aaf37eb352d36508216bee82d371f981ac7d5128f195c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0cdf1fb8cc29317990f1cf9f8051430af78b5ef4125d77f671d02eff9144de0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b48f7c0fbae29fd90501fa718cd2ed47e35c78511272015d1428143750fc39c0"
    sha256 cellar: :any_skip_relocation, ventura:       "fe918a0e69d69aa88fb3aec8be4049b3da39e11cfdc274b959bb2e56aa99fa46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "237bca642fbdabda1236dde3a326941231c8d9fff8310d714c3b80f207d27a43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "becd36cd9c79f54a7c8761cc9fcee4d6a4244997373e8e3b8e6f8e6cbd9a280f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mergiraf -V")

    assert_match "YAML (*.yml, *.yaml)", shell_output("#{bin}/mergiraf languages")
  end
end
