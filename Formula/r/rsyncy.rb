class Rsyncy < Formula
  desc "Status/progress bar for rsync"
  homepage "https://github.com/laktak/rsyncy"
  url "https://github.com/laktak/rsyncy/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "a19136713aee2242bf702dbd9be7a2deb6a94a001910b9a297e236bb00ccac5e"
  license "MIT"
  head "https://github.com/laktak/rsyncy.git", branch: "master"

  depends_on "go" => :build
  depends_on "rsync"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # rsyncy is a wrapper, rsyncy --version will invoke it and show rsync output
    assert_match(/.*rsync.+version.*/, shell_output("#{bin}/rsyncy --version"))

    # test copy operation
    mkdir testpath/"a" do
      mkdir "foo"
      (testpath/"a/foo/one.txt").write <<~EOS
        testing
        testing
        testing
      EOS
      system bin/"rsyncy", "-r", testpath/"a/foo/", testpath/"a/bar/"
      assert_path_exists testpath/"a/bar/one.txt"
    end
  end
end
