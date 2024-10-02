class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://github.com/go-nv/goenv/archive/refs/tags/2.2.6.tar.gz"
  sha256 "2b3d7333bda14e272edc0ffcc8751c8bd2cc5bdf23593702cc88f152792f8fe5"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "da95597e5861adfe4ca3e036318514fb506c3ede13398fef4cc1466f980c0ca0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da95597e5861adfe4ca3e036318514fb506c3ede13398fef4cc1466f980c0ca0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da95597e5861adfe4ca3e036318514fb506c3ede13398fef4cc1466f980c0ca0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da95597e5861adfe4ca3e036318514fb506c3ede13398fef4cc1466f980c0ca0"
    sha256 cellar: :any_skip_relocation, sonoma:         "1b358202e028e4cfdd541f2bb88dd73d56fef0e9298d550bc1b6beb7670e3d80"
    sha256 cellar: :any_skip_relocation, ventura:        "1b358202e028e4cfdd541f2bb88dd73d56fef0e9298d550bc1b6beb7670e3d80"
    sha256 cellar: :any_skip_relocation, monterey:       "1b358202e028e4cfdd541f2bb88dd73d56fef0e9298d550bc1b6beb7670e3d80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da95597e5861adfe4ca3e036318514fb506c3ede13398fef4cc1466f980c0ca0"
  end

  def install
    inreplace_files = [
      "libexec/goenv",
      "plugins/go-build/install.sh",
      "test/goenv.bats",
      "test/test_helper.bash",
    ]
    inreplace inreplace_files, "/usr/local", HOMEBREW_PREFIX

    prefix.install Dir["*"]
    %w[goenv-install goenv-uninstall go-build].each do |cmd|
      bin.install_symlink "#{prefix}/plugins/go-build/bin/#{cmd}"
    end
  end

  test do
    assert_match "Usage: goenv <command> [<args>]", shell_output("#{bin}/goenv help")
  end
end
