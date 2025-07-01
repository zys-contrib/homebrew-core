class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.45.1.tar.gz"
  sha256 "04b0c26e8fb2f22d0fbaa1577bf2b5a5e44180936041057098c8b6a0e38ccaea"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "545794ef9fc63c696c4f34cbde57a101978d043d89a94d7d79a38c3fc6e57b6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de21b803093f65b3464d33894b38d59ac27000cd085c482204b75389b1f632a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d64f1c7e28f184d52676d6b7334f33394fd6a4ee87a798f57f3db208f6e058a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf7c341e1c48122398e51db94069869bd75020ef64a739827edbcad21d84c058"
    sha256 cellar: :any_skip_relocation, ventura:       "7a8bed66eb044ffec60efc3f42d97b4ebf958daaa54be4467638fdeef1577390"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b22ba0e16aee84fca808ce0b06e2e8ddd8e6b0d2be86c92179482b3b77e20b2"
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
