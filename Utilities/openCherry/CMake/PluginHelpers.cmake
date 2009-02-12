# sets name to the plugin-name
# the plugin-name is computed by removing basedir from dir and
# replacing slashes with points
MACRO(CREATE_PLUGIN_NAME name basedir dir)

  #MESSAGE(STATUS "name: ${name}, basedir: ${basedir}, dir: ${dir}")

  STRING(REPLACE "${ARGV1}/" "" PLUGIN_NAME_WITH_SLASHES ${dir})
  #MESSAGE(STATUS "PLUGIN_NAME_WITH_SLASHES: ${PLUGIN_NAME_WITH_SLASHES}")
  STRING(REPLACE "/" "." PLUGIN_NAME_WITH_POINTS ${PLUGIN_NAME_WITH_SLASHES})
  #MESSAGE(STATUS "PLUGIN_NAME_WITH_POINTS: ${PLUGIN_NAME_WITH_POINTS}")

  SET(${name} ${PLUGIN_NAME_WITH_POINTS})
  
ENDMACRO(CREATE_PLUGIN_NAME)


# sets pluginpath to the absolut path of the plugins source directory
#
# pluginname: the unique plugin id (i.e. org.opencherry.osgi)
#
MACRO(FIND_PLUGIN_SRC_PATH pluginpath pluginname)
  
  FOREACH(plugindir ${OPENCHERRY_PLUGIN_SOURCE_DIRS})
    IF(EXISTS ${plugindir}/${ARGV1}/src)
      SET(${pluginpath} ${plugindir}/${ARGV1}/src)
    ELSEIF(EXISTS ${plugindir}/${ARGV1})
      SET(${pluginpath} ${plugindir}/${ARGV1})
    ENDIF(EXISTS ${plugindir}/${ARGV1}/src)
  ENDFOREACH(plugindir ${OPENCHERRY_PLUGIN_SOURCE_DIRS})
  
  #MESSAGE(STATUS "Found plugin src dir: ${${pluginpath}}")

ENDMACRO(FIND_PLUGIN_SRC_PATH)

# sets pluginpath to the absolut path of the plugins binary output directory
#
# pluginname: the unique plugin id (i.e. org.opencherry.osgi)
#
MACRO(FIND_PLUGIN_BIN_PATH pluginpath pluginname)
  
  FOREACH(plugindir ${OPENCHERRY_PLUGIN_BINARY_DIRS})
    IF(EXISTS ${plugindir}/${ARGV1})
      SET(${pluginpath} ${plugindir}/${ARGV1})
    ENDIF(EXISTS ${plugindir}/${ARGV1})
  ENDFOREACH(plugindir ${OPENCHERRY_PLUGIN_BINARY_DIRS})
  
  #MESSAGE(STATUS "Found plugin bin dir: ${${pluginpath}}")

ENDMACRO(FIND_PLUGIN_BIN_PATH)


# Recursively searches for plugins (i.e. directories containing a
# META-INF/MANIFEST.MF file). The macro adds the found directories
# to cmake and stored the plugin-name and absolute path in an
# internal cache variable. 
#
# VARIABLES:
#
# plugin_output_dir is the common output directory for all 
# plugins found. It is available as PLUGINS_OUTPUT_BASE_DIR
# and used by the CREATE_PLUGIN macro.
#
# add_to_plugin_dirs boolean value determining if the plugin_output_dir
# should be added to the OPENCHERRY_PLUGIN_BINARY_DIRS variable. Should be usually
# set to ON
#
# build_all if ON the BUILD_pluginname variables are ignored and all
# plugins under this directory are build
#
MACRO(COLLECT_PLUGINS plugin_output_dir add_to_plugin_dirs build_all)
  
SET(PLUGINS_OUTPUT_BASE_DIR ${plugin_output_dir})
SET(ADD_TO_PLUGIN_DIRS ${add_to_plugin_dirs})
SET(BUILD_ALL_PLUGINS ${build_all})

#MESSAGE(SEND_ERROR "PLUGINS_OUTPUT_BASE_DIR: ${PLUGINS_OUTPUT_BASE_DIR}")
#MESSAGE(SEND_ERROR "ADD_TO_PLUGIN_DIRS: ${ADD_TO_PLUGIN_DIRS}")
#MESSAGE(SEND_ERROR "BUILD_ALL_PLUGINS: ${BUILD_ALL_PLUGINS}")

SET(PLUGINS_SOURCE_BASE_DIR ${CMAKE_CURRENT_SOURCE_DIR})

IF(ADD_TO_PLUGIN_DIRS)
  
  SET(OPENCHERRY_PLUGIN_SOURCE_DIRS ${OPENCHERRY_PLUGIN_SOURCE_DIRS} ${PLUGINS_SOURCE_BASE_DIR}
      CACHE INTERNAL "List of base plugin source directories" FORCE)
  SET(OPENCHERRY_PLUGIN_BINARY_DIRS ${OPENCHERRY_PLUGIN_BINARY_DIRS} ${PLUGINS_OUTPUT_BASE_DIR}
      CACHE INTERNAL "List of base plugin binary directories" FORCE)
  
  #MESSAGE("New OPENCHERRY_PLUGIN_BINARY_DIRS is: ${OPENCHERRY_PLUGIN_BINARY_DIRS}")
  
