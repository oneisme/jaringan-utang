TEMPLATE = aplikasi
TARGET = kredit-qt
macx: TARGET = " Credit-Qt "
VERSION = 0.8.5.1
INCLUDEPATH + = src  src / json  src / qt
QT + = jaringan gui inti  
greaterThan (QT_MAJOR_VERSION, 4): QT + = widget
DEFINES + = QT_GUI  BOOST_THREAD_USE_LIB  BOOST_SPIRIT_THREADSAFE
CONFIG + = no_include_pwd
CONFIG + = utas

# untuk meningkatkan 1,37, tambahkan -mt ke perpustakaan boost
# use: qmake BOOST_LIB_SUFFIX = -mt
# untuk meningkatkan thread win32 dengan _win32 sufix
# use: BOOST_THREAD_LIB_SUFFIX = _win32 -...
# atau ketika menautkan dengan versi BerkelyDB tertentu: BDB_LIB_SUFFIX = -4.8

# Lokasi perpustakaan ketergantungan dapat disesuaikan dengan:
#     BOOST_INCLUDE_PATH, BOOST_LIB_PATH, BDB_INCLUDE_PATH,
#     BDB_LIB_PATH, OPENSSL_INCLUDE_PATH dan OPENSSL_LIB_PATH masing-masing

OBJECTS_DIR = buat
MOC_DIR = build
UI_DIR = build

# use: qmake "RELEASE = 1"
contains ( RELEASE, 1 ) {
    # Mac: kompilasi untuk kompatibilitas maksimum (10.5, 32-bit)
    MacX: QMAKE_CXXFLAGS + = -mmacosx-versi-min = 10,5  arch  i386  -isysroot  /Developer/SDKs/MacOSX10.5.sdk
    MacX: QMAKE_CFLAGS + = -mmacosx-versi-min = 10,5  arch  i386  -isysroot  /Developer/SDKs/MacOSX10.5.sdk
    MacX: QMAKE_OBJECTIVE_CFLAGS + = -mmacosx-versi-min = 10,5  arch  i386  -isysroot  /Developer/SDKs/MacOSX10.5.sdk

    ! win32 :! macx {
        # Linux: tautan statis dan keamanan ekstra (lihat: https://wiki.debian.org/Hardening)
        LIBS + = -Wl , -Bstatic  -Wl , -z , relro  -Wl , -z , sekarang
    }
}

! win32 {
    # untuk keamanan ekstra terhadap potensi buffer overflows: aktifkan GCCs Stack Smashing Protection
    QMAKE_CXXFLAGS * = -fstack-protector-all
    QMAKE_LFLAGS * = -fstack-protector-all
    # Kecualikan pada kompilasi lintas Windows dengan MinGW 4.2.x, karena akan menghasilkan eksekusi yang tidak berfungsi!
    # Ini dapat diaktifkan untuk Windows, ketika kita beralih ke MinGW> = 4.4.x.
}
# untuk keamanan ekstra (lihat: https://wiki.debian.org/Hardening): bendera ini adalah khusus compiler GCC
QMAKE_CXXFLAGS * = -D_FORTIFY_SOURCE = 2
# untuk keamanan ekstra pada Windows: aktifkan ASLR dan DEP melalui flager tautan GCC
win32 : QMAKE_LFLAGS * = -Wl , --dynamicbase  -Wl , --nxcompat
# pada Windows: aktifkan penanda linker sadar alamat GCC yang besar
win32 : QMAKE_LFLAGS * = -Wl , --large-address-aware

# use: qmake "USE_QRCODE = 1"
# libqrencode (http://fukuchi.org/works/qrencode/index.en.html) harus diinstal untuk mendapat dukungan
contains ( USE_QRCODE, 1 ) {
    pesan ( Bangunan dengan dukungan QRCode )
    DEFINES + = USE_QRCODE
    Libs + = -lqrencode
}

# use: qmake "USE_UPNP = 1" (diaktifkan secara default; default)
#   or: qmake "USE_UPNP = 0" (dinonaktifkan secara default)
#   or: qmake "USE_UPNP = -" (tidak didukung)
# miniupnpc (http://miniupnp.free.fr/files/) harus diinstal untuk mendapat dukungan
contains ( USE_UPNP, - ) {
    pesan ( Membangun tanpa dukungan UPNP )
} lain {
    pesan ( Bangunan dengan dukungan UPNP )
    menghitung ( USE_UPNP, 0 ) {
        USE_UPNP = 1
    }
    DEFINES + = USE_UPNP = $$ USE_UPNP  STATICLIB
    INCLUDEPATH + = $$ MINIUPNPC_INCLUDE_PATH
    LIBS + = $$ bergabung ( MINIUPNPC_LIB_PATH ,, -L ,) -lminiupnpc
    win32 : libs + = -liphlpapi
}

# use: qmake "USE_DBUS = 1"
contains ( USE_DBUS, 1 ) {
    pesan ( Membangun dengan dukungan DBUS (Freedesktop notification ))
    DEFINES + = USE_DBUS
    QT + = dbus
}

# use: qmake "USE_IPV6 = 1" (diaktifkan secara default; default)
#   or: qmake "USE_IPV6 = 0" (dinonaktifkan secara default)
#   or: qmake "USE_IPV6 = -" (tidak didukung)
contains ( USE_IPV6, - ) {
    pesan ( Membangun tanpa dukungan IPv6 )
} lain {
    menghitung ( USE_IPV6, 0 ) {
        USE_IPV6 = 1
    }
    DEFINES + = USE_IPV6 = $$ USE_IPV 6
