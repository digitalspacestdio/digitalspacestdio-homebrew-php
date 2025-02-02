require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php83Intl < AbstractPhp83Extension
  init PHP_VERSION, false
  desc "Wrapper for the ICU library"
  homepage "https://php.net/manual/en/book.intl.php"
  revision PHP_REVISION


  url PHP_SRC_URL
  sha256 PHP_CHECKSUM[:sha256]

  bottle do
    root_url "https://pub-7d898cd296ae4a92a616d2e2c17cdb9e.r2.dev/php/8.3.14-106"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5058a40658fa62a7885e69ae1e346096035226d5223886ca65c19624d918a864"
    sha256 cellar: :any_skip_relocation, ventura:       "38911bafb15267765517a54df4aa216739d55230c7bf1a018c1c8a544c932fe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5bd3bb971df62f56fef6a0ae2ee3ec9b34c03410c386079983eeb1482d4fced"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "7a93faf5a7d2b209f2d175c81821fa8339cbbdf614f6ba3d15d8c774fecda0c1"
  end

  depends_on "digitalspacestdio/common/icu4c@74.2"
  depends_on "pkg-config" => :build

  def install
    # Required due to icu4c dependency
    ENV.cxx11

    # icu4c 61.1 compatability
    #ENV.append "CPPFLAGS", "-DU_USING_ICU_NAMESPACE=1"
    
    Dir.chdir "ext/intl"

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig,
                          "--disable-dependency-tracking",
                          "--enable-intl",
                          "--with-icu-dir=#{Formula["digitalspacestdio/common/icu4c@74.2"].opt_prefix}"
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
