#
# CMake setup to generate a C++ library from Martin Held's VRONI sources.
#
# Copyright (C) 2011 Claus Christmann
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#


project(libvroni CXX C)
cmake_minimum_required(VERSION 2.8)


# load my CMake Stuff
get_filename_component(_cc_projects_DIR ${CMAKE_CURRENT_LIST_DIR}/../../..  ABSOLUTE)
list(APPEND CMAKE_PREFIX_PATH ${_cc_projects_DIR})
list(APPEND CMAKE_MODULE_PATH "${_cc_projects_DIR}/CMake/Modules")
include(cc_general) 

include_directories(${PROJECT_BINARY_DIR})

# Locate the necessary libraries VRONI needs to link to
message("Looking for graphics packages...")
find_package(X11)
  message("  X11:   " ${X11_FOUND})
find_package(GLUT)
  message("  GLUT:  " ${GLUT_FOUND})
find_package(OpenGL)
  message("  OpenGL:" ${OPENGL_FOUND})
find_library(M_LIB m)
  message("  m     :" ${M_LIB})



# in order to keep the cmake stuff out of the VRONI sources the CMakeList.txt file is not parallel to the source code.
# SRC_DIR holds the path to the actual files
set(SRC_DIR src)

# include the file holding the lists of source files from that subdirectory
# this file should declare the variables 
#
# VRONI_SRCS_FILES, VRONI_SRCS_FILES_EXE, and VRONI_SRCS_FILES_INDIRECT 
#
# as well as a list of preprocessor flags (that Held sets as defaults) in 
#
# HELDS_DEFAULT_D and HELDS_DEFAULT_U
include( ${SRC_DIR}/CMakeLists.txt )

# combine the actual source file names with their path to get fully qualified path/name combinations
# this is just lazyness as it saves adding "path_to_file/" in front of all the source files' names above
foreach( SRC_FILE ${VRONI_SRCS_FILES} )
  set(LIBVRONI_SRCS ${LIBVRONI_SRCS} ${SRC_DIR}/${SRC_FILE})
endforeach()


# load the options for the compilation
# this file should define the list ALL_VRONI_PREPROCESSOR_OPTIONS and each of them should be set to either ON or OFF
include( CMakeOptions.txt )

# setting the options for the preprocessor
message("\nThe VRONI compiler flags are:")
set( vflags )
foreach( VRONI_OPTION ${ALL_VRONI_PREPROCESSOR_OPTIONS} )
  message("  " ${VRONI_OPTION} "=" ${${VRONI_OPTION}})
  if( ${VRONI_OPTION} )
    add_definitions(-D${VRONI_OPTION})
    set( vflags ${vflags} " " -D${VRONI_OPTION} )
  else( ${VRONI_OPTION} )
    add_definitions(-U${VRONI_OPTION})
    set( vflags ${vflags} " " -U${VRONI_OPTION} )
  endif( ${VRONI_OPTION} )
endforeach ()
message( ${vflags} )


# as we need to keep track of the options in order to be able to properly 
# include the headers files, generate a header file that notes all the options
configure_file(
  ${PROJECT_SOURCE_DIR}/CMakeCompileOptionsTemplate.h.in
  ${PROJECT_BINARY_DIR}/vronidefines.h 
)

set(VRONI_HEADERS
  ${PROJECT_BINARY_DIR}/vronidefines.h
  ${SRC_DIR}/defs.h 
  ${SRC_DIR}/header.h 
  ${SRC_DIR}/ext_appl_inout.h 
  ${SRC_DIR}/ext_appl_defs.h
  ${SRC_DIR}/martin.h
  ${SRC_DIR}/vroni.h 
)


add_library_shared_and_static(vroni LIBVRONI_SRCS) 

# setting the linker language seems to allow to set the BOOL_DEFINED option to ON
set_target_properties(${LIB_VRONI_TARGETS}
 PROPERTIES
  LINKER_LANGUAGE CXX
)
target_link_libraries(${LIB_VRONI_TARGETS}
  ${OPENGL_LIBRARIES}
  ${GLUT_LIBRARIES}
  ${X11_LIBRARIES}
)

install(TARGETS ${LIB_VRONI_TARGETS}
  ARCHIVE DESTINATION ${archive_DIR}
  LIBRARY DESTINATION ${library_DIR}
)

install(FILES ${VRONI_HEADERS}
  DESTINATION ${headers_DIR}/vroni
)



# # build the original VRONI application
# add_executable(vroni ${VRONI_SRCS_FILES_EXE})
# target_link_libraries(vroni 
#   ${LIB_VRONI}
# )

