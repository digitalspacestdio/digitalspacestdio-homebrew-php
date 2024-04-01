require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php74Intl < AbstractPhp74Extension
  init PHP_VERSION, false
  desc "Wrapper for the ICU library"
  homepage "https://php.net/manual/en/book.intl.php"
  revision PHP_REVISION


  url PHP_SRC_TARBALL
  sha256 PHP_CHECKSUM[:sha256]

  bottle do
    root_url "https://f003.backblazeb2.com/file/homebrew-bottles/php74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05a2f35577a92d01f434cbf34ab880248020387715c0785cdbd14fc50891cdf2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "df5203422be9cd5e369f7bef2c585ee0138dd78c3be4cac942f25adb27d646be"
    sha256 cellar: :any_skip_relocation, monterey:      "47e5210e9e0adb6e81f723540f564285f4d580eb487bb0139d4f9fe3b0c17d16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdb24f0de5e3bc496fb809ef73d3ae90ac79b6a58a893fd25f644a0489e27273"
  end

  depends_on "digitalspacestdio/common/icu4c@73.2"
  depends_on "pkg-config" => :build

  def install
    # icu4c 61.1 compatability
    ENV.append "CPPFLAGS", "-DU_USING_ICU_NAMESPACE=1"
    ENV.append "LDFLAGS", "-L#{Formula["digitalspacestdio/common/icu4c@73.2"].opt_prefix}/lib"
    ENV.append "CPPFLAGS", "-I#{Formula["digitalspacestdio/common/icu4c@73.2"].opt_prefix}/include"
    
    Dir.chdir "ext/intl"

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig,
                          "--disable-dependency-tracking",
                          "--enable-intl"
    system "make"
    prefix.install "modules/intl.so"
    write_config_file if build.with? "config-file"
  end

  def config_file
    super + <<~EOS

      ;intl.default_locale =
      ; This directive allows you to produce PHP errors when some error
      ; happens within intl functions. The value is the level of the error produced.
      ; Default is 0, which does not produce any errors.
      ;intl.error_level = E_WARNING
    EOS
  end
end
