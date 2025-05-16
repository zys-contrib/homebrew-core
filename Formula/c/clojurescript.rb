class Clojurescript < Formula
  desc "Clojure to JS compiler"
  homepage "https://github.com/clojure/clojurescript"
  url "https://github.com/clojure/clojurescript/releases/download/r1.12.42/cljs.jar"
  sha256 "41ab539bee3904cb0b3ccdf15422f0157701e5c4092f4f65d4b01f367772e4d5"
  license "EPL-1.0"
  head "https://github.com/clojure/clojurescript.git", branch: "master"

  livecheck do
    url :stable
    regex(/r?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1ffb43adb1800fbf4dae1c3bc4c1f858c5aa7188497ee564307e156a151405b5"
  end

  depends_on "openjdk"

  def install
    libexec.install "cljs.jar"
    bin.write_jar_script libexec/"cljs.jar", "cljsc"
  end

  def caveats
    <<~EOS
      This formula is useful if you need to use the ClojureScript compiler directly.
      For a more integrated workflow use Leiningen, Boot, or Maven.
    EOS
  end

  test do
    (testpath/"t.cljs").write <<~CLOJURE
      (ns hello)
      (defn ^:export greet [n]
        (str "Hello " n))
    CLOJURE

    system bin/"cljsc", testpath/"t.cljs"
  end
end
