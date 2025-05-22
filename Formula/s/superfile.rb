class Superfile < Formula
  desc "Modern and pretty fancy file manager for the terminal"
  homepage "https://superfile.netlify.app/"
  url "https://github.com/yorukot/superfile/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "77fc02ce0ef406fd2e9b42e0746f2282a85b4a148316d274bef3dc6c933127a5"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0dd6f0410cbc113a1f22829e443114edd372b274f5f616a984dcb2fb83c05dd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39cab3c002f3b63407911c092dd7b2457462637dbab763b1e69a976469f43f16"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a84abedc3781dac1eb357d040eb55b8971c8e603bafff50d32bc9bb14caa3e30"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd2eafafbdbb70a43e3aacc4f330e2c42d78aa6b3e6ae1a47efcb951fa1be016"
    sha256 cellar: :any_skip_relocation, ventura:       "e5e8f019844c46f35952bd5d9a282f2f19b7ee25a923e64e5fc501b2c10984a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b4b7c00ec4f53bc75ec0f14fa2c7182edac3a1388aaa0ee6edf2abfd6126eec"
  end

  depends_on "go" => :build

  # Fix to link: duplicated definition of symbol dlopen
  # PR ref: https://github.com/yorukot/superfile/pull/837
  patch do
    url "https://github.com/yorukot/superfile/commit/50a4f662f3cea8ca1cad685a89f5dc2282da5d92.patch?full_index=1"
    sha256 "959fb00c6b3491ac68ca21214139da9415f63f9a47ae44cc70ed9e3e3ce1adea"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"spf")
  end

  test do
    # superfile is a GUI application
    assert_match version.to_s, shell_output("#{bin}/spf -v")
  end
end
