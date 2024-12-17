class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-9.5.1.tgz"
  sha256 "1dd66255bdc57f742c091671b2f84f6ee4faca8b9bd967d8528678182cf2a6b5"
  license "ISC"

  bottle do
    sha256 arm64_sequoia: "c6118421b58f3f14972958fe4fff97d486e633899aede9cd4abfd7a35d7a9a5f"
    sha256 arm64_sonoma:  "e5e891e569dbb21b3e28b2aefc24700eed95ac97dfb4d49db162467c42ff2308"
    sha256 arm64_ventura: "c0322f0b6c79f0c72941d7e1a59ab716136298abdd5f003e0cdf17fff6350d4a"
    sha256 sonoma:        "bc923961ae796a43b7f2adf8885c946f8419a0628c286c137dc39cb62ebac1c0"
    sha256 ventura:       "0edccb3453122d52dbd33a30bf052d3d5936e7db01dda63de13fea5a5f7abd36"
  end

  depends_on "node"
  depends_on "terminal-notifier"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_modules = libexec/"lib/node_modules/heroku/node_modules"
    # Remove vendored pre-built binary `terminal-notifier`
    node_notifier_vendor_dir = node_modules/"node-notifier/vendor"
    rm_r(node_notifier_vendor_dir) # remove vendored pre-built binaries

    if OS.mac?
      terminal_notifier_dir = node_notifier_vendor_dir/"mac.noindex"
      terminal_notifier_dir.mkpath

      # replace vendored `terminal-notifier` with our own
      terminal_notifier_app = Formula["terminal-notifier"].opt_prefix/"terminal-notifier.app"
      ln_sf terminal_notifier_app.relative_path_from(terminal_notifier_dir), terminal_notifier_dir
    end

    # Replace universal binaries with their native slices.
    deuniversalize_machos
  end

  test do
    assert_match "Error: not logged in", shell_output("#{bin}/heroku auth:whoami 2>&1", 100)
  end
end
