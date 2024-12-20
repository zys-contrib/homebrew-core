class Neocmakelsp < Formula
  desc "Another cmake lsp"
  homepage "https://neocmakelsp.github.io/"
  url "https://github.com/neocmakelsp/neocmakelsp/archive/refs/tags/v0.8.14.tar.gz"
  sha256 "b20ab4aead9cfd8b0da40bc5a3ff449dd26a005c771aceb6e5468808321b7bc1"
  license "MIT"
  head "https://github.com/neocmakelsp/neocmakelsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e00c2c40c4c4c74e83f41aa1c6f896f066d8eb06364809a5663d4ba9be7576fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90f24a47ee170122060f7498952bc235226871ac63c98f49ac4b5c06bbb44400"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3bc796d299ad495eca59566212f2fabd9b064a25b96c5bab589dcf26be5f6d42"
    sha256 cellar: :any_skip_relocation, sonoma:        "dcb660ec56a158ec062363e6b1ed419deb4d072a2a6ff6f07ac95ec92b6a92bf"
    sha256 cellar: :any_skip_relocation, ventura:       "f77dc10809c9d20e712516182767b16851a3a4cc00027586b638f43b34e05131"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "496f99a1f07b7a62fc74d3e0db93e4c831bd882ff9fcebd0f492786b5e7b9beb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.cmake").write <<~CMAKE
      cmake_minimum_required(VERSION 3.15)
      project(TestProject)
    CMAKE

    system bin/"neocmakelsp", "format", testpath/"test.cmake"
    system bin/"neocmakelsp", "tree", testpath/"test.cmake"

    version_output = shell_output("#{bin}/neocmakelsp --version")
    assert_match version.major_minor_patch.to_s, version_output
  end
end
