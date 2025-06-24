class Checkstyle < Formula
  desc "Check Java source against a coding standard"
  homepage "https://checkstyle.sourceforge.io/"
  url "https://github.com/checkstyle/checkstyle/releases/download/checkstyle-10.26.0/checkstyle-10.26.0-all.jar"
  sha256 "3a881656bdfda16424e423c8228b06ddc62109dbf1ea1da946ef97831d325cb0"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "392847a1ece277befc504c1bbfb9a0c40d90f15ec1c10ba42f39c5199a350b40"
  end

  depends_on "openjdk"

  def install
    libexec.install "checkstyle-#{version}-all.jar"
    bin.write_jar_script libexec/"checkstyle-#{version}-all.jar", "checkstyle"
  end

  test do
    path = testpath/"foo.java"
    path.write "public class Foo{ }\n"

    output = shell_output("#{bin}/checkstyle -c /sun_checks.xml #{path}", 2)
    errors = output.lines.select { |line| line.start_with?("[ERROR] #{path}") }
    assert_match "#{path}:1:17: '{' is not preceded with whitespace.", errors.join(" ")
    assert_equal errors.size, $CHILD_STATUS.exitstatus
  end
end
