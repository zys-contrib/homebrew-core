class Procmail < Formula
  desc "Autonomous mail processor"
  homepage "https://github.com/BuGlessRB/procmail"
  url "https://github.com/BuGlessRB/procmail/archive/refs/tags/v3.24.tar.gz"
  sha256 "514ea433339783e95df9321e794771e4887b9823ac55fdb2469702cf69bd3989"
  license any_of: ["GPL-2.0-or-later", "Artistic-1.0-Perl"]
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3797ccaf0b1d12c6b04012265e1cbad538769cad66d9175e6fb0e8a7e0cfc54d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "791a9a4eb68e2bc3e190dc7ab66efa1c1516abe9457c7a6e00bfca199ae3564a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ebd812ae059d9cfcdc313028d1a967093b2fcb54745308f3ac900f17f850822"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f36e2740c6191a3cc46063e606fa3bf9bd5f5da712e7ef191722ee1ef5c85810"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e39fb3a7e1b24091190e1348b3a0cecf28f189828c5b5b126e3de0bfedaa02ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "4702908a7f5fb3ce9fc5e08ad9d3978c69b2a5cafd5706672550eaf05fd78b8e"
    sha256 cellar: :any_skip_relocation, ventura:        "7b6228407ed3b8ad685845095e0d0ef126cefe4994a2ac87db15c4abc8b6bb23"
    sha256 cellar: :any_skip_relocation, monterey:       "68edea089a8cac07fe73a92c5c31ab7f8a17e4f57affad9acd8cc1d71e2bc8bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "c29ed505600498218a3733d68ebff1eb29c259ac3789da32dc2c76d9aaa33527"
    sha256 cellar: :any_skip_relocation, catalina:       "a7f6ee9550f27ea88322a4c4c88b04421e6d2c676248a914571a2fbffd6d425f"
    sha256 cellar: :any_skip_relocation, mojave:         "48be3e5215b4ac296ef1f9150b313964112e5c7d04fe20489f336342548656e0"
    sha256 cellar: :any_skip_relocation, high_sierra:    "c64920b1989d941d9aa4de7c275cf2e80306cb8bd2ee5d8263e883ddab7ef2e3"
    sha256 cellar: :any_skip_relocation, sierra:         "c64ccf998d9c71d1b73004abe4c96a8c35993cf4c1a899cd6d92bfab82b9272a"
    sha256 cellar: :any_skip_relocation, el_capitan:     "3328bcda4649612afba606950e59f4cb0c22e10fe97a4f1e38f190e3e4115800"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72b9fa811e78c4bbda5b5d1c85493954afacc8382c0e7ce69af5197f4c739279"
  end

  # Apply open PR to fix build on modern Clang/GCC rather than disabling errors.
  # Same patch used by Fedora, Gentoo, MacPorts and NixOS.
  # PR ref: https://github.com/BuGlessRB/procmail/pull/7
  patch do
    url "https://github.com/BuGlessRB/procmail/commit/8cfd570fd14c8fb9983859767ab1851bfd064b64.patch?full_index=1"
    sha256 "2258b13da244b8ffbd242bc2a7e1e8c6129ab2aed4126e3394287bcafc1018e1"
  end

  def install
    # avoid issue from case-insensitive filesystem
    mv "INSTALL", "INSTALL.txt" if OS.mac?

    system "make", "install", "BASENAME=#{prefix}", "MANDIR=#{man}", "LOCKINGTEST=1"
  end

  test do
    path = testpath/"test.mail"
    path.write <<~EOS
      From alice@example.net Tue Sep 15 15:33:41 2015
      Date: Tue, 15 Sep 2015 15:33:41 +0200
      From: Alice <alice@example.net>
      To: Bob <bob@example.net>
      Subject: Test

      please ignore
    EOS
    assert_match "Subject: Test", shell_output("#{bin}/formail -X 'Subject' < #{path}")
    assert_match "please ignore", shell_output("#{bin}/formail -I '' < #{path}")
  end
end
