class Lla < Formula
  desc "High-performance, extensible alternative to ls"
  homepage "https://github.com/triyanox/lla"
  url "https://github.com/triyanox/lla/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "6fc63f98d4a1da4e6ec231ba17b91b5ca8e472d3aa33fe7ea368c58cd920bf90"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "707b5dafc64e1b2609ea977b3c3257aebc83e25c0bd84a2e36b7a2aef5c4d2ba"
    sha256 cellar: :any,                 arm64_sonoma:  "a380aea3b72d793c764ff101693528a9369bc831778fce1e873be91dc53887c4"
    sha256 cellar: :any,                 arm64_ventura: "75cd897665d5681623403ae103d654815b1c9e0acd7ff88d35bb843bdd2da5ff"
    sha256 cellar: :any,                 sonoma:        "bc60d26fb6254b101d19d0475f99e51880fd754dc835275c4ec9fc3c602023ba"
    sha256 cellar: :any,                 ventura:       "d2674437c54bf7135791f528b5c81faae11440fa8dc5615c4dc96e999e2d603f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecefe7a035fd7efa52309ec690fe14fd4d12e67ec17dddd36b20bdb6f9fe5fdc"
  end

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
      lib.install plugin/"target/release"/shared_library("lib#{plugin.basename}")
    end
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
    inreplace(test_config, /^plugins_dir = ".*"$/, "plugins_dir = \"#{opt_lib}\"")

    system bin/"lla", "--enable-plugin", "git_status", "categorizer"
    system bin/"lla"

    assert_match "lla #{version}", shell_output("#{bin}/lla --version")
  end
end
