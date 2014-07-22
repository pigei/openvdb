# add a very simple test wig=th openvdb
add_executable(openVDBHelloWorld openVDBHelloWorld.cpp)
add_dependencies(openVDBHelloWorld OPENVDBLIB)
set_target_properties(openVDBHelloWorld PROPERTIES VERSION ${PROJECT_VER} SOVERSION ${PROJECT_APIVER})	
set_target_properties(openVDBHelloWorld PROPERTIES FOLDER OPENVDB_samples/openVDBHelloWorld)
target_link_libraries(openVDBHelloWorld OPENVDBLIB)

add_executable(openVDBLevelSetSphere openVDBLevelSetSphere.cpp)
add_dependencies(openVDBLevelSetSphere OPENVDBLIB)
set_target_properties(openVDBLevelSetSphere PROPERTIES VERSION ${PROJECT_VER} SOVERSION ${PROJECT_APIVER})	
set_target_properties(openVDBLevelSetSphere PROPERTIES FOLDER OPENVDB_samples/openVDBLevelSetSphere)
target_link_libraries(openVDBLevelSetSphere OPENVDBLIB)
