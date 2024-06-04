class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v3.8.2.tar.gz"
  sha256 "9138ff447a71220dfd56ce81858d3ee52222cfcaa4313d5bb9eedd610a74d586"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b18f827aa2a96af925a601e924a5ea760ca0f8c64fb2539d1541fb1e4b7b61a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c316724be93199ba06b57a8f38a2d8b61f90c87cab3fadb97b0dc2b155477ffe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65ffe4bbc911a420041c2b416f0e3243904259746f7400589436e6fb36beb996"
    sha256 cellar: :any_skip_relocation, sonoma:         "a2b2f01b19df1011b959d2970d4d59f04686b7313a3e08eed369a179bdc964e1"
    sha256 cellar: :any_skip_relocation, ventura:        "af806d8dd32e27401e522fef5272b27929a50b40a91d493bb6662e78e72695b9"
    sha256 cellar: :any_skip_relocation, monterey:       "3963c2ade7cae8a9e8e4dbd630b419ca0f192dc71d34adf9bd2fd504c13c4519"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2f3e7d196b3d92688f11350cb3e2c60fe437046e1cc0d360b4b6fb7a5109cab"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railwayapp #{version}", shell_output("#{bin}/railway --version").chomp
  end
end
