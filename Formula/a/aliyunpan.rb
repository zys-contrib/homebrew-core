class Aliyunpan < Formula
  desc "Command-line client tool for Alibaba aDrive disk"
  homepage "https://github.com/tickstep/aliyunpan"
  url "https://github.com/tickstep/aliyunpan/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "8ed4222479ef72f7b63e64a851804a6a9ddb917c20026cdc1255ff0450c1a251"
  license "Apache-2.0"
  head "https://github.com/tickstep/aliyunpan.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c65367c3fb8bd9a0a573d2c1d8bf770e3562a62ddc1bdf9154f9f064d0134999"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c65367c3fb8bd9a0a573d2c1d8bf770e3562a62ddc1bdf9154f9f064d0134999"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c65367c3fb8bd9a0a573d2c1d8bf770e3562a62ddc1bdf9154f9f064d0134999"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a651844e9eba0c66b41200ad77c79c300e7ef6d7b554b0532d397bf4e278ce7"
    sha256 cellar: :any_skip_relocation, ventura:       "5a651844e9eba0c66b41200ad77c79c300e7ef6d7b554b0532d397bf4e278ce7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b7137e52c74a9cbe93ba39c81e1b30fac5f88069b5aaad5fdabed97f36d69ac"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"aliyunpan", "run", "touch", "output.txt"
    assert_path_exists testpath/"output.txt"
  end
end
