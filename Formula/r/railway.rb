class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v3.9.3.tar.gz"
  sha256 "3ee72e6fb07e28b6f1908624386b7fc89d9da78594028764e21b8b97cf78d8da"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5de696e3464bf52ed7e51e774d2b13deca16c21365ce7e2ef3251a4b382b1f1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0df0b5ef5bbc10f467855311779d601bcd954e3ef33a77e91d0f646d549e5dd6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9427aa722b7acc26b1d9b0497a50257b8bd8c387427fe87ebfd9a03cc5d5bdc8"
    sha256 cellar: :any_skip_relocation, sonoma:         "c893f6cc63ba6ba2d82e785da2b1f7880c043b29a6ef71f41951124397393626"
    sha256 cellar: :any_skip_relocation, ventura:        "65709099f3f26cf9deedcff28f7061b756aef4540cf127dba8a9c6d50b838001"
    sha256 cellar: :any_skip_relocation, monterey:       "3a7638a0d30202c3038ffb7c28c2af21e8e5d2c5e8059e5170fae87edbeea3cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed8275c0b54fa56fd1bbb8f54094025ee1db8f3ad72d12a481ce34c0308e167e"
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
