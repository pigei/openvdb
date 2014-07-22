PROJECT(OPENVDB)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8.3)

ADD_DEFINITIONS(-DUNICODE)
if(WIN32)
  #enable M_PI constant in math.h and avoid redefinition of min max as macros and allow compile as a DLL
  ADD_DEFINITIONS(-D_USE_MATH_DEFINES -DNOMINMAX -DOPENVDB_DLL)
endif(WIN32)


# EIGEN SPEED UP, remove me for a real debug!!
if(WIN32)
	SET(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /DNDEBUG")
	SET(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} /DNDEBUG")
endif(WIN32)

SET_PROPERTY(GLOBAL PROPERTY USE_FOLDERS ON)
SET(CMAKE_DEBUG_POSTFIX "d")
LIST(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/CMakeModules")

############################## Setup project version and set the link to version.h and version.rc
# Included project can access these information using OPENVDB_VERSION, VERSION_H_IN and VERSION_RC_IN
# Remember to call CONFIGURE_FILE( VERSION_RC_IN ${PROJECT_BINARY_DIR}/version.rc) to generate the resource file
INCLUDE(OPENVDBVersion)

############################## Setup output directories
SET(LIBRARY_OUTPUT_PATH ${PROJECT_BINARY_DIR}/bin CACHE PATH "Single directory for all libraries")
SET(EXECUTABLE_OUTPUT_PATH  ${PROJECT_BINARY_DIR}/bin CACHE PATH "Single directory for all executables")
SET(CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR}/installation)
MARK_AS_ADVANCED(LIBRARY_OUTPUT_PATH EXECUTABLE_OUTPUT_PATH)

# INCLUDE(NUVERCodeSigning) # TODO when project will reach a stable version

#ADD_DEFINITIONS(-DUNICODE)

#macro(get_WIN32_WINNT version)
#    if (WIN32 AND CMAKE_SYSTEM_VERSION)
#        set(ver ${CMAKE_SYSTEM_VERSION})
#        string(REPLACE "." "" ver ${ver})
#        string(REGEX REPLACE "([0-9])" "0\\1" ver ${ver})

#        set(${version} "0x${ver}")
#    endif()
#endmacro()

#get_WIN32_WINNT(ver)
#add_definitions(-D_WIN32_WINNT=${ver})
#SET(Boost_DEBUG ON)
#SET(Boost_DETAILED_FAILURE_MSG ON)
#SET(Boost_USE_STATIC_LIBS OFF)
#SET(Boost_USE_MULTITHREAD ON)
#set(Boost_USE_STATIC_RUNTIME    OFF)
#add_definitions( -DBOOST_ALL_NO_LIB )
FIND_PACKAGE(Boost REQUIRED) 
INCLUDE_DIRECTORIES(${Boost_INCLUDE_DIRS})
LINK_DIRECTORIES( ${Boost_LIBRARY_DIRS} )
MESSAGE(STATUS "Boost_INCLUDE_DIR    : ${Boost_INCLUDE_DIR}")
MESSAGE(STATUS "Boost_LIBRARIES      : ${Boost_LIBRARIES}")
MESSAGE(STATUS "Boost_LIBRARY_DIRS   : ${Boost_LIBRARY_DIRS}") 
message(STATUS "BOOST_ROOT : $ENV{BOOST_ROOT}")

####################### requirements
FIND_PACKAGE(ZLIB REQUIRED)
ADD_DEFINITIONS(-DZLIB_WINAPI)
INCLUDE_DIRECTORIES(${ZLIB_INCLUDE_PATH})

FIND_PACKAGE(OPENEXRHALF REQUIRED)
INCLUDE_DIRECTORIES(${OPENEXRHALF_INCLUDE_PATH})

FIND_PACKAGE(TBB REQUIRED)
INCLUDE_DIRECTORIES(${TBB_INCLUDE_PATH})

##############################  Setup testing projects

SET(OPENVDB_TEST_DATA_PATH ${PROJECT_BINARY_DIR}/../test_data/ CACHE PATH "A folder containing the tests data files")
ENABLE_TESTING()

######################################################################################################################################################
######################################################################################################################################################
######################################################################################################################################################
################################################  Project specification, add files directly here...  #################################################
# io, math, metadata, tools, tree, util
PROJECT(OPENVDBLIB)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8.3)
SET(VERSION_H_IN  ${PROJECT_SOURCE_DIR}/CMakeConf/version.h.in)
SET(VERSION_RC_IN ${PROJECT_SOURCE_DIR}/CMakeConf/version.rc.in)

