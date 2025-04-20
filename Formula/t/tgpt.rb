class Tgpt < Formula
  desc "AI Chatbots in terminal without needing API keys"
  homepage "https://github.com/aandrew-me/tgpt"
  url "https://github.com/aandrew-me/tgpt/archive/refs/tags/v2.9.6.tar.gz"
  sha256 "6800b06059de1f5bab2aa3bbf61c3d43ec63498a9dccb7a4918e7f8790c04bd8"
  license "GPL-3.0-only"
  head "https://github.com/aandrew-me/tgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35b0174e0fa3279921cbd127752b10b7cfafbcee4616c455d706007b11cff1fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35b0174e0fa3279921cbd127752b10b7cfafbcee4616c455d706007b11cff1fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "35b0174e0fa3279921cbd127752b10b7cfafbcee4616c455d706007b11cff1fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ee645b270191b68f1e458441790d5c7084cce097c5f420bf00095b49e1721b2"
    sha256 cellar: :any_skip_relocation, ventura:       "7ee645b270191b68f1e458441790d5c7084cce097c5f420bf00095b49e1721b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "323edede2a1a819f30979127028d3c433eda72c738978460d08bc33c33114d3c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tgpt --version")

    output = shell_output("#{bin}/tgpt --provider pollinations \"What is 1+1\"")
    assert_match "1 + 1 equals 2.", output
  end
end
