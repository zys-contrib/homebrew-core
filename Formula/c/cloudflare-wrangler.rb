class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.9.1.tgz"
  sha256 "2a4636a83a3164dd610289da6d6e21569dd1109fb73a4525a21addc03570a4d5"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "aa3e00dac07235f736ea6dc8a7be884c18a74f3b694714b5d85e8ca9993fe997"
    sha256 cellar: :any,                 arm64_sonoma:  "aa3e00dac07235f736ea6dc8a7be884c18a74f3b694714b5d85e8ca9993fe997"
    sha256 cellar: :any,                 arm64_ventura: "aa3e00dac07235f736ea6dc8a7be884c18a74f3b694714b5d85e8ca9993fe997"
    sha256                               sonoma:        "1f5f17de821b45bebcb67da328a722895c0bf59e94e2ab91153b921d4d455d69"
    sha256                               ventura:       "1f5f17de821b45bebcb67da328a722895c0bf59e94e2ab91153b921d4d455d69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2da37de58b14b42e0adfbb9ffc47133edb84322141477040a7b7bcbb4a6d28e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d61fd89fd650022a540d8386aeadd526cbd17d83674568f91b99144625bb07ee"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end
