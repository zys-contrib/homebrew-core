class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v3.9.0.tar.gz"
  sha256 "583da50dde457c4ab4f1bfce0d4c0bd23565d26d9e0f8be1cd2530ae6c8b1042"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "93b80c5465bb272afb23e1b635592045bbe7c2ff6327cc1817b4e2930d5a9f2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f7093aa3e49601e7cfe6d69f5e1ab6f4b3eb3fed6cd62ce692aae56e3934c01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "197c4c1bbbf1c980d7337b67de984031199752202d35ebb730381217f3f84c6e"
    sha256 cellar: :any_skip_relocation, sonoma:         "da1d26f175ca5517bbaa1989ed3c669edb1c648fd93ac84ef85ecdd4fb3b30e6"
    sha256 cellar: :any_skip_relocation, ventura:        "21b1812ca91fbca5ac10457556c4941d62cfc7e3871db54d5ea53c6f4edd22a6"
    sha256 cellar: :any_skip_relocation, monterey:       "a3290f82947bb3c3f855d633cb10cd1b0b70a16329c7fe9161a6a2f2e838cdc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "384de97fb8c03004f190b46b7d4d85c026487da1f8d397fb12fec4744232d1a2"
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
