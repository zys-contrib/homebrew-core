class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.77.6.tgz"
  sha256 "faecc5e299051b7b5d4635a9c9d0b723e09a75895937483e1b1ea931f1d1e682"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6cd21192750835acdb39dfc5b2cebc8d68d35ffdfe466e671fef2bc5fd02f42c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6cd21192750835acdb39dfc5b2cebc8d68d35ffdfe466e671fef2bc5fd02f42c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6cd21192750835acdb39dfc5b2cebc8d68d35ffdfe466e671fef2bc5fd02f42c"
    sha256 cellar: :any_skip_relocation, sonoma:         "6cd21192750835acdb39dfc5b2cebc8d68d35ffdfe466e671fef2bc5fd02f42c"
    sha256 cellar: :any_skip_relocation, ventura:        "6cd21192750835acdb39dfc5b2cebc8d68d35ffdfe466e671fef2bc5fd02f42c"
    sha256 cellar: :any_skip_relocation, monterey:       "6cd21192750835acdb39dfc5b2cebc8d68d35ffdfe466e671fef2bc5fd02f42c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47adf7634f505b0ae06e101b1d2128bc39572aa87d41f96ca5f17091d6305022"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.scss").write <<~EOS
      div {
        img {
          border: 0px;
        }
      }
    EOS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style=compressed test.scss").strip
  end
end
