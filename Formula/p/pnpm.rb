class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.7.0.tgz"
  sha256 "b35018fbfa8f583668b2649e407922a721355cd81f61beeb4ac1d4258e585559"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "02d90fa5cd08b7996958873ff8f231336486fdd2ec8adbc5d0e8a5c7bfe1432f"
    sha256 cellar: :any,                 arm64_ventura:  "02d90fa5cd08b7996958873ff8f231336486fdd2ec8adbc5d0e8a5c7bfe1432f"
    sha256 cellar: :any,                 arm64_monterey: "02d90fa5cd08b7996958873ff8f231336486fdd2ec8adbc5d0e8a5c7bfe1432f"
    sha256 cellar: :any,                 sonoma:         "a984fbe43f35a573b0240b7fa92bae6a53862436bc42ad43ddd26da83f4d59ae"
    sha256 cellar: :any,                 ventura:        "a984fbe43f35a573b0240b7fa92bae6a53862436bc42ad43ddd26da83f4d59ae"
    sha256 cellar: :any,                 monterey:       "a984fbe43f35a573b0240b7fa92bae6a53862436bc42ad43ddd26da83f4d59ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25ef72ffbdbf5a1a7f53ce523c6804ef8b40e5f3f22501964cf01d431bb3c440"
  end

  depends_on "node" => [:build, :test]

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    generate_completions_from_executable(bin/"pnpm", "completion")

    # remove non-native architecture pre-built binaries
    (libexec/"lib/node_modules/pnpm/dist").glob("reflink.*.node").each do |f|
      next if f.arch == Hardware::CPU.arch

      rm f
    end
  end

  def caveats
    <<~EOS
      pnpm requires a Node installation to function. You can install one with:
        brew install node
    EOS
  end

  test do
    system bin/"pnpm", "init"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
