class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-14.0.0.tgz"
  sha256 "a37f8a84828ab422b236bfdc73db4f4349d02a003d38f3d94a71ede92093939d"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "834e72ecd7ae8c9fa8f9866038bce8776b1d49795454a66a4fe765a124d28a19"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "834e72ecd7ae8c9fa8f9866038bce8776b1d49795454a66a4fe765a124d28a19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "834e72ecd7ae8c9fa8f9866038bce8776b1d49795454a66a4fe765a124d28a19"
    sha256 cellar: :any_skip_relocation, sonoma:         "834e72ecd7ae8c9fa8f9866038bce8776b1d49795454a66a4fe765a124d28a19"
    sha256 cellar: :any_skip_relocation, ventura:        "834e72ecd7ae8c9fa8f9866038bce8776b1d49795454a66a4fe765a124d28a19"
    sha256 cellar: :any_skip_relocation, monterey:       "834e72ecd7ae8c9fa8f9866038bce8776b1d49795454a66a4fe765a124d28a19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f09fd22474380d85a676cbe7ee0fc695d7c5de3670378d8ad831edd6a806f5be"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", pipe_output(bin/"marked", "hello *world*").strip
  end
end
