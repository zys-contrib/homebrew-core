class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://github.com/php/pie/releases/download/0.13.0/pie.phar"
  sha256 "3e741aed185d842278ec9769730e84670a288482d0a837e46c29e482517876c3"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "924e81ed22bf6031807fff34bb58ae2d6f85b105dcd5d9f2c2d0c285009f0582"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "924e81ed22bf6031807fff34bb58ae2d6f85b105dcd5d9f2c2d0c285009f0582"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "924e81ed22bf6031807fff34bb58ae2d6f85b105dcd5d9f2c2d0c285009f0582"
    sha256 cellar: :any_skip_relocation, sonoma:        "967cf150edcd369fb961412df340fbbcccff93a8b3495d094aee5688c3d73a30"
    sha256 cellar: :any_skip_relocation, ventura:       "967cf150edcd369fb961412df340fbbcccff93a8b3495d094aee5688c3d73a30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34b866e5613091e039a57b839a5a92a7e96f8acc9985e8941fd8ead85021ea61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34b866e5613091e039a57b839a5a92a7e96f8acc9985e8941fd8ead85021ea61"
  end

  depends_on "php"

  def install
    bin.install "pie.phar" => "pie"
    generate_completions_from_executable("php", bin/"pie", "completion")
  end

  test do
    system bin/"pie", "build", "apcu/apcu"
  end
end
