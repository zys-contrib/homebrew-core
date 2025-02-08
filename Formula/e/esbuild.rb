class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://github.com/evanw/esbuild/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "c200f558d25a36513b830af8f9a09b5b8924807536f9c3b6b6024c301fee3b2c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36434777bdb8c71a10b067201d782cd61ff20334f57d108fda784f3f5c56afe4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36434777bdb8c71a10b067201d782cd61ff20334f57d108fda784f3f5c56afe4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "36434777bdb8c71a10b067201d782cd61ff20334f57d108fda784f3f5c56afe4"
    sha256 cellar: :any_skip_relocation, sonoma:        "eda813d048b7c8e3567cdd83d8c35a6752f4f5c8a0ea2d57d78d7ce44e0ff1c5"
    sha256 cellar: :any_skip_relocation, ventura:       "eda813d048b7c8e3567cdd83d8c35a6752f4f5c8a0ea2d57d78d7ce44e0ff1c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8b266ad0f0eff10d365e4908096ff12bd2fe99123a1c771815aced51173c400"
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
