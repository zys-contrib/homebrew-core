class Preevy < Formula
  desc "Quickly deploy preview environments to the cloud"
  homepage "https://preevy.dev/"
  url "https://registry.npmjs.org/preevy/-/preevy-0.0.66.tgz"
  sha256 "aae290aabc6046dc7770d853888dd9a7c13e57f3aa68397e249c2af608fd0460"
  license "Apache-2.0"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/preevy --version")

    output = shell_output("#{bin}/preevy ls 2>&1", 2)
    assert_match "Error: Profile not initialized", output
  end
end
