require "language/node"

class LandoCli < Formula
  include Language::Node::Shebang

  desc "Cli part of Lando"
  homepage "https://docs.lando.dev/cli"
  url "https://github.com/lando/cli/archive/refs/tags/v3.21.2.tar.gz"
  sha256 "2b930fa5c7cbe50396d147d3cf51f382e8a7312607f9dcefc04a4ad1399f4a46"
  license "GPL-3.0-or-later"

  depends_on "node@18"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    # We have to replace the shebang in the main executable from "/usr/bin/env node"
    rewrite_shebang detected_node_shebang, libexec/"lib/node_modules/@lando/cli/bin/lando"
    bin.install_symlink Dir["#{libexec}/bin/*"]
    system "#{bin}/lando", "config", "--channel=none"
  end

  def caveats
    <<~EOS
      To complete the installation:
        lando setup
    EOS
  end

  test do
    output = shell_output("#{bin}/lando config --path proxyIp")
    assert_match "127.0.0.1", output
  end
end
