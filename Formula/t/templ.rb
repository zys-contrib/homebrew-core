class Templ < Formula
  desc "Language for writing HTML user interfaces in Go"
  homepage "https://templ.guide"
  url "https://github.com/a-h/templ/archive/refs/tags/v0.3.833.tar.gz"
  sha256 "f9275bff1d92f4342c8337275aba0d5aec567c13747c0eb8ac9c72d6a46c0ec1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a2eaec6fddeb7e06c17eb2c942e31d7f5d3c8e5f6ef4eaf6b55e552c4f558b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a2eaec6fddeb7e06c17eb2c942e31d7f5d3c8e5f6ef4eaf6b55e552c4f558b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0a2eaec6fddeb7e06c17eb2c942e31d7f5d3c8e5f6ef4eaf6b55e552c4f558b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "85497eb8317c3f2a90ef2e161e3d957b300a49d5f89e42f5e37f70b57381a601"
    sha256 cellar: :any_skip_relocation, ventura:       "85497eb8317c3f2a90ef2e161e3d957b300a49d5f89e42f5e37f70b57381a601"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01ff2a7a0d0d716fb364ef4335bbc2055db919b95576e956022f59d25f7dab35"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/templ"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/templ version")

    (testpath/"test.templ").write <<~TEMPL
      package main

      templ Test() {
        <p class="testing">Hello, World</p>
      }
    TEMPL

    output = shell_output("#{bin}/templ generate -stdout -f #{testpath}/test.templ")
    assert_match "func Test() templ.Component {", output
  end
end
