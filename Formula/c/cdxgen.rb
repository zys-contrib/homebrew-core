class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-11.4.3.tgz"
  sha256 "a6fb6d13e1e64b9a3dc7a5660f68ad480290534258c980e673fdb0916f7e0e25"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "784390a10fee715583474c6d1066c729a7e69fd263478d0275c7ca9814b78eda"
    sha256 cellar: :any,                 arm64_sonoma:  "66835f2eb762b47bcbd762e22f4b7ad789614fa4e71d522a4cd9f2fa72000146"
    sha256 cellar: :any,                 arm64_ventura: "ac87cb31abefa110c84d5bb5b5490f0250302a4effcdb42fb3cd3a33d6d72117"
    sha256 cellar: :any,                 ventura:       "e1c61aea65c0c38d4e8bf23d31f8ead996e959a5b96e238f70935abc59851266"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36844115f67b6e79995b04030de5c3f4019c61b93592e12ec4955a87e042b99f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b09404d109e1504bbf867dfa83e1dd9904c91168d2594b98342a7d057b6aec13"
  end

  depends_on "dotnet" # for dosai
  depends_on "node"
  depends_on "ruby"
  depends_on "sourcekitten"
  depends_on "sqlite" # needs sqlite3_enable_load_extension
  depends_on "trivy"

  resource "dosai" do
    url "https://github.com/owasp-dep-scan/dosai/archive/refs/tags/v1.0.5.tar.gz"
    sha256 "7fa46508d4ac27203aa4d28da2f24aaca0e1ef7f2ce98a59df8296995c4bd1d7"
  end

  def install
    # https://github.com/CycloneDX/cdxgen/blob/master/lib/managers/binary.js
    # https://github.com/AppThreat/atom/blob/main/wrapper/nodejs/rbastgen.js
    cdxgen_env = {
      RUBY_CMD:         "${RUBY_CMD:-#{Formula["ruby"].opt_bin}/ruby}",
      SOURCEKITTEN_CMD: "${SOURCEKITTEN_CMD:-#{Formula["sourcekitten"].opt_bin}/sourcekitten}",
      TRIVY_CMD:        "${TRIVY_CMD:-#{Formula["trivy"].opt_bin}/trivy}",
    }

    system "npm", "install", "--sqlite=#{Formula["sqlite"].opt_prefix}", *std_npm_args
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files libexec/"bin", cdxgen_env

    # Remove/replace pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@cyclonedx/cdxgen/node_modules"
    cdxgen_plugins = node_modules/"@cyclonedx/cdxgen-plugins-bin-#{os}-#{arch}/plugins"
    rm_r(cdxgen_plugins/"dosai")
    rm_r(cdxgen_plugins/"sourcekitten")
    rm_r(cdxgen_plugins/"trivy")
    # Remove pre-built osquery plugins for macOS arm builds
    rm_r(cdxgen_plugins/"osquery") if OS.mac? && Hardware::CPU.arm?

    resource("dosai").stage do
      ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
      dosai_cmd = "dosai-#{os}-#{arch}"
      dotnet = Formula["dotnet"]
      args = %W[
        --configuration Release
        --framework net#{dotnet.version.major_minor}
        --no-self-contained
        --output #{cdxgen_plugins}/dosai
        --use-current-runtime
        -p:AppHostRelativeDotNet=#{dotnet.opt_libexec.relative_path_from(cdxgen_plugins/"dosai")}
        -p:AssemblyName=#{dosai_cmd}
        -p:DebugType=None
        -p:PublishSingleFile=true
      ]
      system "dotnet", "publish", "Dosai", *args
    end

    # Reinstall for native dependencies
    cd node_modules/"@appthreat/atom-parsetools/plugins/rubyastgen" do
      rm_r("bundle")
      system "./setup.sh"
    end
  end

  test do
    (testpath/"Gemfile.lock").write <<~EOS
      GEM
        remote: https://rubygems.org/
        specs:
          hello (0.0.1)
      PLATFORMS
        arm64-darwin-22
      DEPENDENCIES
        hello
      BUNDLED WITH
        2.4.12
    EOS

    assert_match "BOM includes 1 components and 2 dependencies", shell_output("#{bin}/cdxgen -p")

    assert_match version.to_s, shell_output("#{bin}/cdxgen --version")
  end
end
