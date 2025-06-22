class Tldx < Formula
  desc "Domain Availability Research Tool"
  homepage "https://brandonyoung.dev/blog/introducing-tldx/"
  url "https://github.com/brandonyoungdev/tldx/archive/refs/tags/v1.2.4.tar.gz"
  sha256 "5bc6836e033ae63187b17e523e808cfd8bb6525715163fdc158bf85f36a2b834"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b41c7f08e210436496144324df9278198b1106b863cf3c3d7bf28ce95ac7b7bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b41c7f08e210436496144324df9278198b1106b863cf3c3d7bf28ce95ac7b7bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b41c7f08e210436496144324df9278198b1106b863cf3c3d7bf28ce95ac7b7bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "48aed93150ea50cc88f7d35c66a88b207262d486203c22e81173d4460e542b80"
    sha256 cellar: :any_skip_relocation, ventura:       "48aed93150ea50cc88f7d35c66a88b207262d486203c22e81173d4460e542b80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b95d2781e50ab796aa41f42f8c897fcc5b6c04a92b956b220bac25ba69b73fa"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "brew.sh is not available", shell_output("#{bin}/tldx brew --tlds sh")
  end
end
