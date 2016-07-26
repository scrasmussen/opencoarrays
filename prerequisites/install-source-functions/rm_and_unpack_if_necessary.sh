# Unpack if the unpacked tar ball is not in the present working directory
# shellcheck disable=SC2154
rm_and_unpack_if_necessary()
{
  if [[ "${fetch}" == "svn" || "${fetch}" == "git" ]]; then
    package_source_directory="${version_to_build}"
  else
    info "Unpacking ${url_tail}."
    info "pushd ${download_path}"
    pushd "${download_path}"
    subpackage_list="aterm-2.6 sdf2-bundle-2.6 strategoxt-0.17"
    for subpackage in "${subpackage_list[@]}"
    do
	info "rm -rf ${subpackage}"
	rm -rf ${subpackage}
    done 
    info "Unpack command: tar zxf ${url_tail}"
    tar zxf "${url_tail}"
    info "popd"
    popd
    # shellcheck disable=SC2034
    package_source_directory="${package_name}-${version_to_build}"
  fi
}
