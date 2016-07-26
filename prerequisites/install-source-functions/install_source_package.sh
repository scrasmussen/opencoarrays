install_source_package()
{
  SUDO=${1}
  install_path="${2}"
  package_to_install="${3}"
  download_path="${4}"
  CFLAGS="" #"-m32"
  if [[ $package_to_install = "aterm-2.6" ]]; then
      info "+++++INSTALLING ATERM+++++"
      info "./configure --prefix=${install_path}/aterm CFLAGS=${CFLAGS}"
      ./configure --prefix=${install_path}/aterm CFLAGS=${CFLAGS}
      info "make; make install"
      make; make install
      info "+++++DONE ATERM+++++"
  elif [[ $package_to_install = "sdf2-bundle-2.6" ]]; then
      info "+++++INSTALLING SDF2+++++"
      info "./configure --prefix=${install_path}/sdf2-bundle with-aterm=${install_path}/aterm CFLAGS=${CFLAGS}"
      ./configure --prefix=${install_path}/sdf2-bundle --with-aterm=${install_path}/aterm CFLAGS=${CFLAGS}
      info "make; make install"
      make; make install
      info "+++++DONE SDF2+++++"
  elif [[ $package_to_install = "strategoxt-0.17" ]]; then
      info "+++++INSTALLING STRATEGOXT+++++"
      info "./configure --prefix=${install_path}/strategoxt --with-sdf=${install_path}/sdf2-bundle with-aterm=${install_path}/aterm CFLAGS=${CFLAGS}"
      ./configure --prefix=${install_path}/strategoxt --with-sdf=${install_path}/sdf2-bundle --with-aterm=${install_path}/aterm CFLAGS=${CFLAGS}
      info "make; make install"
      make; make install
      info "+++++DONE STRATEGOXT+++++"
  else
      emergency "Installation from source failed at configure, make ,make install"
  fi

  echo "exit"
}


install_or_skip_source()
{
  SUDO=${1}
  install_path="${2}"
  package_to_install="${3}"
  download_path="${4}"
  #=== Eventally REMOVE
  rm -rf ${install_path}/${package_to_install}
  #=== end REMOVE
  if [[ -d "${install_path}/${package_to_install}" ]]; then
    info "The following installation path exists:"
    info "${install_path}/${package_to_install}"
    info "If you want to replace it, please remove it and restart this script."
    info "Skipping ${package_to_install} installation."
  else
    # info "Installing ${package_to_install} with the following command:"
    # move to folder to install package
    prerequisites_install_source_dir="${OPENCOARRAYS_SRC_DIR}"/prerequisites/install-source-functions
    info "pushd ${download_path}/${package_to_install}"
    echo '${package_to_install}'
    pushd "${download_path}/${package_to_install}"
    if [[ -x "../${package_to_install}"  ]]; then
      info "Installation complete for ${package_to_install} in the following location:"
      info "${install_path}/${package_to_install}"
    else
      info "Something went wrong.  Either ${package_to_install} is not in the following expected location"
      info "or the user lacks executable permissions for the directory:"
      emergency "${install_path}/${package_to_install}"
    fi
    
    install_list="aterm-2.6 sdf2-bundle-2.6 strategoxt-0.17"
    [[ ${install_list} =~ ${package_to_install} ]] && install_source_package "${SUDO:-}" "${install_path}" "${package_to_install}" "${download_path}"

    info "popd"
    popd

  fi
}

function install_source_packages()
{
  info "Installation package names: ${install_names}"
  package_to_install="${install_names%%,*}" # remove longest back-end match for ,*
  remaining_packages="${install_names#*,}"  # remove shortest front-end match for *,
  if [[ ! -d "${install_path}" ]]; then
    ${SUDO:-} mkdir -p "${install_path}"
  fi
  while [[ "${package_to_install}" != "${remaining_packages}" ]]; do
    install_or_skip_source  "${SUDO:-}" "${install_path}" "${package_to_install}" "${download_path}"
    info "Remaining installation package names:  ${remaining_packages}"
    install_names="${remaining_packages}"
    package_to_install="${install_names%%,*}" # remove longest back-end match for ,*
    remaining_packages="${install_names#*,}"  # remove shortest front-end for *,
  done
  install_or_skip_source  "${SUDO:-}" "${install_path}" "${package_to_install}" "${download_path}"
}
