class Geesefs < Formula
  desc "FUSE FS implementation over S3"
  homepage "https://github.com/yandex-cloud/geesefs"
  url "https://github.com/yandex-cloud/geesefs/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "ec4331ab6756f255cfb1d2042696b35bd51600659e43982fef9929f9a96fa503"
  license "Apache-2.0"
  head "https://github.com/yandex-cloud/geesefs.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "geesefs version #{version}", shell_output("#{bin}/geesefs --version 2>&1")
    assert_match "Mount: stat test: no such file or directory", shell_output("#{bin}/geesefs test test 2>&1", 1)
  end
end