ENDIF(ADD_TO_PLUGIN_DIRS)

FILE(GLOB all_dirs *)
FOREACH(dir_entry ${all_dirs})
  IF(EXISTS ${dir_entry}/META-INF/MANIFEST.MF)
    SET(plugin_dirs ${plugin_dirs} ${dir_entry})
  ENDIF(EXISTS ${dir_entry}/META-INF/MANIFEST.MF)
ENDFOREACH(dir_entry ${all_dirs})

INCLUDE_DIRECTORIES(${Poco_INCLUDE_DIRS})
LINK_DIRECTORIES(${Poco_LIBRARY_DIR})

FOREACH(plugin_dir ${plugin_dirs}) 
      MESSAGE(STATUS "Processing ${plugin_dir}")
      CREATE_PLUGIN_NAME(PLUGIN_NAME ${PLUGINS_SOURCE_BASE_DIR} ${plugin_dir})
      #MESSAGE(STATUS "PLUGIN_NAME = ${PLUGIN_NAME}")
      OPTION("BUILD_${PLUGIN_NAME}" "Build ${PLUGIN_NAME} Plugin" ON)
      IF(BUILD_${PLUGIN_NAME} OR BUILD_ALL_PLUGINS)
        ADD_SUBDIRECTORY(${plugin_dir})
      ENDIF(BUILD_${PLUGIN_NAME} OR BUILD_ALL_PLUGINS)
ENDFOREACH(plugin_dir)

ENDMACRO(COLLECT_PLUGINS)

MACRO(PLUGIN_ADD_LINK_DIRECTORIES)
  FOREACH(plugin_dependency ${PLUGIN_DEPENDS_ON})
    FIND_PLUGIN_BIN_PATH(plugin_binpath ${plugin_dependency})
    MESSAGE(STATUS "ADDING LINK DIRECTORY: ${plugin_binpath}/bin")
    LINK_DIRECTORIES(${plugin_binpath}/bin)
  ENDFOREACH(plugin_dependency)
ENDMACRO(PLUGIN_ADD_LINK_DIRECTORIES)

