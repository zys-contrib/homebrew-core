require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.22.0.tgz"
  sha256 "d2fdfc644300b103561c166cdcd22f0e7cb8fe046b40055a5e10f8e8e6eb3d3b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e08e497ba3d2a085c22e0815f63e8d5612c26e6f71979e60b2b28a37e5d3524"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e08e497ba3d2a085c22e0815f63e8d5612c26e6f71979e60b2b28a37e5d3524"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e08e497ba3d2a085c22e0815f63e8d5612c26e6f71979e60b2b28a37e5d3524"
    sha256 cellar: :any_skip_relocation, sonoma:         "29310f2cc821e58d256502f474e85855c9d5ff192cb0fba55a433432c66ae386"
    sha256 cellar: :any_skip_relocation, ventura:        "29310f2cc821e58d256502f474e85855c9d5ff192cb0fba55a433432c66ae386"
    sha256 cellar: :any_skip_relocation, monterey:       "29310f2cc821e58d256502f474e85855c9d5ff192cb0fba55a433432c66ae386"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d4db77aa95ca66c821372df3db87094d7c6a6322a6cd12fa02e78c6ad5b1856"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"app.jsx").write <<~EOS
      import * as React from 'react'
      import * as Server from 'react-dom/server'

      let Greet = () => <h1>Hello, world!</h1>
      console.log(Server.renderToString(<Greet />))
    EOS

    system Formula["node"].libexec/"bin/npm", "install", "react", "react-dom"
    system bin/"esbuild", "app.jsx", "--bundle", "--outfile=out.js"

    assert_equal "<h1>Hello, world!</h1>\n", shell_output("node out.js")
  end
end
