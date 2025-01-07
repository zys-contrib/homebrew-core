class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-2.14.1.tgz"
  sha256 "e7d8404a30b0980109b1739f8f09f071923af457613b27c9288248f8f812457d"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fbebd2132f9370f34f451660707f8f6ede4ea55bd936d30c59b914977493673f"
    sha256 cellar: :any,                 arm64_sonoma:  "fbebd2132f9370f34f451660707f8f6ede4ea55bd936d30c59b914977493673f"
    sha256 cellar: :any,                 arm64_ventura: "fbebd2132f9370f34f451660707f8f6ede4ea55bd936d30c59b914977493673f"
    sha256                               sonoma:        "1d4f0230c341f4165b71626018642a259a3baeac54064bc3adf2fd4cfe623830"
    sha256                               ventura:       "1d4f0230c341f4165b71626018642a259a3baeac54064bc3adf2fd4cfe623830"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5d669a773da96a54484dcba10a97bffcf08330b399223de9d89ccf8c5b80c08"
  end

  depends_on "node"

  on_linux do
    depends_on "vips"
  end

  def install
    system "npm", "install", *std_npm_args, "--chromedriver-skip-install"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  service do
    run opt_bin/"appium"
    environment_variables PATH: std_service_path_env
    keep_alive true
    error_log_path var/"log/appium-error.log"
    log_path var/"log/appium.log"
    working_dir var
  end

  test do
    output = shell_output("#{bin}/appium server --show-build-info")
    assert_match version.to_s, JSON.parse(output)["version"]

    output = shell_output("#{bin}/appium driver list 2>&1")
    assert_match "uiautomator2", output

    output = shell_output("#{bin}/appium plugin list 2>&1")
    assert_match "images", output

    assert_match version.to_s, shell_output("#{bin}/appium --version")
  end
end
