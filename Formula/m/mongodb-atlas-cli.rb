class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.42.1.tar.gz"
  sha256 "82a14d31cf35487496467a774bc866f360b0c27a7da7115ebd0df956d4283c09"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "681ede865de7b61159ef32e303ca3ef1d920ec3e78e3720d17c95a0532ae978a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91af0ec24ca4633cef2f6c5d852b2f4c199fce1874b308ef11a5d16fa2ccd84e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e06e9fa2b125bd406d23ae98eaa80a133bc2fdce15ce77d8d65b06d13a9f94d"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d5e7b8008a0590bc246798bd8d1405fc87e44e362b5160a013bc9022529cf84"
    sha256 cellar: :any_skip_relocation, ventura:       "15f086fddc27a4f2da3fde5789fb57ff6f8f06c452d61a9607dcde285e4ee95e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d38a9542d4c3f89e49d654d0564af0882b04e5924b159477f3426f269b5bb891"
  end

  depends_on "go" => :build
  depends_on "mongosh"

  conflicts_with "atlas", "nim", because: "both install `atlas` executable"

  def install
    ENV["ATLAS_VERSION"] = version.to_s
    ENV["MCLI_GIT_SHA"] = "homebrew-release"

    system "make", "build"
    bin.install "bin/atlas"

    generate_completions_from_executable(bin/"atlas", "completion")
  end

  test do
    assert_match "atlascli version: #{version}", shell_output("#{bin}/atlas --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}/atlas projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/atlas config ls")
  end
end
