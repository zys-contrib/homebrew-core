class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "3be82f9d7473496edb87240161ff18db1eb12e14db6eee369b8ff904f63f5d55"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc87dbcf3af38c55ea2c89fa6fb2a2ea116cdb8bff19e38939f7aec6512fadae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c26805a2db3a3290af8acf13a99deab24a9546b9af5dfd6ed26aff45fccb2888"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b10f518517db6d954060fc37d29012fca08f483e05db4c362f654dd79b1f4cc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a10748435bbcd4a562da9412a4845fa760ee9c585878f4702666a87ede1e706c"
    sha256 cellar: :any_skip_relocation, ventura:       "eba1aa511c8a5ddf5506d9fa4cf5580a55e3a11e9363397ff22655614c97057e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d70bebc76227aed3b86755c18c87dfbce4fb9796d95212b3b6c78f9ab3e7333"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    if OS.mac?
      output = shell_output(bin/"steampipe service status 2>&1", 255)
      assert_match "Error: could not create logs directory", output
    else # Linux
      output = shell_output(bin/"steampipe service status 2>&1")
      assert_match "Steampipe service is not installed", output
    end
    assert_match "Steampipe v#{version}", shell_output(bin/"steampipe --version")
  end
end
