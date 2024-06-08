{ lib, stdenv, fetchFromGitHub, kernel, kmod }:

stdenv.mkDerivation {
  pname = "ms912x-6.1";
  version = "0.1.0-unstable-2024-06-08-${kernel.version}";

  src = fetchFromGitHub {
    owner = "rhgndf";
    repo = "ms912x";
    rev = "9cd83e32a64cfe1395eae1fb418cd7cbf308fc42";
    hash = "";
  };

  hardeningDisable = [ "format" "pic" ];

  preBuild = ''
    substituteInPlace Makefile --replace "modules_install" "INSTALL_MOD_PATH=$out modules_install"
    sed -i '/depmod/d' Makefile
  '';

  nativeBuildInputs = [ kmod ] ++ kernel.moduleBuildDependencies;

  postInstall = ''
    make install-utils PREFIX=$bin
  '';

  outputs = [ "out" "bin" ];

  makeFlags = kernel.makeFlags ++ [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  meta = with lib; {
    description = "Video capture support for devices based on MS2109 and MS2130 chips";
    homepage = "https://github.com/rhgndf/ms912x";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
    outputsToInstall = [ "out" ];
  };
}
