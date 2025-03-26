class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.7.0.tgz"
  sha256 "35cab26953bf90847e798839db58c9a2a82d526b7af179fd2a103c18242cadc6"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f3a079b4fbf63b9998b9ad1b9ebb523dfaed5448ac57c944c6976eeaf9af4d35"
    sha256 cellar: :any,                 arm64_sonoma:  "f3a079b4fbf63b9998b9ad1b9ebb523dfaed5448ac57c944c6976eeaf9af4d35"
    sha256 cellar: :any,                 arm64_ventura: "f3a079b4fbf63b9998b9ad1b9ebb523dfaed5448ac57c944c6976eeaf9af4d35"
    sha256 cellar: :any_skip_relocation, sonoma:        "8441b2a5c37257e6e4362a5fde05bf148a398a1fd79cff1b91ad14fd0d275161"
    sha256 cellar: :any_skip_relocation, ventura:       "8441b2a5c37257e6e4362a5fde05bf148a398a1fd79cff1b91ad14fd0d275161"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a76a27c0cacb931bf31e0bf3ef4f3b588d61e657786ce506b0cb54cae2cb061d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a76a27c0cacb931bf31e0bf3ef4f3b588d61e657786ce506b0cb54cae2cb061d"
  end

  depends_on "node" => [:build, :test]

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
    assert_path_exists testpath/"package.json", "package.json must exist"
  end
end
