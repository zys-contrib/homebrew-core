class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/refs/tags/v6.4.0.tar.gz"
  sha256 "edd7591565f199c1365420655a144507bcd2838aed09b79fefdc8b661180432f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ecc57084ae105e0d8068e693cb2b8d8ad97fdf67333fc0b56cb247492bb89dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "401d23f452588558b961d447ba3b55c299ca65748b5e91640868ee48437fd2d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "668fd39b49bb00d25713ecbd78fa7d72b48cb6b4eaa7c90aecfb1598d586a7ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "a77aaa3528f6318829f13cd4105bc61efcf56dab104500d9312c0ea57dd36197"
    sha256 cellar: :any_skip_relocation, ventura:       "4835dc98c9415fdabbf407a14529b2d84cf4b2be4b1412cdbcc47d7e089a50b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4470df67ea312015e1c176847f29fba03c193af0441683a2cec0005313d3594"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "We've collected a total of 19 readouts", shell_output("#{bin}/macchina --doctor")

    assert_match version.to_s, shell_output("#{bin}/macchina --version")
  end
end
