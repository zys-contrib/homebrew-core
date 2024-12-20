class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-2.13.1.tgz"
  sha256 "a62beb22c694b65ab8fe6f5f818a9ead0c056fa9e42b4aee2f87594d23780bcb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c691402d23e8e072d5451bb45db345828e6e9c1a21053359781017dd419b8022"
    sha256 cellar: :any,                 arm64_sonoma:  "c691402d23e8e072d5451bb45db345828e6e9c1a21053359781017dd419b8022"
    sha256 cellar: :any,                 arm64_ventura: "c691402d23e8e072d5451bb45db345828e6e9c1a21053359781017dd419b8022"
    sha256 cellar: :any,                 sonoma:        "3e8396da68c459472b573330b0d0f8a8e73667f30fe646f2bb38afa70d36d88a"
    sha256 cellar: :any,                 ventura:       "3e8396da68c459472b573330b0d0f8a8e73667f30fe646f2bb38afa70d36d88a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2de6ba4a9873e756686a404c6478c726dba3253a64ce394c5bc7cd2e9c9aac2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end
