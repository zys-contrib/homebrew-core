class Tgpt < Formula
  desc "AI Chatbots in terminal without needing API keys"
  homepage "https://github.com/aandrew-me/tgpt"
  url "https://github.com/aandrew-me/tgpt/archive/refs/tags/v2.9.3.tar.gz"
  sha256 "9607983224da9706535f5b38ca4124cc439850acef57223cb02925ea9b168fd7"
  license "GPL-3.0-only"
  head "https://github.com/aandrew-me/tgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5a563fe2d9ba268541a0cef460f7cf2078e244dfd95f4604463f69369eda541"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5a563fe2d9ba268541a0cef460f7cf2078e244dfd95f4604463f69369eda541"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f5a563fe2d9ba268541a0cef460f7cf2078e244dfd95f4604463f69369eda541"
    sha256 cellar: :any_skip_relocation, sonoma:        "b93a4502723ce9a4cc043e571af57789a787267fec4c4eacc02b3d350e6619a2"
    sha256 cellar: :any_skip_relocation, ventura:       "b93a4502723ce9a4cc043e571af57789a787267fec4c4eacc02b3d350e6619a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a16a73e2753d143f50145323db94d00b38fe05bc468c6f0d991c768567f5d9f6"
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
