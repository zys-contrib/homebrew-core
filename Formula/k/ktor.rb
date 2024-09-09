class Ktor < Formula
  desc "Generates Ktor projects through the command-line interface"
  homepage "https://github.com/ktorio/ktor-cli"
  url "https://github.com/ktorio/ktor-cli/archive/refs/tags/0.2.0.tar.gz"
  sha256 "03c7d45cd5c73600fbbd20b194668b3e3844fc77e652394ddd75ad9e19d481c0"
  license "Apache-2.0"
  head "https://github.com/ktorio/ktor-cli.git", branch: "main"

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "github.com/ktorio/ktor-cli/cmd/ktor"
  end

  test do
    assert_match "Ktor CLI version #{version}", shell_output("#{bin}/ktor --version")
    assert_match "Ktor CLI version #{version}", shell_output("#{bin}/ktor version")
    system bin/"ktor", "new", "project"
    assert_path_exists testpath/"project/build.gradle.kts"
    assert_path_exists testpath/"project/settings.gradle.kts"
    assert_path_exists testpath/"project/gradle.properties"
    assert_path_exists testpath/"project/src"
    assert_path_exists testpath/"project/gradle"
  end
end
