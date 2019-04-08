require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php56Http < AbstractPhp56Extension
  init
  desc "HTTP extension that provides a convenient set of functionality"
  homepage "https://pecl.php.net/package/pecl_http"
  url "https://github.com/m6w6/ext-http/archive/RELEASE_2_6_0.tar.gz"
  sha256 "1ff7c8d9cbeae67837033ddff7032f4acdd0c7bda3e3f12a1ca80620d949a775"
  head "https://github.com/m6w6/ext-http.git"
  revision 2

s_on "php56-raphf"
  depends_on "php56-propro"
  depends_on "libevent" => :optional
  depends_on "icu4c" => :optional

  # overwrite the config file name to ensure extension is loaded after dependencies
  def config_filename
    "zzz_ext-" + extension + ".ini"
  end

  def install
    ENV.universal_binary if build.universal?

    safe_phpize

    # link in the raphf extension header
    mkdir_p "ext/raphf"
    cp "#{Formula["php56-raphf"].opt_prefix}/include/php_raphf.h", "ext/raphf/php_raphf.h"

    # link in the propro extension header
    mkdir_p "ext/propro"
    cp "#{Formula["php56-propro"].opt_prefix}/include/php_propro.h", "ext/propro/php_propro.h"

    args = []
    args << "--prefix=#{prefix}"
    args << phpconfig
    args << "--with-http-libcurl-dir"
    args << "--with-http-zlib-dir"
    args << "--with-http-libevent-dir=#{Formula["libevent"].opt_prefix}" if build.with? "libevent"
    args << "--with-http-libicu-dir=#{Formula["icu4c"].opt_prefix}" if build.with? "icu4c"

    system "./configure", *args
    system "make"
    prefix.install "modules/http.so"
    write_config_file if build.with? "config-file"

    # remove old configuration file
    rm_f config_scandir_path / "ext-http.ini"
  end
end
