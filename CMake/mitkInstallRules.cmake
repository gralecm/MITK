MITK_INSTALL(FILES ${MITK_SOURCE_DIR}/mitk.ico )
MITK_INSTALL(FILES ${MITK_SOURCE_DIR}/mitk.bmp )

#STATEMACHINE XML
MITK_INSTALL(FILES ${MITK_SOURCE_DIR}/Core/Code/Interactions/StateMachine.xml )
MITK_INSTALL(FILES ${MITK_SOURCE_DIR}/Config/mitkLevelWindowPresets.xml )
MITK_INSTALL(FILES ${MITK_SOURCE_DIR}/Config/mitkRigidRegistrationPresets.xml )
MITK_INSTALL(FILES ${MITK_SOURCE_DIR}/Config/mitkRigidRegistrationTestPresets.xml )

# Install CTK Qt (designer) plugins
if(MITK_USE_CTK)
  if(EXISTS ${CTK_QTDESIGNERPLUGINS_DIR})
    set(_qtplugin_install_destinations)
    if(MACOSX_BUNDLE_NAMES)
      foreach(bundle_name ${MACOSX_BUNDLE_NAMES})
        list(APPEND _qtplugin_install_destinations
             ${bundle_name}.app/Contents/MacOS/${_install_DESTINATION}/plugins/designer)
      endforeach()
    else()
      list(APPEND _qtplugin_install_destinations bin/plugins/designer)
    endif()

    if(NOT CMAKE_CFG_INTDIR STREQUAL ".")
      set(_matching_pattern_release FILES_MATCHING PATTERN "*Release*")
      set(_matching_pattern_debug FILES_MATCHING PATTERN "*Debug*")
    else()
      set(_matching_pattern_release )
      set(_matching_pattern_debug )
    endif()

    foreach(_qtplugin_install_dir ${_qtplugin_install_destinations})
      install(DIRECTORY ${CTK_QTDESIGNERPLUGINS_DIR}/designer/
              DESTINATION ${_qtplugin_install_dir}
              CONFIGURATIONS Release
              ${_matching_pattern_release}
              )
      install(DIRECTORY ${CTK_QTDESIGNERPLUGINS_DIR}/designer/
              DESTINATION ${_qtplugin_install_dir}
              CONFIGURATIONS Debug
              ${_matching_pattern_debug}
              )
    endforeach()
  endif()
endif()

if(WIN32)
  #DCMTK Dlls install target (shared libs on gcc only)
  if(MINGW AND DCMTK_ofstd_LIBRARY)
    set(_dcmtk_libs
        ${DCMTK_dcmdata_LIBRARY}
        ${DCMTK_dcmimgle_LIBRARY}
        ${DCMTK_dcmnet_LIBRARY}
        ${DCMTK_ofstd_LIBRARY}
       )

    foreach(_dcmtk_lib ${_dcmtk_libs})
      MITK_INSTALL(FILES ${_dcmtk_lib} )
    endforeach()
  endif()

  #BlueBerry
  # Since this file is also included from external projects, you
  # can only use variables which are made available through MITKConfig.cmake
  if(MITK_USE_BLUEBERRY)
    if(MINGW)
      MITK_INSTALL(FILES ${MITK_BINARY_DIR}/bin/plugins/liborg_blueberry_osgi.dll)
    else()
      if(NOT APPLE)
        MITK_INSTALL(FILES ${MITK_BINARY_DIR}/bin/plugins/debug/liborg_blueberry_osgi.dll CONFIGURATIONS Debug)
        MITK_INSTALL(FILES ${MITK_BINARY_DIR}/bin/plugins/release/liborg_blueberry_osgi.dll CONFIGURATIONS Release)
      endif(NOT APPLE)
    endif()
  endif()

  #MinGW dll
  if(MINGW)
    find_library(MINGW_RUNTIME_DLL "mingwm10.dll" HINTS ${CMAKE_FIND_ROOT_PATH}/sys-root/mingw/bin)
    if(MINGW_RUNTIME_DLL)
      MITK_INSTALL(FILES ${MINGW_RUNTIME_DLL} )
    else()
      message(SEND_ERROR "Could not find mingwm10.dll which is needed for a proper install")
    endif()

    find_library(MINGW_GCC_RUNTIME_DLL "libgcc_s_dw2-1.dll" HINTS ${CMAKE_FIND_ROOT_PATH}/sys-root/mingw/bin)
    if(MINGW_GCC_RUNTIME_DLL)
      MITK_INSTALL(FILES ${MINGW_GCC_RUNTIME_DLL} )
    else()
      message(SEND_ERROR "Could not find libgcc_s_dw2-1.dll which is needed for a proper install")
    endif()
  endif()

else()

  #DCMTK Dlls install target (shared libs on gcc only)
  if(DCMTK_ofstd_LIBRARY)
    set(_dcmtk_libs
        ${DCMTK_dcmdata_LIBRARY}
        ${DCMTK_dcmimgle_LIBRARY}
        ${DCMTK_dcmnet_LIBRARY}
        ${DCMTK_ofstd_LIBRARY}
    )
    foreach(_dcmtk_lib ${_dcmtk_libs})
      #MITK_INSTALL(FILES ${_dcmtk_lib} DESTINATION lib)
    endforeach()
  endif()

endif()


