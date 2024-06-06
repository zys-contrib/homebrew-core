class OpenjdkAT21 < Formula
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.java.net/"
  url "https://github.com/openjdk/jdk21u/archive/refs/tags/jdk-21.0.3-ga.tar.gz"
  sha256 "818e9dee28ae390f2781406d594690fc42bd994d078ad9f8360a4fbca6a3df1f"
  license "GPL-2.0-only" => { with: "Classpath-exception-2.0" }

  livecheck do
    url :stable
    regex(/^jdk[._-]v?(21+(?:\.\d+)*)-ga$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "9a47d5fa08dd6cf6a68ea44cf52e34ce45838927060ea470b3772fe7e210dd8f"
    sha256 cellar: :any, arm64_ventura:  "8e8d2c411193fcd13f2ce05d37e377582d06e1ce7bc1b797918fd650bf51dc5b"
    sha256 cellar: :any, arm64_monterey: "8ef0cb75011a9028acc124906a7561856481e96b3000a371b27179fcae386dcb"
    sha256 cellar: :any, sonoma:         "cf7e20bebe3d0e0d5435bae4fdb09e3739c6349fc438a46e97293edd74b11678"
    sha256 cellar: :any, ventura:        "c160c242dfa792ddb6cdfaaa555b77461a3fdf435fdcc9bdd8b3ab96c078e109"
    sha256 cellar: :any, monterey:       "dee3491fd650e010d8a02ef63ede76db26dc3a06fc232e9e08c14c11b68a2168"
    sha256               x86_64_linux:   "db0b039ffb1accf89552864287bb0e4466d356e0d5f031d8dfb23f8d0ee2d668"
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
  depends_on xcode: :build
  depends_on "giflib"
  depends_on "harfbuzz"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "little-cms2"
  depends_on macos: :catalina

  uses_from_macos "cups"
  uses_from_macos "unzip"
  uses_from_macos "zip"
  uses_from_macos "zlib"

  on_linux do
    depends_on "alsa-lib"
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxi"
    depends_on "libxrandr"
    depends_on "libxrender"
    depends_on "libxt"
    depends_on "libxtst"
  end

  fails_with gcc: "5"

  # From https://jdk.java.net/archive/
  resource "boot-jdk" do
    on_macos do
      on_arm do
        url "https://download.java.net/java/GA/jdk21.0.2/f2283984656d49d69e91c558476027ac/13/GPL/openjdk-21.0.2_macos-aarch64_bin.tar.gz"
        sha256 "b3d588e16ec1e0ef9805d8a696591bd518a5cea62567da8f53b5ce32d11d22e4"
      end
      on_intel do
        url "https://download.java.net/java/GA/jdk21.0.2/f2283984656d49d69e91c558476027ac/13/GPL/openjdk-21.0.2_macos-x64_bin.tar.gz"
        sha256 "8fd09e15dc406387a0aba70bf5d99692874e999bf9cd9208b452b5d76ac922d3"
      end
    end
    on_linux do
      on_arm do
        url "https://download.java.net/java/GA/jdk21.0.2/f2283984656d49d69e91c558476027ac/13/GPL/openjdk-21.0.2_linux-aarch64_bin.tar.gz"
        sha256 "08db1392a48d4eb5ea5315cf8f18b89dbaf36cda663ba882cf03c704c9257ec2"
      end
      on_intel do
        url "https://download.java.net/java/GA/jdk21.0.2/f2283984656d49d69e91c558476027ac/13/GPL/openjdk-21.0.2_linux-x64_bin.tar.gz"
        sha256 "a2def047a73941e01a73739f92755f86b895811afb1f91243db214cff5bdac3f"
      end
    end
  end

  def install
    boot_jdk = buildpath/"boot-jdk"
    resource("boot-jdk").stage boot_jdk
    boot_jdk /= "Contents/Home" if OS.mac?
    java_options = ENV.delete("_JAVA_OPTIONS")

    args = %W[
      --disable-warnings-as-errors
      --with-boot-jdk-jvmargs=#{java_options}
      --with-boot-jdk=#{boot_jdk}
      --with-debug-level=release
      --with-jvm-variants=server
      --with-native-debug-symbols=none
      --with-vendor-bug-url=#{tap.issues_url}
      --with-vendor-name=#{tap.user}
      --with-vendor-url=#{tap.issues_url}
      --with-vendor-version-string=#{tap.user}
      --with-vendor-vm-bug-url=#{tap.issues_url}
      --with-version-build=#{revision}
      --without-version-opt
      --without-version-pre
      --with-giflib=system
      --with-harfbuzz=system
      --with-lcms=system
      --with-libjpeg=system
      --with-libpng=system
      --with-zlib=system
    ]

    ldflags = ["-Wl,-rpath,#{loader_path.gsub("$", "\\$$")}/server"]
    args += if OS.mac?
      ldflags << "-headerpad_max_install_names"

      %W[
        --enable-dtrace
        --with-sysroot=#{MacOS.sdk_path}
      ]
    else
      %W[
        --with-x=#{HOMEBREW_PREFIX}
        --with-cups=#{HOMEBREW_PREFIX}
        --with-fontconfig=#{HOMEBREW_PREFIX}
        --with-freetype=system
        --with-stdc++lib=dynamic
      ]
    end
    args << "--with-extra-ldflags=#{ldflags.join(" ")}"

    system "bash", "configure", *args

    ENV["MAKEFLAGS"] = "JOBS=#{ENV.make_jobs}"
    system "make", "images"

    jdk = libexec
    if OS.mac?
      libexec.install Dir["build/*/images/jdk-bundle/*"].first => "openjdk.jdk"
      jdk /= "openjdk.jdk/Contents/Home"
    else
      libexec.install Dir["build/linux-*-server-release/images/jdk/*"]
    end

    bin.install_symlink Dir[jdk/"bin/*"]
    include.install_symlink Dir[jdk/"include/*.h"]
    include.install_symlink Dir[jdk/"include"/OS.kernel_name.downcase/"*.h"]
    man1.install_symlink Dir[jdk/"man/man1/*"]
  end

  def caveats
    on_macos do
      <<~EOS
        For the system Java wrappers to find this JDK, symlink it with
          sudo ln -sfn #{opt_libexec}/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-21.jdk
      EOS
    end
  end

  test do
    (testpath/"HelloWorld.java").write <<~EOS
      class HelloWorld {
        public static void main(String args[]) {
          System.out.println("Hello, world!");
        }
      }
    EOS

    system bin/"javac", "HelloWorld.java"

    assert_match "Hello, world!", shell_output("#{bin}/java HelloWorld")
  end
end