CONFIGURE_FILE( ${VERSION_RC_IN} ${PROJECT_BINARY_DIR}/version.rc)
CONFIGURE_FILE( ${VERSION_H_IN} ${PROJECT_BINARY_DIR}/version.h)

FILE(GLOB OPENVDBLIB_HDRS_FILES *.h ) 
FILE(GLOB OPENVDBLIB_HDRS_FILES_IO io/*.h)
FILE(GLOB OPENVDBLIB_HDRS_FILES_MATH math/*.h)
FILE(GLOB OPENVDBLIB_HDRS_FILES_METADATA metadata/*.h)  
FILE(GLOB OPENVDBLIB_HDRS_FILES_TOOLS tools/*.h)
FILE(GLOB OPENVDBLIB_HDRS_FILES_TREE tree/*.h)
FILE(GLOB OPENVDBLIB_HDRS_FILES_UTIL util/*.h)

FILE(GLOB OPENVDBLIB_SRCS_FILES *.cc)
FILE(GLOB OPENVDBLIB_SRCS_FILES_IO io/*.cc)
FILE(GLOB OPENVDBLIB_SRCS_FILES_MATH math/*.cc)
FILE(GLOB OPENVDBLIB_SRCS_FILES_METADATA metadata/*.cc)  
FILE(GLOB OPENVDBLIB_SRCS_FILES_TOOLS tools/*.cc)
FILE(GLOB OPENVDBLIB_SRCS_FILES_TREE tree/*.cc)
FILE(GLOB OPENVDBLIB_SRCS_FILES_UTIL util/*.cc)

SOURCE_GROUP("io" FILES ${OPENVDBLIB_HDRS_FILES_IO} ${OPENVDBLIB_SRCS_FILES_IO})
SOURCE_GROUP("math" FILES ${OPENVDBLIB_HDRS_FILES_MATH} ${OPENVDBLIB_SRCS_FILES_MATH})
SOURCE_GROUP("metadata" FILES ${OPENVDBLIB_HDRS_FILES_METADATA} ${OPENVDBLIB_SRCS_FILES_METADATA})
SOURCE_GROUP("tools" FILES ${OPENVDBLIB_HDRS_FILES_TOOLS} ${OPENVDBLIB_SRCS_FILES_TOOLS})
SOURCE_GROUP("tree" FILES ${OPENVDBLIB_HDRS_FILES_TREE} ${OPENVDBLIB_SRCS_FILES_TREE})
SOURCE_GROUP("util" FILES ${OPENVDBLIB_HDRS_FILES_UTIL} ${OPENVDBLIB_SRCS_FILES_UTIL})

INCLUDE_DIRECTORIES(${CMAKE_SOURCE_DIR}/..)
INCLUDE_DIRECTORIES(${CMAKE_SOURCE_DIR})
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_BINARY_DIR})
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR})

ADD_LIBRARY(${PROJECT_NAME}  SHARED
	${OPENVDBLIB_HDRS_FILES} ${OPENVDBLIB_HDRS_FILES_IO} ${OPENVDBLIB_HDRS_FILES_MATH} ${OPENVDBLIB_HDRS_FILES_METADATA} ${OPENVDBLIB_HDRS_FILES_TOOLS} ${OPENVDBLIB_HDRS_FILES_TREE} ${OPENVDBLIB_HDRS_FILES_UTIL}
	${OPENVDBLIB_SRCS_FILES} ${OPENVDBLIB_SRCS_FILES_IO} ${OPENVDBLIB_SRCS_FILES_MATH} ${OPENVDBLIB_SRCS_FILES_METADATA} ${OPENVDBLIB_SRCS_FILES_TOOLS} ${OPENVDBLIB_SRCS_FILES_TREE} ${OPENVDBLIB_SRCS_FILES_UTIL}  
  ${PROJECT_BINARY_DIR}/version.rc
)
TARGET_LINK_LIBRARIES(${PROJECT_NAME} ${Boost_LIBRARIES} ${ZLIB_LIBRARY} ${OPENEXRHALF_LIBRARY} ${TBB_LIBRARY})

# /bigobj is required for windows builds because of the size of
# some object files (tree)
set_target_properties(${PROJECT_NAME} PROPERTIES COMPILE_FLAGS "/bigobj /DOPENVDB_PRIVATE")
SET_TARGET_PROPERTIES(${PROJECT_NAME} PROPERTIES VERSION ${OPENVDB_VERSION})
SET_TARGET_PROPERTIES(${PROJECT_NAME} PROPERTIES FOLDER OPENVDBLIB)
SET_TARGET_PROPERTIES(${PROJECT_NAME} PROPERTIES STATIC_LIBRARY_FLAGS \"/machine:x64\")


############################## Install
INSTALL(TARGETS ${PROJECT_NAME} 
	RUNTIME DESTINATION bin COMPONENT Runtime
	LIBRARY DESTINATION lib COMPONENT Development
	ARCHIVE DESTINATION lib COMPONENT Development)
	
#copy header files to include directory
INSTALL(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} DESTINATION include COMPONENT Development FILES_MATCHING PATTERN "*.h" )

######################################################################################################################################################
######################################################################################################################################################
######################################################################################################################################################
################################################  Project specification, add files directly here...  #################################################
PROJECT(OPENVDBVIEWER)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8.3)

# OpenGL
FIND_PACKAGE(OpenGL REQUIRED)
if(NOT OPENGL_FOUND)
    message(ERROR " OPENGL not found!")
endif(NOT OPENGL_FOUND)

FIND_PACKAGE(GLEW REQUIRED)
INCLUDE_DIRECTORIES(${GLEW_INCLUDE_PATH})

FIND_PACKAGE(GLFW REQUIRED)
INCLUDE_DIRECTORIES(${GLFW_INCLUDE_PATH})


FILE(GLOB OPENVDBVIEWER_HDRS_FILES viewer/*.h ) 
FILE(GLOB OPENVDBVIEWER_SRCS_FILES viewer/*.cc)

INCLUDE_DIRECTORIES(${CMAKE_SOURCE_DIR}/..)
INCLUDE_DIRECTORIES(${CMAKE_SOURCE_DIR})
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_BINARY_DIR})
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR})

ADD_LIBRARY(${PROJECT_NAME} STATIC
	${OPENVDBVIEWER_HDRS_FILES}
	${OPENVDBVIEWER_SRCS_FILES}
  ${PROJECT_BINARY_DIR}/version.rc
)
ADD_DEPENDENCIES(${PROJECT_NAME} OPENVDBLIB)
TARGET_LINK_LIBRARIES(${PROJECT_NAME} ${Boost_LIBRARIES} ${ZLIB_LIBRARY} ${OPENGL_LIBRARIES} ${GLEW_LIBRARY} ${GLFW_LIBRARY} ${OPENEXRHALF_LIBRARY} ${TBB_LIBRARY} OPENVDBLIB)

# /bigobj is required for windows builds because of the size of
# some object files (tree)
set_target_properties(${PROJECT_NAME} PROPERTIES COMPILE_FLAGS "/bigobj")
SET_TARGET_PROPERTIES(${PROJECT_NAME} PROPERTIES VERSION ${OPENVDB_VERSION})
SET_TARGET_PROPERTIES(${PROJECT_NAME} PROPERTIES FOLDER OPENVDBVIEWER)
SET_TARGET_PROPERTIES(${PROJECT_NAME} PROPERTIES STATIC_LIBRARY_FLAGS \"/machine:x64\")

############################## Install
INSTALL(TARGETS ${PROJECT_NAME} 
	RUNTIME DESTINATION bin COMPONENT Runtime
	LIBRARY DESTINATION lib COMPONENT Development
	ARCHIVE DESTINATION lib COMPONENT Development)
	
#copy header files to include directory
INSTALL(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} DESTINATION include COMPONENT Development FILES_MATCHING PATTERN "*.h" )



######################################################################################################################################################
######################################################################################################################################################
######################################################################################################################################################
################################################  Project specification, add files directly here...  #################################################
PROJECT(OPENVDBVIEWER_APP)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8.3)

FILE(GLOB OPENVDBVIEWER_APP_HDRS_FILES cmd/openvdb_view/*.h ) 
FILE(GLOB OPENVDBVIEWER_SRCS_FILES cmd/openvdb_view/*.cc)

INCLUDE_DIRECTORIES(${CMAKE_SOURCE_DIR}/..)
INCLUDE_DIRECTORIES(${CMAKE_SOURCE_DIR})
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_BINARY_DIR})
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR})

ADD_EXECUTABLE(${PROJECT_NAME}
	${OPENVDBVIEWER_APP_HDRS_FILES}
	${OPENVDBVIEWER_SRCS_FILES}
  ${PROJECT_BINARY_DIR}/version.rc
)
ADD_DEPENDENCIES(${PROJECT_NAME} OPENVDBLIB OPENVDBVIEWER)
TARGET_LINK_LIBRARIES(${PROJECT_NAME} ${Boost_LIBRARIES} ${ZLIB_LIBRARY} ${OPENGL_LIBRARIES} ${GLEW_LIBRARY} ${GLFW_LIBRARY} ${OPENEXRHALF_LIBRARY} ${TBB_LIBRARY} OPENVDBLIB OPENVDBVIEWER)

# /bigobj is required for windows builds because of the size of
# some object files (tree)
set_target_properties(${PROJECT_NAME} PROPERTIES COMPILE_FLAGS "/bigobj")
set_target_properties(${PROJECT_NAME} PROPERTIES LINK_FLAGS "/FORCE:MULTIPLE")
SET_TARGET_PROPERTIES(${PROJECT_NAME} PROPERTIES VERSION ${OPENVDB_VERSION})
SET_TARGET_PROPERTIES(${PROJECT_NAME} PROPERTIES FOLDER OPENVDBVIEWER_APP)

############################## Install
INSTALL(TARGETS ${PROJECT_NAME} 
	RUNTIME DESTINATION bin COMPONENT Runtime
	LIBRARY DESTINATION lib COMPONENT Development
	ARCHIVE DESTINATION lib COMPONENT Development)
	
#copy header files to include directory
INSTALL(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} DESTINATION include COMPONENT Development FILES_MATCHING PATTERN "*.h" )


######################################################################################################################################################
######################################################################################################################################################
######################################################################################################################################################
################################################  Project specification, add files directly here...  #################################################
PROJECT(OPENVDB_PRINT)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8.3)

FILE(GLOB OPENVDBVIEWER_APP_HDRS_FILES cmd/openvdb_print/*.h ) 
FILE(GLOB OPENVDBVIEWER_SRCS_FILES cmd/openvdb_print/*.cc)

INCLUDE_DIRECTORIES(${CMAKE_SOURCE_DIR}/..)
INCLUDE_DIRECTORIES(${CMAKE_SOURCE_DIR})
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_BINARY_DIR})
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR})

ADD_EXECUTABLE(${PROJECT_NAME}
	${OPENVDBVIEWER_APP_HDRS_FILES}
	${OPENVDBVIEWER_SRCS_FILES}
  ${PROJECT_BINARY_DIR}/version.rc
)
ADD_DEPENDENCIES(${PROJECT_NAME} OPENVDBLIB OPENVDBVIEWER)
TARGET_LINK_LIBRARIES(${PROJECT_NAME} ${Boost_LIBRARIES} ${ZLIB_LIBRARY} ${OPENEXRHALF_LIBRARY} ${TBB_LIBRARY} OPENVDBLIB)

# /bigobj is required for windows builds because of the size of
# some object files (tree)
set_target_properties(${PROJECT_NAME} PROPERTIES COMPILE_FLAGS "/bigobj")
set_target_properties(${PROJECT_NAME} PROPERTIES LINK_FLAGS "/FORCE:MULTIPLE")
SET_TARGET_PROPERTIES(${PROJECT_NAME} PROPERTIES VERSION ${OPENVDB_VERSION})
SET_TARGET_PROPERTIES(${PROJECT_NAME} PROPERTIES FOLDER OPENVDBVIEWER_APP)

############################## Install
INSTALL(TARGETS ${PROJECT_NAME} 
	RUNTIME DESTINATION bin COMPONENT Runtime
	LIBRARY DESTINATION lib COMPONENT Development
	ARCHIVE DESTINATION lib COMPONENT Development)
	
#copy header files to include directory
INSTALL(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} DESTINATION include COMPONENT Development FILES_MATCHING PATTERN "*.h" )

######################################################################################################################################################
######################################################################################################################################################
######################################################################################################################################################
################################################  Project specification, add files directly here...  #################################################
#PROJECT(OPENVDB_RENDER)
#CMAKE_MINIMUM_REQUIRED(VERSION 2.8.3)

#FILE(GLOB OPENVDBVIEWER_APP_HDRS_FILES cmd/openvdb_render/*.h ) 
#FILE(GLOB OPENVDBVIEWER_SRCS_FILES cmd/openvdb_render/*.cc)

#INCLUDE_DIRECTORIES(${CMAKE_SOURCE_DIR}/..)
#INCLUDE_DIRECTORIES(${CMAKE_SOURCE_DIR})
#INCLUDE_DIRECTORIES(${CMAKE_CURRENT_BINARY_DIR})
#INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR})
#
#ADD_EXECUTABLE(${PROJECT_NAME}
#	${OPENVDBVIEWER_APP_HDRS_FILES}
#	${OPENVDBVIEWER_SRCS_FILES}
#  ${PROJECT_BINARY_DIR}/version.rc
#)
#ADD_DEPENDENCIES(${PROJECT_NAME} OPENVDBLIB)
#TARGET_LINK_LIBRARIES(${PROJECT_NAME} ${Boost_LIBRARIES} ${ZLIB_LIBRARY} ${OPENEXRHALF_LIBRARY} ${TBB_LIBRARY} OPENVDBLIB)

# /bigobj is required for windows builds because of the size of
# some object files (tree)
#set_target_properties(${PROJECT_NAME} PROPERTIES COMPILE_FLAGS "/bigobj")
#set_target_properties(${PROJECT_NAME} PROPERTIES LINK_FLAGS "/FORCE:MULTIPLE")
#SET_TARGET_PROPERTIES(${PROJECT_NAME} PROPERTIES VERSION ${OPENVDB_VERSION})
#SET_TARGET_PROPERTIES(${PROJECT_NAME} PROPERTIES FOLDER OPENVDBVIEWER_APP)

############################## Install
#INSTALL(TARGETS ${PROJECT_NAME} 
#	RUNTIME DESTINATION bin COMPONENT Runtime
#	LIBRARY DESTINATION lib COMPONENT Development
#	ARCHIVE DESTINATION lib COMPONENT Development)
	
#copy header files to include directory
#INSTALL(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} DESTINATION include COMPONENT Development FILES_MATCHING PATTERN "*.h" )

########################################################################################################################  
########################################################################################################################  
########################################################################################################################  
########################################################################################################################  
########################################################################################################################  
########################################################################################################################  
########################################################################################################################  
########################################################################################################################  
########################################################################################################################  
########################################################################################################################  
########################################################################################################################  
########################################################################################################################  
########################################################################################################################  
############################## Install

PROJECT(OPENVDB)
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR})
add_subdirectory(tests)
add_subdirectory(samples)
