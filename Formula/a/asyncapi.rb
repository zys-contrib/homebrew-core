class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-2.3.1.tgz"
  sha256 "8defa6a195c5c1ba15a386761219fc553fa090b12d531834a866be006e5f47f0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1b314da55dd64c73574a3b7d9feaf9f5ef13d6edcfeda2d81a1106664972c6c6"
    sha256 cellar: :any,                 arm64_ventura:  "1b314da55dd64c73574a3b7d9feaf9f5ef13d6edcfeda2d81a1106664972c6c6"
    sha256 cellar: :any,                 arm64_monterey: "1b314da55dd64c73574a3b7d9feaf9f5ef13d6edcfeda2d81a1106664972c6c6"
    sha256 cellar: :any,                 sonoma:         "ef50523d7fb7bf3ffc52390cd75bfbe41626894768fc0e54becb12f1d2993117"
    sha256 cellar: :any,                 ventura:        "ef50523d7fb7bf3ffc52390cd75bfbe41626894768fc0e54becb12f1d2993117"
    sha256 cellar: :any,                 monterey:       "73b8527d77413c3ae05796d17d9906ac87205302c300308239c72c2cc6b1aa51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "189f883b8a525744b6159180d469b82bed8895dd451e8c5d3473c057e08aed1a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end
