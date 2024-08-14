class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v3.12.2.tar.gz"
  sha256 "8e2e04c2408377d812cc27e2f82861e39418737a6934cb0889b7699324dcec65"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9648282d17238ab7d31d6dc5809b8e2bd91bc6ce1dbeb2437a900b60de709065"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc75029a4b08e5da62fb02f92c41ef953f48073600a9cda8d7abeb6ef436be4d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98e1b136f4324fa12194be6804bc3348acf6949710da68e48f8f6cb20c546241"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd756b85fef2a1a9131ea5679e84d498a5d94951ca20e1efb686ea9a6514d6bd"
    sha256 cellar: :any_skip_relocation, ventura:        "e12ca47f994ffe091df801147b6affdddf452e0a732cdc8f9ebe38993e0dcb44"
    sha256 cellar: :any_skip_relocation, monterey:       "1c34bccaa78246a7bf14f598e356858cce3b2ff43fa042eb34398c7e352d121a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c8087b317c5eca277cedebb6b17697578089be5a3088c4374e3892829e24da5"
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
