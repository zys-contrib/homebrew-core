class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  # TODO: Try removing `bazel@7` workaround whenever new release is available
  url "https://github.com/bazelbuild/bazel/releases/download/8.1.0/bazel-8.1.0-dist.zip"
  sha256 "e08b9137eb85da012afae2d5f34348e5622df273e74d4140e8c389f0ea275f27"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d0e1ab6f5803279244b510d252b7da929451f871dd84bc69089de5399b23170"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "182820919fd8a4729c3769fad482783bc15f42da84b3128d9db5ffec2e6ec900"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3fff3607b0e68a3ef19810fe60418093e9ba3ac59fa6dc1af71a8187ba8c304a"
    sha256 cellar: :any_skip_relocation, sonoma:        "819cc3996a5b758d2ee1892f777c8236849fd480fd9b742d4fb11cf13598fee8"
    sha256 cellar: :any_skip_relocation, ventura:       "d8d1a7f56fd5131c04fdf8c12056dbbee07252f371e0971d684591cec46600cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b464c711857cfa9533e99754eef2a5d2acfd227f992777ac0973d373d6560bfb"
  end

  depends_on "python@3.13" => :build
  depends_on "openjdk@21"

  uses_from_macos "unzip"
  uses_from_macos "zip"

  if DevelopmentTools.clang_build_version >= 1600
    depends_on "bazel@7" => :build

    resource "bazel-src" do
      url "https://github.com/bazelbuild/bazel/archive/refs/tags/8.1.0.tar.gz"
      sha256 "bc2b40c9e4bfe17dd60e2adff47fad75a34788b9b3496e4f8496e3730066db69"

      livecheck do
        formula :parent
      end
    end
  end

  on_linux do
    on_intel do
      # We use a workaround to prevent modification of the `bazel-real` binary
      # but this means brew cannot rewrite paths for non-default prefix
      pour_bottle? only_if: :default_prefix
    end
  end

  conflicts_with "bazelisk", because: "Bazelisk replaces the bazel binary"

  def bazel_real
    libexec/"bin/bazel-real"
  end

  def install
    java_home_env = Language::Java.java_home_env("21")

    ENV["EMBED_LABEL"] = "#{version}-homebrew"
    # Force Bazel ./compile.sh to put its temporary files in the buildpath
    ENV["BAZEL_WRKDIR"] = buildpath/"work"
    # Force Bazel to use brew OpenJDK
    extra_bazel_args = ["--tool_java_runtime_version=local_jdk"]
    ENV.merge! java_home_env.transform_keys(&:to_s)
    # Bazel clears environment variables which breaks superenv shims
    ENV.remove "PATH", Superenv.shims_path

    # Set dynamic linker similar to cc shim so that bottle works on older Linux
    if OS.linux? && build.bottle? && ENV["HOMEBREW_DYNAMIC_LINKER"]
      extra_bazel_args << "--linkopt=-Wl,--dynamic-linker=#{ENV["HOMEBREW_DYNAMIC_LINKER"]}"
    end
    ENV["EXTRA_BAZEL_ARGS"] = extra_bazel_args.join(" ")

    (buildpath/"sources").install buildpath.children

    cd "sources" do
      if DevelopmentTools.clang_build_version >= 1600
        # Work around an error which is seen bootstrapping Bazel 8 on newer Clang
        # from the `-fmodules-strict-decluse` set by `layering_check`:
        #
        #   external/abseil-cpp+/absl/container/internal/raw_hash_set.cc:26:10: error:
        #   module abseil-cpp+//absl/container:raw_hash_set does not depend on a module
        #   exporting 'absl/base/internal/endian.h'
        #
        # TODO: Try removing when newer versions of dependencies (e.g. abseil-cpp >= 20250127.0)
        # are available in https://github.com/bazelbuild/bazel/blob/#{version}/MODULE.bazel

        # The dist zip lacks some files to build directly with Bazel
        odie "Resource bazel-src needs to be updated!" if resource("bazel-src").version != version
        rm_r(Pathname.pwd.children)
        resource("bazel-src").stage(Pathname.pwd)
        rm(".bazelversion")

        extra_bazel_args += %W[
          --compilation_mode=opt
          --stamp
          --embed_label=#{ENV["EMBED_LABEL"]}
        ]
        system Formula["bazel@7"].bin/"bazel", "build", *extra_bazel_args, "//src:bazel_nojdk"
        Pathname("output").install "bazel-bin/src/bazel_nojdk" => "bazel"
      else
        system "./compile.sh"
      end

      system "./output/bazel", "--output_user_root=#{buildpath}/output_user_root",
                               "build",
                               "scripts:bash_completion",
                               "scripts:fish_completion"

      bin.install "scripts/packages/bazel.sh" => "bazel"
      ln_s bazel_real, bin/"bazel-#{version}"
      (libexec/"bin").install "output/bazel" => "bazel-real"
      bin.env_script_all_files libexec/"bin", java_home_env

      bash_completion.install "bazel-bin/scripts/bazel-complete.bash" => "bazel"
      zsh_completion.install "scripts/zsh_completion/_bazel"
      fish_completion.install "bazel-bin/scripts/bazel.fish"
    end

    # Workaround to avoid breaking the zip-appended `bazel-real` binary.
    # Can remove if brew correctly handles these binaries or if upstream
    # provides an alternative in https://github.com/bazelbuild/bazel/issues/11842
    if OS.linux? && build.bottle?
      Utils::Gzip.compress(bazel_real)
      bazel_real.write <<~SHELL
        #!/bin/bash
        echo 'ERROR: Need to run `brew postinstall #{name}`' >&2
        exit 1
      SHELL
      bazel_real.chmod 0755
    end
  end

  def post_install
    if File.exist?("#{bazel_real}.gz")
      rm(bazel_real)
      system "gunzip", "#{bazel_real}.gz"
      bazel_real.chmod 0755
    end
  end

  test do
    touch testpath/"WORKSPACE"

    (testpath/"ProjectRunner.java").write <<~JAVA
      public class ProjectRunner {
        public static void main(String args[]) {
          System.out.println("Hi!");
        }
      }
    JAVA

    (testpath/"BUILD").write <<~STARLARK
      java_binary(
        name = "bazel-test",
        srcs = glob(["*.java"]),
        main_class = "ProjectRunner",
      )
    STARLARK

    system bin/"bazel", "build", "//:bazel-test"
    assert_equal "Hi!\n", shell_output("bazel-bin/bazel-test")

    # Verify that `bazel` invokes Bazel's wrapper script, which delegates to
    # project-specific `tools/bazel` if present. Invoking `bazel-VERSION`
    # bypasses this behavior.
    (testpath/"tools/bazel").write <<~SHELL
      #!/bin/bash
      echo "stub-wrapper"
      exit 1
    SHELL
    (testpath/"tools/bazel").chmod 0755

    assert_equal "stub-wrapper\n", shell_output("#{bin}/bazel --version", 1)
    assert_equal "bazel #{version}-homebrew\n", shell_output("#{bin}/bazel-#{version} --version")
  end
end
