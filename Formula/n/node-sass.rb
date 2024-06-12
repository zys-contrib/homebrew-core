class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.77.5.tgz"
  sha256 "58613b1270df073161680c2382aa5e8930ccd129357c7c27321a7ecbd1501667"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e2d0a6c20056e442bd0188668ef47554169acc7bdd591381171c4611597c7edf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2d0a6c20056e442bd0188668ef47554169acc7bdd591381171c4611597c7edf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2d0a6c20056e442bd0188668ef47554169acc7bdd591381171c4611597c7edf"
    sha256 cellar: :any_skip_relocation, sonoma:         "e2d0a6c20056e442bd0188668ef47554169acc7bdd591381171c4611597c7edf"
    sha256 cellar: :any_skip_relocation, ventura:        "e2d0a6c20056e442bd0188668ef47554169acc7bdd591381171c4611597c7edf"
    sha256 cellar: :any_skip_relocation, monterey:       "e2d0a6c20056e442bd0188668ef47554169acc7bdd591381171c4611597c7edf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5528b2cd9feb86ca163fc89707b8de1f3581d944d39ddb39f7e1d0992be876d1"
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
