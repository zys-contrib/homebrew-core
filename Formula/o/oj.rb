class Oj < Formula
  desc "JSON parser and visualization tool"
  homepage "https://github.com/ohler55/ojg"
  url "https://github.com/ohler55/ojg/archive/refs/tags/v1.26.8.tar.gz"
  sha256 "94fbca185bb38989b7b3345da76a29bfd7fa5c984226aded967856ed34e25640"
  license "MIT"
  head "https://github.com/ohler55/ojg.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d9e86dc9a78a0dc063e019ff7fc58f6fccb3f71d88d6a52cfa064b7c22711e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d9e86dc9a78a0dc063e019ff7fc58f6fccb3f71d88d6a52cfa064b7c22711e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2d9e86dc9a78a0dc063e019ff7fc58f6fccb3f71d88d6a52cfa064b7c22711e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "a904cf940cdf2f1f66e00303c2b74c9fa0b48853a8108de83f66cbd4008c0e22"
    sha256 cellar: :any_skip_relocation, ventura:       "a904cf940cdf2f1f66e00303c2b74c9fa0b48853a8108de83f66cbd4008c0e22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bd99a97c0a256b47ad203cf55d7927b81035961f8f50e912f0f344086f3c428"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "925ff17621d79bbb188319c424a24f3a93f79865f0feef9c945108e4ce9df875"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), "./cmd/oj"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/oj -z @.x", "{x:1,y:2}")
  end
end
