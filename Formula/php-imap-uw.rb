# typed: true
# frozen_string_literal: true
# fork from https://github.com/shivammathur/homebrew-extensions/blob/master/Formula/imap-uw.rb

class PhpImapUw < Formula
  # This is a fork of imap-uw formula as homebrew/core no longer accepts patches to it.
  desc "University of Washington IMAP toolkit"
  homepage "https://web.archive.org/web/20191028114408/https://www.washington.edu/imap/"
  url "https://mirrorservice.org/sites/ftp.cac.washington.edu/imap/imap-2007f.tar.gz"
  mirror "https://fossies.org/linux/misc/old/imap-2007f.tar.gz"
  sha256 "53e15a2b5c1bc80161d42e9f69792a3fa18332b7b771910131004eb520004a28"
  license "Apache-2.0"
  revision 1

  keg_only "this package contains dependency only"

  livecheck do
    skip "Not maintained"
  end

  depends_on "openssl@3"

  uses_from_macos "krb5"

  on_linux do
    depends_on "linux-pam"

    # Build shared c-client library on Linux.
    patch do
      url "https://salsa.debian.org/holmgren/uw-imap/raw/master/debian/patches/1001_shlibs.patch"
      sha256 "9dfc0eb969e87a12daa50fe7418c9863749abf1ae36bafc7a67d6ba5cba8747e"
    end

    # Use poll instead of select to support more than 1024 file descriptors.
    patch do
      url "https://salsa.debian.org/holmgren/uw-imap/raw/master/debian/patches/1005_poll.patch"
      sha256 "f3460f74308eb9f82ba5d854624a2bbd8a65fb504657a72be147d85aa36af7e1"
    end
  end

  # Correct the order of arguments to syslog.
  patch do
    url "https://salsa.debian.org/holmgren/uw-imap/raw/master/debian/patches/1002_flock_fix_syslog_args.patch"
    sha256 "d3e345f82b73e692fb4072ca5c1afa738e4df9f69a237dd69a030e3bd9b489e6"
  end

  # Properly zero out len when mail_fetch_body() returns an empty string.
  patch do
    url "https://salsa.debian.org/holmgren/uw-imap/raw/master/debian/patches/1003_fix_zero_len_when_mail_fetch_body_is_empty.patch"
    sha256 "b3718b3d645a04d9804ee1239b048693f65669e3070e2d8034ee940ec9f3e5c9"
  end

  # Add support for IMAP extension METADATA (rfc5464).
  patch do
    url "https://salsa.debian.org/holmgren/uw-imap/raw/master/debian/patches/1004_support_rfc5464_METADATA.patch"
    sha256 "5559dbf285e2418ee9483056ba7e933c15bcd6e109747d402ffed4a61eb6f87f"
  end

  # Add support for OpenSSL 1.1.
  patch do
    url "https://salsa.debian.org/holmgren/uw-imap/raw/master/debian/patches/1006_openssl1.1_autoverify.patch"
    sha256 "7c41c4aec4f25546c998593a09386bbb1d6c526ba7d6f65e3f55a17c20644d0a"
  end

  # [CVE-2018-19518] Disable access to IMAP mailboxes through running imapd over rsh.
  patch do
    url "https://salsa.debian.org/holmgren/uw-imap/raw/master/debian/patches/2013_disable_rsh.patch"
    sha256 "1a913ccc0cb22ebfa1d1d3abb04b72d423abd3d7a11c5427bd2bd60075f51467"
  end

  # Add support for TLSv1.3.
  patch do
    url "https://salsa.debian.org/holmgren/uw-imap/raw/master/debian/patches/2014_openssl1.1.1_sni.patch"
    sha256 "9db45ba5462292acd04793ac9fa856e332b37506f1e0991960136dff170a2cd3"
  end

  def add_headers
    # Add missing headers to compile with Xcode 15
    patch_files = Dir["src/c-client/*.h"] + Dir["src/mlock/*.c"]
    header = "
        #include <time.h>
        #include <utime.h>
        #include <unistd.h>
        #include <ctype.h>
        #include <stdio.h>

    "
    File.write("src/c-client/headers.h", header)
    File.write("src/mlock/headers.h", header)

    patch_files.each do |file|
      system "sed -i '' '1s/^/#include \"headers.h\"\\n/' #{file}"
    end
  end

  def install
    ENV.deparallelize

    inreplace "Makefile" do |s|
      s.gsub! "SSLINCLUDE=/usr/include/openssl",
              "SSLINCLUDE=#{Formula["openssl@3"].opt_include}/openssl"
      s.gsub! "SSLLIB=/usr/lib",
              "SSLLIB=#{Formula["openssl@3"].opt_lib}"
      s.gsub! "-DMAC_OSX_KLUDGE=1", ""
    end
    inreplace "src/osdep/unix/Makefile", ".$(VERSION)", "" if OS.linux?
    inreplace "src/osdep/unix/ssl_unix.c", "#include <x509v3.h>\n#include <ssl.h>",
                                           "#include <ssl.h>\n#include <x509v3.h>"

    # Skip IPv6 warning on Linux as libc should be IPv6 safe.
    touch "ip6"

    extra_cflags = []
    # Workaround for Xcode 14.3
    extra_cflags << "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403
    # Workaround for Xcode 15
    extra_cflags << "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    if OS.mac?
      add_headers
      system "make", "oxp", "EXTRACFLAGS=#{extra_cflags.join(" ")}"
    else
      system "make", "ldbs", "EXTRACFLAGS=#{extra_cflags.join(" ")}"
      lib.install "c-client/libc-client.so"
      system "make", "clean"
      system "make", "ldb", "EXTRACFLAGS=#{extra_cflags.join(" ")}"
    end

    # email servers:
    sbin.install "imapd/imapd", "ipopd/ipop2d", "ipopd/ipop3d"

    # mail utilities:
    bin.install "dmail/dmail", "mailutil/mailutil", "tmail/tmail"

    # c-client library:
    #   Note: Installing the headers from the root c-client directory is not
    #   possible because they are symlinks and homebrew dutifully copies them
    #   as such. Pulling from within the src dir achieves the desired result.
    doc.install Dir["docs/*"]
    lib.install "c-client/c-client.a" => "libc-client.a"
    (include + "imap").install "c-client/osdep.h", "c-client/linkage.h"
    (include + "imap").install Dir["src/c-client/*.h", "src/osdep/unix/*.h"]
  end
end