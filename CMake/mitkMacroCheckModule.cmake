# Usage: MITK_CHECK_MODULE(RESULT_VAR [dependencies ...] )
# check if all required modules exist and stores missing module names in RESULT_VAR.
macro(MITK_CHECK_MODULE RESULT_VAR)
  set(${RESULT_VAR} "")
  set(DEPENDS "")
  set(DEPENDS_BEFORE "not initialized")
  set(PACKAGE_DEPENDS "")

  # check for each parameter if it is a package (3rd party)
  foreach(package ${ARGN})
    set(is_package)
    foreach(dir ${MODULES_PACKAGE_DEPENDS_DIRS})
      if(EXISTS "${dir}/MITK_${package}_Config.cmake")
        list(APPEND PACKAGE_DEPENDS ${package})
        set(is_package 1)
        break()
      endif()
    endforeach()
    if(NOT is_package)
      list(APPEND DEPENDS ${package})
    endif()
  endforeach(package)

  while(NOT "${DEPENDS}" STREQUAL "${DEPENDS_BEFORE}")
    set(DEPENDS_BEFORE ${DEPENDS})
    foreach(dependency ${DEPENDS})
      set(_module_found 1)
      if(NOT ${dependency}_CONFIG_FILE)
        set(_module_found 0)
      endif()
      set(_dependency_file_name ${${dependency}_CONFIG_FILE})
      if(NOT EXISTS ${_dependency_file_name})
        set(_module_found 0)
      endif()

      if(_module_found)
        include(${_dependency_file_name})
        if(${dependency}_IS_ENABLED)
          list(APPEND DEPENDS ${${dependency}_DEPENDS})
          list(APPEND PACKAGE_DEPENDS ${${dependency}_PACKAGE_DEPENDS})
        else(${dependency}_IS_ENABLED)
          list(APPEND ${RESULT_VAR} ${dependency})
          list(REMOVE_DUPLICATES ${RESULT_VAR})
        endif(${dependency}_IS_ENABLED)
      else()
        list(APPEND ${RESULT_VAR} ${dependency})
        list(REMOVE_DUPLICATES ${RESULT_VAR})
      endif()

    endforeach(dependency)
    list(REMOVE_DUPLICATES DEPENDS)
    list(REMOVE_DUPLICATES PACKAGE_DEPENDS)
    list(SORT DEPENDS)
    list(SORT PACKAGE_DEPENDS)
  endwhile()

  foreach(_package PACKAGE_DEPENDS)
    if((DEFINED MITK_USE_${_package}) AND NOT (${MITK_USE_${_package}}))
      list(APPEND ${RESULT_VAR} ${_package})
    endif()
  endforeach()

endmacro(MITK_CHECK_MODULE)
