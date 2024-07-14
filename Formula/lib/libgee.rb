class Libgee < Formula
  desc "Collection library providing GObject-based interfaces"
  homepage "https://wiki.gnome.org/Projects/Libgee"
  url "https://download.gnome.org/sources/libgee/0.20/libgee-0.20.6.tar.xz"
  sha256 "1bf834f5e10d60cc6124d74ed3c1dd38da646787fbf7872220b8b4068e476d4d"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "101f70ccbc7358b45e29cdf31cba5941089dda1ea52ed1158ce442afec8175ba"
    sha256 cellar: :any,                 arm64_ventura:  "17b6833c15dcc5a55942ab6efcb13aec78855da1f7caadeb813bdbaf86936990"
    sha256 cellar: :any,                 arm64_monterey: "f4d10b610efe36fcda4140bf67fd793928ab78ee1e1504d3ea41b568ad7de726"
    sha256 cellar: :any,                 arm64_big_sur:  "e68e6466bdb5bd784e482f38187977b844eebde81dc73bff222172d7a2f4a80a"
    sha256 cellar: :any,                 sonoma:         "ca981251c8491963f8af017b9d09abda3f29fa7b621f7032e50a3090efeec4f1"
    sha256 cellar: :any,                 ventura:        "776df5810ebd490091f65aefe8b4f2157fd70670aeb09b940466cfddf09b292d"
    sha256 cellar: :any,                 monterey:       "a7b8c8955ee24c3ec80eeb037ea5f8dafde3fd8070c3db61a45c271530b78e5d"
    sha256 cellar: :any,                 big_sur:        "b9c9f8e2f261e7694ce63061bbf46264392493615cc470b243720a4ae2c7d6ae"
    sha256 cellar: :any,                 catalina:       "859c21092eaf6cb269f2f5f65e7f5a441eb3a73a21abc0bc00a8a103e3413e4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6268b9a5755df29c908c02893e7c784e6f37a4f340ae4bc4b17cf05ef8114b6e"
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build

  depends_on "glib"

  on_macos do
    depends_on "gettext"
  end

  # incompatible function pointer types build patch
  # upstream bug report, https://gitlab.gnome.org/GNOME/libgee/-/issues/47
  patch :DATA

  def install
    # ensures that the gobject-introspection files remain within the keg
    inreplace "gee/Makefile.in" do |s|
      s.gsub! "@HAVE_INTROSPECTION_TRUE@girdir = @INTROSPECTION_GIRDIR@",
              "@HAVE_INTROSPECTION_TRUE@girdir = $(datadir)/gir-1.0"
      s.gsub! "@HAVE_INTROSPECTION_TRUE@typelibdir = @INTROSPECTION_TYPELIBDIR@",
              "@HAVE_INTROSPECTION_TRUE@typelibdir = $(libdir)/girepository-1.0"
    end

    system "./configure", *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gee.h>

      int main(int argc, char *argv[]) {
        GType type = gee_traversable_stream_get_type();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/gee-0.8
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lgee-0.8
      -lglib-2.0
      -lgobject-2.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/gee/hashmap.c b/gee/hashmap.c
index a9aabdf..7e7e278 100644
--- a/gee/hashmap.c
+++ b/gee/hashmap.c
@@ -4086,7 +4086,7 @@ gee_hash_map_map_iterator_gee_map_iterator_interface_init (GeeMapIteratorIface *
 	iface->next = (gboolean (*) (GeeMapIterator*)) gee_hash_map_node_iterator_next;
 	iface->has_next = (gboolean (*) (GeeMapIterator*)) gee_hash_map_node_iterator_has_next;
 	iface->get_mutable = gee_hash_map_map_iterator_real_get_mutable;
-	iface->get_read_only = gee_hash_map_map_iterator_real_get_read_only;
+	iface->get_read_only = (gboolean (*) (GeeMapIterator*)) gee_hash_map_map_iterator_real_get_read_only;
 	iface->get_valid = (gboolean (*) (GeeMapIterator *)) gee_hash_map_node_iterator_get_valid;
 }

diff --git a/gee/treemap.c b/gee/treemap.c
index af3233b..40504b8 100644
--- a/gee/treemap.c
+++ b/gee/treemap.c
@@ -13955,7 +13955,7 @@ gee_tree_map_map_iterator_gee_map_iterator_interface_init (GeeMapIteratorIface *
 	iface->next = (gboolean (*) (GeeMapIterator*)) gee_tree_map_node_iterator_next;
 	iface->has_next = (gboolean (*) (GeeMapIterator*)) gee_tree_map_node_iterator_has_next;
 	iface->unset = (void (*) (GeeMapIterator*)) gee_tree_map_node_iterator_unset;
-	iface->get_read_only = gee_tree_map_map_iterator_real_get_read_only;
+	iface->get_read_only = (gboolean (*) (GeeMapIterator*)) gee_tree_map_map_iterator_real_get_read_only;
 	iface->get_mutable = gee_tree_map_map_iterator_real_get_mutable;
 	iface->get_valid = (gboolean (*) (GeeMapIterator *)) gee_tree_map_node_iterator_get_valid;
 }
@@ -14320,7 +14320,7 @@ gee_tree_map_sub_map_iterator_gee_map_iterator_interface_init (GeeMapIteratorIfa
 	iface->next = (gboolean (*) (GeeMapIterator*)) gee_tree_map_sub_node_iterator_next;
 	iface->has_next = (gboolean (*) (GeeMapIterator*)) gee_tree_map_sub_node_iterator_has_next;
 	iface->unset = (void (*) (GeeMapIterator*)) gee_tree_map_sub_node_iterator_unset;
-	iface->get_read_only = gee_tree_map_sub_map_iterator_real_get_read_only;
+	iface->get_read_only = (gboolean (*) (GeeMapIterator*)) gee_tree_map_sub_map_iterator_real_get_read_only;
 	iface->get_mutable = gee_tree_map_sub_map_iterator_real_get_mutable;
 	iface->get_valid = (gboolean (*) (GeeMapIterator *)) gee_tree_map_sub_node_iterator_get_valid;
 }
diff --git a/tests/testcase.c b/tests/testcase.c
index 18fdf82..9d6420e 100644
--- a/tests/testcase.c
+++ b/tests/testcase.c
@@ -278,7 +278,7 @@ gee_test_case_add_test (GeeTestCase* self,
 	_tmp3_ = self->priv->suite;
 	_tmp4_ = gee_test_case_adaptor_get_name (adaptor);
 	_tmp5_ = _tmp4_;
-	_tmp6_ = g_test_create_case (_tmp5_, (gsize) 0, adaptor, _gee_test_case_adaptor_set_up_gtest_fixture_func, _gee_test_case_adaptor_run_gtest_fixture_func, _gee_test_case_adaptor_tear_down_gtest_fixture_func);
+	_tmp6_ = g_test_create_case (_tmp5_, (gsize) 0, adaptor, (GTestFixtureFunc *) _gee_test_case_adaptor_set_up_gtest_fixture_func, (GTestFixtureFunc *) _gee_test_case_adaptor_run_gtest_fixture_func, (GTestFixtureFunc *) _gee_test_case_adaptor_tear_down_gtest_fixture_func);
 	g_test_suite_add (_tmp3_, _tmp6_);
 	_gee_test_case_adaptor_unref0 (adaptor);
 	(test_target_destroy_notify == NULL) ? NULL : (test_target_destroy_notify (test_target), NULL);
