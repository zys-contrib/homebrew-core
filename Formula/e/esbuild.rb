class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://github.com/evanw/esbuild/archive/refs/tags/v0.24.1.tar.gz"
  sha256 "224b69bbb854e66cfbc9e8a3cf848e1af946bcfbcb3c89cfa9b99e2be63cb334"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b797c7adfed30f66d216f6df5ad1f9262c15f089480631f4b9b2e9869c674ff7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b797c7adfed30f66d216f6df5ad1f9262c15f089480631f4b9b2e9869c674ff7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b797c7adfed30f66d216f6df5ad1f9262c15f089480631f4b9b2e9869c674ff7"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a96020b4917150dcd3bcbe5ce8d8d9310d1325e158c6283b5387be8031e07e1"
    sha256 cellar: :any_skip_relocation, ventura:       "0a96020b4917150dcd3bcbe5ce8d8d9310d1325e158c6283b5387be8031e07e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4af2f4248b67f21f8b7f82f2b3e6df8f74cd1da6a0409ed472e46629ae78f1d3"
  end

  depends_on "go" => :build
  depends_on "node" => :test

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/esbuild"
  end

  test do
    (testpath/"app.jsx").write <<~JS
      import * as React from 'react'
      import * as Server from 'react-dom/server'

      let Greet = () => <h1>Hello, world!</h1>
      console.log(Server.renderToString(<Greet />))
      process.exit()
    JS

    system Formula["node"].libexec/"bin/npm", "install", "react", "react-dom"
    system bin/"esbuild", "app.jsx", "--bundle", "--outfile=out.js"

    assert_equal "<h1>Hello, world!</h1>\n", shell_output("node out.js")
  end
end
