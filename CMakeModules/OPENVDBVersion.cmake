############################## Setup project version and set the link to version.h and version.rc
# Included project can access these information using OPENVDB_VERSION, VERSION_H_IN and VERSION_RC_IN
# Remember to call CONFIGURE_FILE( VERSION_RC_IN ${PROJECT_BINARY_DIR}/version.rc) to generate the resource file
SET(VERSION_MAJOR 0  CACHE STRING "Major version" FORCE)
SET(VERSION_MINOR 1 CACHE STRING "Minor version" FORCE)
SET(VERSION_PATCH 0  CACHE STRING "Patch version" FORCE)
SET(VERSION_BUILD 0  CACHE STRING "Build version")

MATH(EXPR VERSION_BUILD ${VERSION_BUILD}+1)
SET(VERSION_BUILD ${VERSION_BUILD} CACHE STRING "Build version" FORCE)
SET(OPENVDB_VERSION "${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}.${VERSION_BUILD}")

SET(OPENVDB_ORGANIZATION_NAME "" CACHE STRING "Organization name used for registry and dll authentication")
SET(OPENVDB_ORGANIZATION_DOMAIN "" CACHE STRING "Organization domain used for registry and dll authentication")
SET(OPENVDB_APPLICATION_NAME "OPENVDB" CACHE STRING "Application name used for registry and dll authentication")

SET(VERSION_H_IN  ${PROJECT_SOURCE_DIR}/CMakeConf/version.h.in)
SET(VERSION_RC_IN ${PROJECT_SOURCE_DIR}/CMakeConf/version.rc.in)

set (PROJECT_VER "${PROJECT_VER_MAJOR}.${PROJECT_VER_MINOR}.${PROJECT_VER_PATCH}")
set (PROJECT_APIVER "${PROJECT_VER_MAJOR}.${PROJECT_VER_MINOR}") 