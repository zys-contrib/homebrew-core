class Krep < Formula
  desc "High-Performance String Search Utility"
  homepage "https://davidesantangelo.github.io/krep/"
  url "https://github.com/davidesantangelo/krep/archive/refs/tags/v0.3.7.tar.gz"
  sha256 "ff7f051c5bf9a2b5178ae79ae7144459569f23cbae37a548825dbc262091f7ba"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96e401b9d3d87fcc4224981f9b3d40850de7ef87ba0d501f87cf645657fcc265"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c7e72c36436357fcb5d95023cd8604857cd33c0a6554a4b086f5313a72d503f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "022acac0980768e4e1e69a88e0e71e36e4200fcdaaeb02b3215850100ad25ed8"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d605668f58e285e2edd74fc3daaa247ff7f1e9bfd3d48d4352aeac7b0c915eb"
    sha256 cellar: :any_skip_relocation, ventura:       "a6ff32a1b743729c0f1ff3f0bce7a25f41d0631c2399d12b923275c22947d001"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9aae6119814bde3f06714acd6f6ea45fcbb494a574d17e76e693ab4c0437f25c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "205331eaae7c0efe533dc411cf657c2812cdb507c8fe8aff91dfa22d24ecf67b"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/krep -v", 1)

    text_file = testpath/"file.txt"
    text_file.write "This should result in one match"

    output = shell_output("#{bin}/krep -c 'match' #{text_file}").strip
    assert_match "1", output
  end
end
