class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https://grafana.com"
  # TODO: switch to use go1.23 when 11.3.0 is released
  url "https://github.com/grafana/grafana/archive/refs/tags/v11.2.0.tar.gz"
  sha256 "f1727b5e99183879e30d3ca8393e328f39f6bd8b5a11690e7b6e60081f99bbd9"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/grafana.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "332873b18184ced342369c31dd07727f3ec6fc1299642061e77713dbb7ebfe1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a18a3eba302cc95f5afe3e9bb0492c81f4194b4c8a7ffabbed81d59dce2bd3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "297b2318b5177781fdfc73a5edd58ecaaa7ff9b05634bf0d90aae2a9709454bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "a1ac0c97808edc4a12d92e0192bf4f6fb4de649d9ffd6ac96b111a11fc01b677"
    sha256 cellar: :any_skip_relocation, ventura:        "0d5255b9f03ee2341c266552ccb287ee6a02253ab9934036e5345b79d50e2218"
    sha256 cellar: :any_skip_relocation, monterey:       "2977e546fdf06ab1ebef9b1bc94d4d643459f38b550ff5dd17d166c125166720"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a79b2bef6c8dd7362524b6a6a699053b7d4a9b49c9f26aae3a564c2ddaaf85aa"
  end

  depends_on "corepack" => :build
  depends_on "go@1.22" => :build
  depends_on "node" => :build

  uses_from_macos "python" => :build, since: :catalina
  uses_from_macos "zlib"

  on_linux do
    depends_on "fontconfig"
    depends_on "freetype"
  end

  # update yarn.lock
  patch :DATA

  def install
    ENV["NODE_OPTIONS"] = "--max-old-space-size=8000"
    system "make", "gen-go"
    system "go", "run", "build.go", "build"

    system "yarn", "install"
    system "yarn", "build"

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    bin.install "bin/#{os}-#{arch}/grafana"
    bin.install "bin/#{os}-#{arch}/grafana-cli"
    bin.install "bin/#{os}-#{arch}/grafana-server"

    (etc/"grafana").mkpath
    cp "conf/sample.ini", "conf/grafana.ini.example"
    etc.install "conf/sample.ini" => "grafana/grafana.ini"
    etc.install "conf/grafana.ini.example" => "grafana/grafana.ini.example"
    pkgshare.install "conf", "public", "tools"
  end

  def post_install
    (var/"log/grafana").mkpath
    (var/"lib/grafana/plugins").mkpath
  end

  service do
    run [opt_bin/"grafana", "server",
         "--config", etc/"grafana/grafana.ini",
         "--homepath", opt_pkgshare,
         "--packaging=brew",
         "cfg:default.paths.logs=#{var}/log/grafana",
         "cfg:default.paths.data=#{var}/lib/grafana",
         "cfg:default.paths.plugins=#{var}/lib/grafana/plugins"]
    keep_alive true
    error_log_path var/"log/grafana-stderr.log"
    log_path var/"log/grafana-stdout.log"
    working_dir var/"lib/grafana"
  end

  test do
    require "pty"
    require "timeout"

    # first test
    system bin/"grafana", "server", "-v"

    # avoid stepping on anything that may be present in this directory
    tdir = File.join(Dir.pwd, "grafana-test")
    Dir.mkdir(tdir)
    logdir = File.join(tdir, "log")
    datadir = File.join(tdir, "data")
    plugdir = File.join(tdir, "plugins")
    [logdir, datadir, plugdir].each do |d|
      Dir.mkdir(d)
    end
    Dir.chdir(pkgshare)

    res = PTY.spawn(bin/"grafana", "server",
      "cfg:default.paths.logs=#{logdir}",
      "cfg:default.paths.data=#{datadir}",
      "cfg:default.paths.plugins=#{plugdir}",
      "cfg:default.server.http_port=50100")
    r = res[0]
    w = res[1]
    pid = res[2]

    listening = Timeout.timeout(10) do
      li = false
      r.each do |l|
        if l.include?("HTTP Server Listen")
          li = true
          break
        end
      end
      li
    end

    Process.kill("TERM", pid)
    w.close
    r.close
    listening
  end
end

__END__
diff --git a/yarn.lock b/yarn.lock
index 5f122101..b96cd364 100644
--- a/yarn.lock
+++ b/yarn.lock
@@ -3233,7 +3233,7 @@ __metadata:
   languageName: unknown
   linkType: soft
 
-"@grafana/e2e-selectors@npm:11.2.0, @grafana/e2e-selectors@workspace:*, @grafana/e2e-selectors@workspace:packages/grafana-e2e-selectors":
+"@grafana/e2e-selectors@npm:11.2.0, @grafana/e2e-selectors@npm:^11.0.0, @grafana/e2e-selectors@workspace:*, @grafana/e2e-selectors@workspace:packages/grafana-e2e-selectors":
   version: 0.0.0-use.local
   resolution: "@grafana/e2e-selectors@workspace:packages/grafana-e2e-selectors"
   dependencies:
@@ -3251,17 +3251,6 @@ __metadata:
   languageName: unknown
   linkType: soft
 
-"@grafana/e2e-selectors@npm:^11.0.0":
-  version: 11.1.0
-  resolution: "@grafana/e2e-selectors@npm:11.1.0"
-  dependencies:
-    "@grafana/tsconfig": "npm:^1.3.0-rc1"
-    tslib: "npm:2.6.3"
-    typescript: "npm:5.4.5"
-  checksum: 10/010a32e8b562d0da83b008646b9928a96a79957096eed713aa67b227d8ad6055d22cc0ec26f87fd9839cfb28344d0012f49c3c823defc6e91f4ab05ed7d8c465
-  languageName: node
-  linkType: hard
-
 "@grafana/eslint-config@npm:7.0.0":
   version: 7.0.0
   resolution: "@grafana/eslint-config@npm:7.0.0"
