# Copyright 2016 Max Planck Society
# Created by Raffi Enficiaud.

# This is an internal helper for the BilateralNN code
# that patches the Caffe project

# Copies the files of the bilateral NN project onto the caffe project


# Gets the source directory
if("${BILATERALNN_SOURCE_DIR}" STREQUAL "")
  get_filename_component(BILATERALNN_SOURCE_DIR  "${CMAKE_CURRENT_LIST_DIR}" DIRECTORY)
endif()
get_filename_component(BILATERALNN_SOURCE_DIR   "${BILATERALNN_SOURCE_DIR}" ABSOLUTE)

# Gets the source directory
if("${CAFFE_SOURCE_DIR}" STREQUAL "")
  get_filename_component(current_source_directory   "${CMAKE_CURRENT_SOURCE_DIR}" DIRECTORY)
  get_filename_component(current_source_directory   "${current_source_directory}/../../caffe_srcx" ABSOLUTE)
  set(CAFFE_SOURCE_DIR ${current_source_directory})
endif()
get_filename_component(CAFFE_SOURCE_DIR   "${CAFFE_SOURCE_DIR}" ABSOLUTE)

message(STATUS "Copying files from ${BILATERALNN_SOURCE_DIR} to ${CAFFE_SOURCE_DIR}")

file(GLOB_RECURSE bilateralNN_SRC
     RELATIVE ${BILATERALNN_SOURCE_DIR}
     "${BILATERALNN_SOURCE_DIR}/cmake/External/*.*" # patches the glog problem on Ubuntu 16.04
     "${BILATERALNN_SOURCE_DIR}/utils/*.*"
     "${BILATERALNN_SOURCE_DIR}/include/*.*"
     "${BILATERALNN_SOURCE_DIR}/src/*.*"
   )

foreach(_current_file IN LISTS bilateralNN_SRC)
    # copy
    get_filename_component(current_directory "${CAFFE_SOURCE_DIR}/${_current_file}" DIRECTORY)
    get_filename_component(current_file_without_folder "${_current_file}" NAME)

    if(("${current_file_without_folder}" STREQUAL "caffe.proto")
       AND (EXISTS "${current_directory}/${current_file_without_folder}"))
      # removing line ending differences

      configure_file("${current_directory}/${current_file_without_folder}" right.proto.tmp NEWLINE_STYLE CRLF)
      configure_file("${BILATERALNN_SOURCE_DIR}/${_current_file}" left.proto.tmp NEWLINE_STYLE CRLF)

      # compares the files, lines ending agnostic
      execute_process(
        COMMAND ${CMAKE_COMMAND} -E compare_files ./left.proto.tmp ./right.proto.tmp
        RESULT_VARIABLE res_different
        OUTPUT_VARIABLE out_different
      )

      # remove the temporary files
      file(REMOVE ./left.proto.tmp ./right.proto.tmp)

      if(NOT ("${res_different}" STREQUAL "0"))
        message(STATUS "[BilateralNN] backing up previous 'caffe.proto' to 'caffe.proto.bak'")
        configure_file("${current_directory}/${current_file_without_folder}"
                       "${current_directory}/${current_file_without_folder}.bak"
                       COPYONLY)
      endif()

    endif()

    message(STATUS "[BilateralNN] copying file ${current_file_without_folder} to ${current_directory}")
    file(COPY ${BILATERALNN_SOURCE_DIR}/${_current_file}
         DESTINATION ${current_directory}
       )
endforeach()
