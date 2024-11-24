class Ipatool < Formula
  desc "CLI tool for searching and downloading app packages from the iOS App Store"
  homepage "https://github.com/majd/ipatool"
  url "https://github.com/majd/ipatool/archive/refs/tags/v2.1.4.tar.gz"
  sha256 "e0e01c88efb94f35a71f664267c6c9ab0e22932804e0af864a0a5cd8d348dbca"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/majd/ipatool/v2/cmd.version=#{version}")

    generate_completions_from_executable(bin/"ipatool", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipatool --version")

    output = shell_output("#{bin}/ipatool auth info 2>&1", 1)
    assert_match "failed to get account", output
  end
end
