#
# Find the include directory
# =======================
#
find_path(VRONI_INCLUDE_DIR vroni.h PATH_SUFFIXES vroni)

#debug output
if( NOT Vroni_FIND_QUIETLY )
  if( NOT VRONI_INCLUDE_DIR )
    message(SEND_ERROR ${VRONI_INCLUDE_DIR})
  else( NOT Vroni_FIND_QUIETLY )
    message(STATUS "Vroni include directory is " ${VRONI_INCLUDE_DIR} )
  endif( NOT VRONI_INCLUDE_DIR )
endif( NOT Vroni_FIND_QUIETLY )


#
# Find the actual library
# =======================
#

# Support preference of static libs by adjusting CMAKE_FIND_LIBRARY_SUFFIXES
# 
# A CMake find module for Martin Held's VRONI.
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

if( Vroni_USE_STATIC_LIBS )
  set( _Vroni_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES})
  if(WIN32)
    set(CMAKE_FIND_LIBRARY_SUFFIXES .lib .a ${CMAKE_FIND_LIBRARY_SUFFIXES})
  else()
    set(CMAKE_FIND_LIBRARY_SUFFIXES .a )
  endif()
endif( Vroni_USE_STATIC_LIBS )

# do the finding
find_library(VRONI_Vroni_LIBRARY vroni)

# Restore the original find library ordering
if( Vroni_USE_STATIC_LIBS )
  set(CMAKE_FIND_LIBRARY_SUFFIXES ${_Vroni_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES})
endif(Vroni_USE_STATIC_LIBS)




# debug output
if( NOT Vroni_FIND_QUIETLY )
  if( NOT VRONI_Vroni_LIBRARY )
    message(SEND_ERROR ${VRONI_Vroni_LIBRARY})
  else( NOT VRONI_Vroni_LIBRARY )
    message(STATUS "Vroni has been found as " ${VRONI_Vroni_LIBRARY} )
  endif( NOT VRONI_Vroni_LIBRARY )
endif( NOT Vroni_FIND_QUIETLY )

# find_path(VRONI_INCLUDE_DIR xxx.h)
# find_library(VRONI_xxx_LIBRARY xxx)
# find_library(VRONI_yyy_LIBRARY yyy)


#
# Prepare the standard return
# ===========================
#
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(VRONI DEFAULT_MSG
  VRONI_INCLUDE_DIR VRONI_Vroni_LIBRARY)
if(VRONI_FOUND)
  set(VRONI_INCLUDE_DIRS ${VRONI_INCLUDE_DIR})
  set(VRONI_LIBRARIES ${VRONI_Vroni_LIBRARY} )
endif() 


# don't show the internal variables outside the advanced view
mark_as_advanced( 
  VRONI_INCLUDE_DIR
  VRONI_Vroni_LIBRARY
)