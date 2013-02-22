set(baseDir "framework/sofa/helper/system/")
foreach(sourceFile "${baseDir}gl.h" "${baseDir}glu.h" "${baseDir}glut.h" "${baseDir}../gl/glfont.cpp")
  file(STRINGS ${sourceFile} sourceCode NEWLINE_CONSUME)
  string(REGEX REPLACE "<(Open)?GL(UT)?/" "<" sourceCode ${sourceCode})
  set(CONTENTS ${sourceCode})
  configure_file(${TEMPLATE_FILE} ${sourceFile} @ONLY)
endforeach()

set(sourceFile "modules/sofa/component/linearsolver/SSORPreconditioner.inl")
file(STRINGS ${sourceFile} sourceCode NEWLINE_CONSUME)
string(REGEX REPLACE "getM" "this->getM" sourceCode ${sourceCode})
set(CONTENTS ${sourceCode})
configure_file(${TEMPLATE_FILE} ${sourceFile} @ONLY)
