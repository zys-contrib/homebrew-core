class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://github.com/go-nv/goenv/archive/refs/tags/2.2.16.tar.gz"
  sha256 "569edfaed8df3de3e7b3bf871a7aa0688fb8e5562cacc3dc0883637219b260da"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c141eec221b32e0e537fa08e68998eb8f8072b57803255010fdecea72a3240ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c141eec221b32e0e537fa08e68998eb8f8072b57803255010fdecea72a3240ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c141eec221b32e0e537fa08e68998eb8f8072b57803255010fdecea72a3240ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "38dbc41f41239ef0106719ef13e1a76adbf1400b126f6d5a8e6c7bee731067da"
    sha256 cellar: :any_skip_relocation, ventura:       "38dbc41f41239ef0106719ef13e1a76adbf1400b126f6d5a8e6c7bee731067da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c141eec221b32e0e537fa08e68998eb8f8072b57803255010fdecea72a3240ae"
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
