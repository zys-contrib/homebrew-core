class Lla < Formula
  desc "High-performance, extensible alternative to ls"
  homepage "https://github.com/triyanox/lla"
  url "https://github.com/triyanox/lla/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "52b75480f2b83e9c03ba47c768399ed867944ae9795bfd2f7903c634618f04af"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ba19f333759a37e7cef19842272f1c890de7bcf51b9e0ca7fd5326e33af7186b"
    sha256 cellar: :any,                 arm64_sonoma:  "6a27725ab1a0b23ec021c11dfd21763631d115892debe8b97aea61b79520751e"
    sha256 cellar: :any,                 arm64_ventura: "97eb31d52513d3c2044c7b97ddba2fe04cee821139d5a6c4b92309bc9ce309df"
    sha256 cellar: :any,                 sonoma:        "a270bd31e67b377e5f2e20f5af812be172f7a3223958382427906aa14eae42db"
    sha256 cellar: :any,                 ventura:       "d9c08d74ebb33bfd8ba8fd223a6dcece0024abec4363a4518439aa83dde7eafa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98de19e161bee65e88250d332e7432e47a3d7ac1c0b18411b6fed437c4df1695"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "lla")

    (buildpath/"plugins").each_child do |plugin|
      next unless plugin.directory?

      plugin_path = plugin/"Cargo.toml"
      next unless plugin_path.exist?

      system "cargo", "build", "--jobs", ENV.make_jobs.to_s,
                               "--locked", "--lib", "--release",
                               "--manifest-path=#{plugin_path}"
    end
    lib.install Dir["target/release/*.{dylib,so}"]
  end

  def caveats
    <<~EOS
      The Lla plugins have been installed in the following directory:
        #{opt_lib}
    EOS
  end

  test do
    test_config = testpath/".config/lla/config.toml"

    system bin/"lla", "init"

    output = shell_output("#{bin}/lla config")
    assert_match "Current configuration at \"#{test_config}\"", output

    system bin/"lla"

    # test lla plugins
    system bin/"lla", "config", "--set", "plugins_dir", opt_lib

    system bin/"lla", "--enable-plugin", "git_status", "categorizer"
    system bin/"lla"

    assert_match "lla #{version}", shell_output("#{bin}/lla --version")
  end
end