# Creates the current plugin.
# This macro should be called from the plugins CMakeLists.txt file. The plugin
# library is build in a subdirectory of PLUGIN_OUTPUT_DIR, which has been set
# by a call to COLLECT_PLUGINS(). The target name is available as PLUGIN_TARGET
# to add additional libraries in your CMakeLists.txt. Include paths are set
# depending on the variable PLUGIN_DEPENDS_ON which contains a list of plugin-names
# from which header files are needed.
#
MACRO(CREATE_PLUGIN)
  IF(MSVC80)
    ADD_DEFINITIONS(-D_CRT_SECURE_NO_WARNINGS -D_CRT_NONSTDC_NO_WARNINGS)
  ENDIF(MSVC80)
  
  CREATE_PLUGIN_NAME(PLUGIN_NAME ${PLUGINS_SOURCE_BASE_DIR} ${CMAKE_CURRENT_SOURCE_DIR})
  
  MESSAGE(STATUS "Creating plugin ${PLUGIN_NAME}")
  
  STRING(REPLACE . _ PLUGIN_TARGET ${PLUGIN_NAME})
  
  IF(NOT PLUGIN_CPP_FILES)
    MESSAGE(STATUS "Using files.cmake for plugin ${PLUGIN_NAME}")
    INCLUDE(files.cmake)
    
    SET(PLUGIN_CPP_FILES ${CPP_FILES})
    SET(PLUGIN_MOC_H_FILES ${MOC_H_FILES})
    SET(PLUGIN_UI_FILES ${UI_FILES})
    SET(PLUGIN_RES_FILES ${RES_FILES})
    SET(PLUGIN_H_FILES ${H_FILES})
    
  ELSE(NOT PLUGIN_CPP_FILES)
    MESSAGE(STATUS "Using PLUGIN_CPP_FILES for plugin ${PLUGIN_NAME}")
  ENDIF(NOT PLUGIN_CPP_FILES)
  
  SET(PLUGIN_OUTPUT_DIR ${PLUGINS_OUTPUT_BASE_DIR}/${PLUGIN_NAME})
  FILE(MAKE_DIRECTORY ${PLUGIN_OUTPUT_DIR})
  
  # Copy the META-INF directory into the binary output dir
  SET (LIBRARY_OUTPUT_PATH ${PLUGIN_OUTPUT_DIR}/bin)
  SOURCE_GROUP("Plugin META Files" FILES ${CMAKE_CURRENT_SOURCE_DIR}/META-INF/MANIFEST.MF)
  SET (PLUGIN_META_FILES ${PLUGIN_META_FILES} ${CMAKE_CURRENT_SOURCE_DIR}/META-INF/MANIFEST.MF)
  CONFIGURE_FILE(${CMAKE_CURRENT_SOURCE_DIR}/META-INF/MANIFEST.MF ${PLUGIN_OUTPUT_DIR}/META-INF/MANIFEST.MF COPYONLY)
  
  # Copy the plugin.xml into the binary output dir
  SET(PLUGINXML ${CMAKE_CURRENT_SOURCE_DIR}/plugin.xml)
  IF(EXISTS ${PLUGINXML})
    SOURCE_GROUP("Plugin META Files" FILES ${PLUGINXML})
    SET (PLUGIN_META_FILES ${PLUGIN_META_FILES} ${CMAKE_CURRENT_SOURCE_DIR}/plugin.xml)
    CONFIGURE_FILE(${PLUGINXML} ${PLUGIN_OUTPUT_DIR}/plugin.xml COPYONLY)
  ENDIF(EXISTS ${PLUGINXML})
  
 
  # set include directories
  FOREACH(plugin_dependency ${PLUGIN_DEPENDS_ON})
    FIND_PLUGIN_SRC_PATH(plugin_include_path ${plugin_dependency})
    MESSAGE(STATUS "ADDING INCLUDE DIR FOR DEPENDENCY ${plugin_dependency}: ${plugin_include_path}")
    INCLUDE_DIRECTORIES(${plugin_include_path})
  ENDFOREACH(plugin_dependency)
  
  # set link directories
  # this is needed for external projects where cmake does not know about
  # the libraries this plugin depends on
  PLUGIN_ADD_LINK_DIRECTORIES()


  SET(PLUGIN_GENERATED_FILES "")
  IF(PLUGIN_UI_FILES)
    QT4_WRAP_UI(PLUGIN_GENERATED_FILES ${PLUGIN_UI_FILES})
  ENDIF(PLUGIN_UI_FILES)
  IF(PLUGIN_MOC_H_FILES)
    QT4_WRAP_CPP(PLUGIN_GENERATED_FILES ${PLUGIN_MOC_H_FILES})
  ENDIF(PLUGIN_MOC_H_FILES)
  IF(PLUGIN_RES_FILES)
    QT4_ADD_RESOURCES(PLUGIN_GENERATED_FILES ${PLUGIN_RES_FILES})
  ENDIF(PLUGIN_RES_FILES)
  
  INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR})
  
  MACRO_ORGANIZE_SOURCES(INPUT ${PLUGIN_CPP_FILES} 
                         ${PLUGIN_UI_FILES} 
                         ${PLUGIN_MOC_H_FILES}
                         ${PLUGIN_RES_FILES}
                         ${PLUGIN_H_FILES}
                         GENERATED ${PLUGIN_GENERATED_FILES})
                         
  SET(_all_target_files
      ${PLUGIN_CPP_FILES} 
      ${PLUGIN_UI_FILES} 
      ${PLUGIN_MOC_H_FILES}
      ${PLUGIN_RES_FILES}
      ${PLUGIN_H_FILES}
      ${PLUGIN_GENERATED_FILES}
      ${GLOBBED_DOX_FILES}
      ${CORRESPONDING__H_FILES}
      ${CORRESPONDING__TXX_FILES}
      )
  
  IF(OPENCHERRY_STATIC)
    ADD_LIBRARY(${PLUGIN_TARGET} STATIC ${_all_target_files})
  ELSE(OPENCHERRY_STATIC)
    ADD_LIBRARY(${PLUGIN_TARGET} SHARED ${_all_target_files})
    FOREACH(plugin_dependency ${PLUGIN_DEPENDS_ON})
      STRING(REPLACE . _ plugin_deplib ${plugin_dependency})
      MESSAGE(STATUS "ADDING LINK LIBRARY: ${plugin_deplib}")
      TARGET_LINK_LIBRARIES(${PLUGIN_TARGET} ${plugin_deplib})
    ENDFOREACH(plugin_dependency)
  ENDIF(OPENCHERRY_STATIC)

  SET_TARGET_PROPERTIES(${PLUGIN_TARGET} PROPERTIES PREFIX lib IMPORT_PREFIX lib)

ENDMACRO(CREATE_PLUGIN)


# Macro to set specific Qt options, calls CREATE_PLUGIN at the end
MACRO(CREATE_QT_PLUGIN)
  
  IF(QT4_FOUND)
    INCLUDE_DIRECTORIES(${QT_INCLUDES})
    ADD_DEFINITIONS(${QT_DEFINITIONS})
  
    CREATE_PLUGIN()
  
    TARGET_LINK_LIBRARIES(${PLUGIN_TARGET} ${QT_LIBRARIES})
  ENDIF(QT4_FOUND)
  
ENDMACRO(CREATE_QT_PLUGIN)

