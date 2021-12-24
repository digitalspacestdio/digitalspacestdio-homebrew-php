require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php74Xdebug < AbstractPhp74Extension
  init
  desc "Provides debugging and profiling capabilities."
  homepage "https://xdebug.org"
  url "https://github.com/xdebug/xdebug/tarball/52911afee0d66f4569d71d25bb9532c8fab9d5f5"
  sha256 "bde555d03e9c9b4984aa7b988fedc185259cc1672ec853027aaf0237577374b3"
  head "https://github.com/xdebug/xdebug.git"
  version "3.1.2"
  revision 1

  def extension_type
    "zend_extension"
  end

  def install
    #Dir.chdir "xdebug-#{version}" unless build.head?
    if OS.linux?
    ENV["CC"] = "#{Formula["gcc@9"].opt_prefix}/bin/gcc-9"
    ENV["CXX"] = "#{Formula["gcc@9"].opt_prefix}/bin/g++-9"
    else
    ENV["CC"] = "#{Formula["gcc@10"].opt_prefix}/bin/gcc-10"
    ENV["CXX"] = "#{Formula["gcc@10"].opt_prefix}/bin/g++-10"
    end

    safe_phpize

    system "./configure", "--prefix=#{prefix}",
                          phpconfig,
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-xdebug"
    system "make clean"
    system "make"
    prefix.install "modules/xdebug.so"
    write_config_file if build.with? "config-file"
  end
end
